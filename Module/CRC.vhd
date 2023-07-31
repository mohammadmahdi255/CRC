library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.CRC_Package.all;

entity CRC is
	generic 
	(
		Data_W : integer := 8;
		CRC_W : integer := 16
	);
	port
	(
		i_Rst_n  : in  std_logic;
		i_Clk    : in  std_logic;
		i_En     : in  std_logic;

		i_Poly   : in  std_logic_vector (CRC_W - 1 downto 0);
		i_Init   : in  std_logic_vector (CRC_W - 1 downto 0);
		i_XorOut : in  std_logic_vector (CRC_W - 1 downto 0);
		i_RefIn  : in  std_logic;
		i_RefOut : in  std_logic;

		i_Byte   : in  std_logic_vector (Data_W - 1 downto 0);
		o_CRC    : out std_logic_vector (CRC_W - 1 downto 0)
	);
end CRC;

architecture RTL of CRC is

	type crc_array is array(natural range <>) of std_logic_vector(CRC_W - 1 downto 0);

	signal r_CRC   : std_logic_vector (CRC_W - 1 downto 0);
	signal w_CRC   : crc_array (Data_W - 1 downto 0);
	signal w_Byte  : std_logic_vector (Data_W - 1 downto 0);
begin

	process (i_Rst_n, i_Clk, i_Init)
	begin
	
		if i_Rst_n = '0' then
			r_CRC   <= i_Init;
			
		elsif rising_edge(i_Clk) and i_En = '1' then
			r_CRC <= w_CRC(Data_W - 1);

		end if;
		
	end process;
	
	process (r_CRC, w_CRC, w_Byte, i_Poly)
	begin
	
		if r_CRC(CRC_W - 1) = '0' then
			w_CRC(0) <= r_CRC(CRC_W - 2 downto 0) & w_Byte(0);
		else
			w_CRC(0) <= (r_CRC(CRC_W - 2 downto 0) & w_Byte(0)) xor i_Poly;
		end if;
		
		for i in 1 to Data_W - 1 loop -- loop over rows
			if w_CRC(i-1)(CRC_W - 1) = '0' then
				w_CRC(i) <= w_CRC(i-1)(CRC_W - 2 downto 0) & w_Byte(i);
			else
				w_CRC(i) <= (w_CRC(i-1)(CRC_W - 2 downto 0) & w_Byte(i)) xor i_Poly;
			end if;
		end loop;
		
	end process;
	
	w_Byte <= i_Byte when i_RefIn = '1' else
				reverse(i_Byte);
	o_CRC <= r_CRC xor i_XorOut when i_RefOut = '0' else
			reverse(r_CRC xor i_XorOut);

end RTL;
