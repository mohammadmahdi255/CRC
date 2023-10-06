library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.STD_PACKAGE.all;
use work.CRC_PACKAGE.all;

entity IEEE8023_CRC32 is
	port
	(
		i_RST_N : in  std_logic;
		i_CLK   : in  std_logic;
		i_EN    : in  std_logic;

		i_DATA  : in  t_BYTE;
		o_CRC   : out t_BYTE_VECTOR (0 to 3)
	);
end IEEE8023_CRC32;

architecture RTL of IEEE8023_CRC32 is

	type t_CRC_ARRAY is array (0 to 7) of std_logic_vector (31 downto 0);

	constant c_POLY : std_logic_vector (31 downto 0) := x"04C11DB7";

	signal w_CRC    : t_CRC_ARRAY;
	signal r_CRC    : std_logic_vector (31 downto 0) := (others => '1');

begin

	Sequential : process (i_RST_N, i_CLK)
	begin
		if i_RST_N = '0' then
			r_CRC <= (others => '0');
		elsif falling_edge(i_CLK) and i_EN = '1' then
			r_CRC <= w_CRC(7);
		end if;
	end process Sequential;

	combinational : process (i_DATA, r_CRC, w_CRC)
	begin
		w_CRC(0) <= crc_calculation(i_DATA(i_DATA'left), r_CRC, c_POLY);

		for i in 1 to 7 loop
			w_CRC(i) <= crc_calculation(i_DATA(i_DATA'left - i), w_CRC(i - 1), c_POLY);
		end loop;

	end process combinational;

	o_CRC <= to_byte_vector(r_CRC);

end RTL;
