library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CRC_8 is
	port
	(
		i_Rst_n : in  std_logic;
		i_Clk   : in  std_logic;
		i_En    : in  std_logic;
		i_RD    : in  std_logic;
		i_SDI   : in  std_logic;
		o_Valid : out std_logic;
		o_CRC   : out std_logic_vector (7 downto 0)
	);
end CRC_8;

architecture RTL of CRC_8 is
	constant G     : std_logic_vector (o_CRC'left downto 0) := x"07";
	signal r_CRC   : std_logic_vector (o_CRC'left downto 0);
	signal w_CRC   : std_logic_vector (o_CRC'left downto 0);
	signal r_Count : integer range 0 to o_CRC'left + 1;
	signal r_Valid : std_logic;
begin

	process (i_Rst_n, i_Clk)
	begin
		if i_Rst_n = '0' then
			r_CRC   <= (others => '0');
			o_CRC   <= (others => '0');
			o_Valid <= '0';
			r_Count <= 0;
		elsif rising_edge(i_Clk) and i_En = '1' then
			if i_RD = '0' and r_Count /= o_CRC'left + 1 then
				r_Count <= r_Count + 1;
			end if;

			if r_Count = o_CRC'left + 1 then
				o_CRC   <= r_CRC;
				o_Valid <= '1';
			end if;

			r_CRC <= w_CRC;

		end if;
	end process;

	w_CRC <= r_CRC(o_CRC'left - 1 downto 0) & i_SDI when r_CRC(o_CRC'left) = '0' else
		(r_CRC(o_CRC'left - 1 downto 0) & i_SDI) xor G;

end RTL;
