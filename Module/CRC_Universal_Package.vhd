library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.STD_Package.all;

package CRC_Universal_Package is
	
	type t_CRC_ST is (INIT, CALCULATE);
	function generator(index : t_BYTE; poly: std_logic_vector) return std_logic_vector;

end CRC_Universal_Package;

package body CRC_Universal_Package is

	function generator(index : t_BYTE; poly: std_logic_vector) return std_logic_vector is
		variable crc : std_logic_vector(poly'length - 1 downto 0) := (others => '0');
	begin
		crc := index & x"000000";
		
		for i in 0 to 7 loop
			crc := crc(crc'left - 1 downto 0) & '0';
			if crc(crc'left) = '1' then
				crc := crc xor poly;
			end if;
		end loop;
		
		return crc;
	end function generator;
 
end CRC_Universal_Package;
