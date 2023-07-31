library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.CRC_Package.all;

entity CRC is
	generic
	(
		DATA_WIDTH : integer := 8;
		CRC_WIDTH  : integer := 16
	);
	port
	(
		i_RST_N  : in  std_logic;
		i_CLK    : in  std_logic;
		i_EN     : in  std_logic;

		i_POLY   : in  std_logic_vector (CRC_WIDTH - 1 downto 0);
		i_INIT   : in  std_logic_vector (CRC_WIDTH - 1 downto 0);
		i_XOROUT : in  std_logic_vector (CRC_WIDTH - 1 downto 0);
		i_REFIN  : in  std_logic;
		i_REFOUT : in  std_logic;

		i_DATA   : in  std_logic_vector (DATA_WIDTH - 1 downto 0);
		o_CRC    : out std_logic_vector (CRC_WIDTH - 1 downto 0)
	);
end CRC;

architecture RTL of CRC is

	type crc_array is array (0 to DATA_WIDTH - 1) of std_logic_vector (CRC_WIDTH - 1 downto 0);

	signal crc_values : crc_array;
	signal crc_reg    : std_logic_vector (CRC_WIDTH - 1 downto 0);
	signal data       : std_logic_vector (DATA_WIDTH - 1 downto 0);
	signal init_reg   : std_logic;
begin

	Sequential : process (i_RST_N, i_CLK, i_INIT)
	begin
		if i_RST_N = '0' then
			crc_reg <= (others => '0');
			init_reg <= '1';
			
		elsif rising_edge(i_CLK) and i_EN = '1' then
			crc_reg <= crc_values(DATA_WIDTH - 1);
			init_reg <= '0';
		end if;
	end process Sequential;

	combinational : process (data, crc_reg, crc_values, i_POLY)
	begin
		crc_values(0) <= crc_calculation(data(0), crc_reg, i_POLY);

		for i in 1 to DATA_WIDTH - 1 loop
			crc_values(i) <= crc_calculation(data(i), crc_values(i - 1), i_POLY);
		end loop;

	end process combinational;

	data <= reverse(i_DATA) when init_reg ='0' and i_REFIN = '0' else
			i_DATA when init_reg ='0' and i_REFIN = '1' else
			i_DATA xor i_INIT when init_reg ='1' and i_REFIN = '1' else
			reverse(i_DATA xor i_INIT);
	
	o_CRC <= crc_reg xor i_XOROUT when i_REFOUT = '0' else
		reverse(crc_reg xor i_XOROUT);
end RTL;
