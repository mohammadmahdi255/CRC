library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.crc_package.all;

entity CRC is
	generic
	(
		g_DATA_WIDTH : integer := 16;
		g_CRC_WIDTH  : integer := 16
	);
	port
	(
		i_RST_N  : in  std_logic;
		i_CLK    : in  std_logic;
		i_EN     : in  std_logic;

		i_POLY   : in  std_logic_vector (g_CRC_WIDTH - 1 downto 0);
		i_INIT   : in  std_logic_vector (g_CRC_WIDTH - 1 downto 0);
		i_XOROUT : in  std_logic_vector (g_CRC_WIDTH - 1 downto 0);
		i_REFIN  : in  std_logic;
		i_REFOUT : in  std_logic;

		i_DATA   : in  std_logic_vector (g_DATA_WIDTH - 1 downto 0);
		o_CRC    : out std_logic_vector (g_CRC_WIDTH - 1 downto 0)
	);
end CRC;

architecture RTL of CRC is

	type t_CRC_ARRAY is array (0 to g_DATA_WIDTH - 1) of std_logic_vector (g_CRC_WIDTH - 1 downto 0);
	
	constant c_ZERO     : std_logic_vector (g_DATA_WIDTH - 1 downto 0) := (others => '0');

	signal w_CRC   : t_CRC_ARRAY;
	signal w_DATA  : std_logic_vector (g_DATA_WIDTH - 1 downto 0);
	signal w_INIT  : std_logic_vector (g_DATA_WIDTH - 1 downto 0);
	
	signal r_CRC    : std_logic_vector (g_CRC_WIDTH - 1 downto 0);
	signal r_INIT   : std_logic_vector (g_CRC_WIDTH - 1 downto 0);
	
	
	
begin

	Sequential : process (i_RST_N, i_CLK, i_INIT)
	begin
		if i_RST_N = '0' then
			r_CRC <= (others => '0');
			r_INIT <= i_INIT;
			
		elsif rising_edge(i_CLK) and i_EN = '1' then
			r_CRC <= w_CRC(g_DATA_WIDTH - 1);
			if g_CRC_WIDTH > g_DATA_WIDTH then
				r_INIT <= r_INIT(g_CRC_WIDTH - g_DATA_WIDTH - 1 downto 0) & c_ZERO;
			else
				r_INIT <= c_ZERO;
			end if;
		end if;
	end process Sequential;

	combinational : process (w_DATA, r_CRC, w_CRC, i_POLY)
	begin
		w_CRC(0) <= crc_calculation(w_DATA(0), r_CRC, i_POLY);

		for i in 1 to g_DATA_WIDTH - 1 loop
			w_CRC(i) <= crc_calculation(w_DATA(i), w_CRC(i - 1), i_POLY);
		end loop;

	end process combinational;

	w_INIT <= r_INIT(g_CRC_WIDTH - 1 downto g_CRC_WIDTH - g_DATA_WIDTH);
	w_DATA <= reverse(i_DATA xor w_INIT) when i_REFIN = '0' else
			i_DATA xor w_INIT;
	  
	o_CRC <= r_CRC xor i_XOROUT when i_REFOUT = '0' else
		reverse(r_CRC xor i_XOROUT);
end RTL;
