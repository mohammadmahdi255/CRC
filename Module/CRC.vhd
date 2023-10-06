library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.crc_package.all;

-- TODO FIXING REFIN
-- TODO HOLD and SETUP lost
entity CRC is
	generic
	(
		g_DATA_WIDTH : integer := 1;
		g_CRC_WIDTH  : integer := 4;
		g_POLY       : std_logic_vector := x"04C11DB7";
		g_INIT       : std_logic_vector := x"FFFFFFFF";
		g_XOROUT     : std_logic_vector := x"FFFFFFFF";
		g_REFIN      : std_logic := '1';
		g_REFOUT     : std_logic := '1'
	);
	port
	(
		i_RST_N  : in  std_logic;
		i_CLK    : in  std_logic;
		i_EN     : in  std_logic;

		i_DATA   : in  std_logic_vector (8 * g_DATA_WIDTH - 1 downto 0);
		o_CRC    : out std_logic_vector (8 * g_CRC_WIDTH - 1 downto 0)
	);
end CRC;

architecture RTL of CRC is

	type t_CRC_ARRAY is array (0 to 8 * g_DATA_WIDTH - 1) of std_logic_vector (8 * g_CRC_WIDTH - 1 downto 0);
	
	constant c_ZERO     : std_logic_vector (8 * g_DATA_WIDTH - 1 downto 0) := (others => '0');

	signal w_CRC   : t_CRC_ARRAY;
	signal w_DATA  : std_logic_vector (0 to 8 * g_DATA_WIDTH - 1);
	signal w_INIT  : std_logic_vector (8 * g_DATA_WIDTH - 1 downto 0);
	
	signal r_CRC    : std_logic_vector (8 * g_CRC_WIDTH - 1 downto 0) := (others => '0');
	signal r_INIT   : std_logic_vector (8 * g_CRC_WIDTH - 1 downto 0) := g_INIT;
	
begin

	Sequential : process (i_RST_N, i_CLK)
	begin
		if i_RST_N = '0' then
			r_CRC <= (others => '0');
			r_INIT <= g_INIT;
			
		elsif falling_edge(i_CLK) and i_EN = '1' then
			r_CRC <= w_CRC(8 * g_DATA_WIDTH - 1);
			if g_DATA_WIDTH < g_CRC_WIDTH  then
				r_INIT <= r_INIT(8 * (g_CRC_WIDTH - g_DATA_WIDTH) - 1 downto 0) & c_ZERO;
			else
				r_INIT <= (others => '0');
			end if;
		end if;
	end process Sequential;

	combinational : process (w_DATA, r_CRC, w_CRC)
	begin
		w_CRC(0) <= crc_calculation(w_DATA(0), r_CRC, g_POLY);

		for i in 1 to 8 * g_DATA_WIDTH - 1 loop
			w_CRC(i) <= crc_calculation(w_DATA(i), w_CRC(i - 1), g_POLY);
		end loop;

	end process combinational;

	w_INIT <= r_INIT(8 * g_CRC_WIDTH - 1 downto 8 * (g_CRC_WIDTH - g_DATA_WIDTH));
--	w_INIT <= r_INIT(8 * g_DATA_WIDTH - 1 downto 0);
	w_DATA <= i_DATA xor w_INIT when g_REFIN = '0' else
			reverse(i_DATA xor w_INIT);
			
	o_CRC <= r_CRC xor g_XOROUT when g_REFOUT = '0' else
		reverse(r_CRC xor g_XOROUT);
end RTL;
