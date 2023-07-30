library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package CRC_Package is

	function reverse(data : in std_logic_vector) return std_logic_vector;

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

end CRC_Package;
