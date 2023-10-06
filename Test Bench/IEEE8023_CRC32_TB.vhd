library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.STD_PACKAGE.all;
use work.CRC_PACKAGE.all;

entity IEEE8023_CRC32_TB is
end IEEE8023_CRC32_TB;

architecture behavior of IEEE8023_CRC32_TB is

	-- Component Declaration for the Unit Under Test (UUT)

	component IEEE8023_CRC32
		port
		(
			i_RST_N : in  std_logic;
			i_CLK   : in  std_logic;
			i_EN    : in  std_logic;

			i_DATA  : in  t_BYTE;
			o_CRC   : out t_BYTE_VECTOR (3 downto 0)
		);
	end component;

	--Inputs
	signal i_RST_N        : std_logic := '0';
	signal i_CLK          : std_logic := '0';
	signal i_EN           : std_logic := '0';
	signal i_DATA         : t_BYTE    := (others => '0');

	--Outputs
	signal o_CRC          : t_BYTE_VECTOR(3 downto 0);

	-- Clock period definitions
	constant i_CLK_period : time := 10 ns;

begin

	-- Instantiate the Unit Under Test (UUT)
	uut : IEEE8023_CRC32 port map
	(
		i_RST_N => i_RST_N,
		i_CLK   => i_CLK,
		i_EN    => i_EN,
		i_DATA  => i_DATA,
		o_CRC   => o_CRC
	);

	-- Clock process definitions
	i_CLK_process : process
	begin
		i_CLK <= '0';
		wait for i_CLK_period/2;
		i_CLK <= '1';
		wait for i_CLK_period/2;
	end process;

	-- Stimulus process
	stim_proc : process
	begin
		-- hold reset state for 100 ns.
		-- hold reset state for 100 ns.
		
		i_RST_N  <= '0';
		i_EN     <= '0';
		i_DATA   <= x"00";
		wait for 200 ns;
		wait for i_Clk_period * 9.5;
		
		i_RST_N <= '1';
		i_EN    <= '1';
		
		i_DATA  <= x"f8";
		wait for i_Clk_period;
		i_DATA  <= x"ff";
		wait for i_Clk_period;
		i_DATA  <= x"04";
		wait for i_Clk_period;
		i_DATA  <= x"08";
		wait for i_Clk_period;
		
		i_DATA  <= x"01";
		wait for i_Clk_period;
		i_DATA  <= x"f8";
		wait for i_Clk_period;
		i_DATA  <= x"ff";
		wait for i_Clk_period;
		
		i_DATA  <= x"C7";
		wait for i_Clk_period;
		i_DATA  <= x"A3";
		wait for i_Clk_period;
		i_DATA  <= x"E7";
		wait for i_Clk_period;
		i_DATA  <= x"A7";
		wait for i_Clk_period;
		

--		i_DATA  <= x"00";
--		wait for i_Clk_period * 4;
		
		i_EN    <= '0';

		-- insert stimulus here 

		wait;
	end process;

end;
