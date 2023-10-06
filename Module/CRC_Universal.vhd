library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.STD_PACKAGE.all;
use work.CRC_UNIVERSAL_PACKAGE.all;

entity CRC_Universal is
	generic (
        g_CRC_WIDTH : integer := 4;
		g_POLY   : std_logic_vector := x"04C11DB7";
        g_INIT   : std_logic_vector := x"FFFFFFFF";
        g_XOROUT : std_logic_vector := x"FFFFFFFF";
		g_REFIN  : std_logic := '1';
		g_REFOUT : std_logic := '1'
    );
    Port (
		   i_EN     : in  std_logic;
           i_CLK    : in  std_logic;
		   
		   i_STR    : in  std_logic;
           i_DATA   : in  t_BYTE;
           i_LENGTH : in  integer;
		   
           o_CRC    : out t_BYTE_VECTOR(0 to g_CRC_WIDTH - 1);
		   o_RDY    : out std_logic
		 );
end CRC_Universal;

architecture RTL of CRC_Universal is

	-- MSB is 0
    signal r_CRC    : std_logic_vector(8 * g_CRC_WIDTH - 1 downto 0);
    signal r_LENGTH : integer;
	
	signal r_CRC_ST : t_CRC_ST := INIT;

begin
    process (i_EN, i_CLK)
    begin
        if i_EN = '0' then
			
            r_CRC <= g_INIT;
            r_LENGTH <= 0;
			o_RDY <= '0';
            r_CRC_ST <= INIT;
			
        elsif rising_edge(i_CLK) then
			
			case r_CRC_ST is
			
				when INIT =>
				
					if i_STR = '1' then
						r_LENGTH <= i_LENGTH;
						r_CRC_ST <= CALCULATE;
						o_RDY <= '0';
					end if;
				
				when CALCULATE =>
				
					if r_LENGTH = 0 then
						o_CRC <= to_byte_vector(r_CRC xor g_XOROUT);
						o_RDY <= '1';
						r_CRC_ST <= INIT;
					else
						
						r_CRC  <= (r_CRC(8 * g_CRC_WIDTH - 9 downto 0) & x"00"); 
--								  xor generator(r_CRC(8 * g_CRC_WIDTH - 1 downto 8 * g_CRC_WIDTH - 8) xor i_DATA, g_POLY);
						r_LENGTH <= r_LENGTH - 1;
					end if;
			
			end case;
        end if;
    end process;

    
	
end architecture RTL;

