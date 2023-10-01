library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.memory_package.all;

package CRC_Package is

	function reverse_each_byte(data    : in std_logic_vector) return std_logic_vector;
	function reverse_byte_order(data   : in std_logic_vector) return std_logic_vector;
	function reverse_byte(data         : in std_logic_vector) return std_logic_vector;
	function reverse(data     : in std_logic_vector) return std_logic_vector;
	function crc_calculation(data : std_logic; crc, poly : std_logic_vector) return std_logic_vector;

end CRC_Package;

package body CRC_Package is

	function reverse_each_byte(data : in std_logic_vector) return std_logic_vector is
		variable result   : t_BYTE_VECTOR(0 to data'length/8-1);
	begin
		
		result := to_byte_vector(data);
		for i in result'range loop
			result(i) := reverse(result(i));
		end loop;
		return to_std_logic_vector(result);
		
	end;
	
	function reverse_byte(data : in std_logic_vector) return std_logic_vector is
	begin
		return reverse_byte_order(reverse_each_byte(data));
	end;
	
	function reverse_byte_order(data : in std_logic_vector) return std_logic_vector is
		variable copy     : t_BYTE_VECTOR(0 to data'length/8-1);
		variable result   : t_BYTE_VECTOR(0 to data'length/8-1);
	begin
		
		copy := to_byte_vector(data);
		for i in result'range loop
			result(i) := copy(result'right - i);
		end loop;
		return to_std_logic_vector(result);
		
	end;
	
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
