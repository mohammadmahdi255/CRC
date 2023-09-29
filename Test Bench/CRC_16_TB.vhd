library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CRC_16_TB is
end CRC_16_TB;

architecture behavior of CRC_16_TB is

	-- Component Declaration for the Unit Under Test (UUT)

	component CRC_16
		port
		(
			i_Rst_n : in  std_logic;
			i_Clk   : in  std_logic;
			i_En    : in  std_logic;
			i_RD    : in  std_logic;
			i_SDI   : in  std_logic;
			o_Valid : out std_logic;
			o_CRC   : out std_logic_vector(15 downto 0)
		);
	end component;

	--Inputs
	signal i_Rst_n        : std_logic := '0';
	signal i_Clk          : std_logic := '0';
	signal i_En           : std_logic := '0';
	signal i_RD           : std_logic := '0';
	signal i_SDI          : std_logic := '0';

	--Outputs
	signal o_Valid        : std_logic;
	signal o_CRC          : std_logic_vector(15 downto 0);

	-- Clock period definitions
	constant i_Clk_period : time := 10 ns;

begin

	-- Instantiate the Unit Under Test (UUT)
	uut : CRC_16 port map
	(
		i_Rst_n => i_Rst_n,
		i_Clk   => i_Clk,
		i_En    => i_En,
		i_RD    => i_RD,
		i_SDI   => i_SDI,
		o_Valid => o_Valid,
		o_CRC   => o_CRC
	);

	-- Clock process definitions
	i_Clk_process : process
	begin
		i_Clk <= '0';
		wait for i_Clk_period/2;
		i_Clk <= '1';
		wait for i_Clk_period/2;
	end process;

	-- Stimulus process
	stim_proc : process
		variable Data : std_logic_vector(7 downto 0) := x"F3";
	begin
		-- hold reset state for 100 ns.
		i_Rst_n <= '1';
		i_En    <= '0';
		i_RD    <= '0';
		wait for i_Clk_period;
		i_En <= '1';
		i_RD <= '1';
		for i in 7 downto 0 loop
			i_SDI <= Data(7 - i);
			wait for i_Clk_period;
		end loop;
		i_SDI <= '0';
		i_RD  <= '0';

		wait for i_Clk_period * 24;

		i_En <= '0';
		i_RD <= '0';
		-- insert stimulus here 

		wait;
	end process;

end;
