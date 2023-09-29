library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package CRC_Package is

	function reverse(data         : in std_logic_vector) return std_logic_vector;
	function crc_calculation(data : std_logic; crc, poly : std_logic_vector) return std_logic_vector;

end CRC_Package;

package body CRC_Package is

	function reverse(data : in std_logic_vector) return std_logic_vector is
		variable result       : std_logic_vector(data'range);
	begin
		for i in data'range loop
			result(i) := data(data'left + data'right - i);
		end loop;
		return result;
	end;

	function crc_calculation(data : std_logic; crc, poly : std_logic_vector) return std_logic_vector is
		variable temp_en          : std_logic_vector (crc'range);
	begin
		temp_en := (others => crc(crc'left)); 
		return (crc(crc'left - 1 downto 0) & data) xor (temp_en and poly);
	end function;

end CRC_Package;
