library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use ieee.std_logic_unsigned.all;

package STD_Package is

	subtype t_BYTE is std_logic_vector(7 downto 0);
	type t_BYTE_VECTOR is array(natural range <>) of t_BYTE;
	
	function to_int(b         : std_logic_vector) return integer;
	
	function to_byte_vector(data : std_logic_vector) return t_BYTE_VECTOR;
	function to_std_logic_vector(input_vector : t_BYTE_VECTOR) return std_logic_vector;
	
end STD_Package;

package body STD_Package is

	function to_int(b : std_logic_vector) return integer is
	begin
		return to_integer(unsigned(b));
	end function;
	
	-- to_byte_vector
	function to_byte_vector(data : std_logic_vector) return t_BYTE_VECTOR is
	  variable bit_vec : std_logic_vector(data'length - 1 downto 0) := data;
	  variable result : t_BYTE_VECTOR(0 to (data'length + 7) / 8 - 1);
	begin
	  for i in result'range loop
		result(i) := bit_vec(bit_vec'left - i*8 downto bit_vec'left - i*8 - 7);
	  end loop;
	  return result;
	end function;
	
	function to_std_logic_vector(input_vector : t_BYTE_VECTOR) return std_logic_vector is
	  variable result_vector : std_logic_vector(input_vector'length * 8 - 1 downto 0);
	begin
	  -- Concatenate the elements of the input_vector
	  for i in input_vector'range loop
		result_vector(result_vector'left - 8 * i downto result_vector'left - 8 * i - 7) := input_vector(i);
	  end loop;
	  
	  return result_vector;
	end function;

 
end STD_Package;

