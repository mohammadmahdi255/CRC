library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CRC_TB is
end CRC_TB;

architecture behavior of CRC_TB is

	-- Component Declaration for the Unit Under Test (UUT)

	component CRC
		generic
		(
			g_DATA_WIDTH : integer := 1;
			g_CRC_WIDTH  : integer := 4;
			g_POLY       : std_logic_vector := x"04C11DB7";
			g_INIT       : std_logic_vector := x"FFFFFFFF";
			g_XOROUT     : std_logic_vector := x"FFFFFFFF";
			g_REFIN      : std_logic := '0';
			g_REFOUT     : std_logic := '0'
		);
		port
		(
			i_RST_N  : in  STD_LOGIC;
			i_CLK    : in  STD_LOGIC;
			i_EN     : in  STD_LOGIC;

			i_DATA   : in  STD_LOGIC_VECTOR (8 * g_DATA_WIDTH - 1 downto 0);
			o_CRC    : out STD_LOGIC_VECTOR (8 * g_CRC_WIDTH - 1 downto 0)
		);
	end component;

	--Inputs
	signal i_RST_N        : STD_LOGIC                     := '0';
	signal i_CLK          : STD_LOGIC                     := '0';
	signal i_EN           : STD_LOGIC                     := '0';
	signal i_DATA         : STD_LOGIC_VECTOR(7 downto 0)  := (others => '0');

	--Outputs
	signal o_CRC          : STD_LOGIC_VECTOR(31 downto 0);

	-- Clock period definitions
	constant i_CLK_period : TIME := 30 ns;

begin

	-- Instantiate the Unit Under Test (UUT)
	uut : CRC port map
	(
		i_RST_N  => i_RST_N,
		i_CLK    => i_CLK,
		i_EN     => i_EN,
		i_DATA   => i_DATA,
		o_CRC    => o_CRC
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
		i_RST_N  <= '0';
		i_EN     <= '0';
		i_DATA   <= x"FF";
		wait for i_Clk_period * 9.5;
		
		i_RST_N <= '1';
		i_EN    <= '1';
		
		
		i_DATA  <= x"f8" xor x"ff";
		wait for i_Clk_period;
--		
--		i_DATA  <= x"50";
--		wait for i_Clk_period;
--		
--		i_DATA  <= x"4f";
--		wait for i_Clk_period;
--		
--		i_DATA  <= x"ef";
--		wait for i_Clk_period;
--		
--		i_DATA  <= x"4e";
--		wait for i_Clk_period;
		
		i_DATA  <= x"FF";
		wait for i_Clk_period * 3;
		
		i_DATA  <= x"00";
		wait for i_Clk_period;
		
		i_EN <= '0';
		-- insert stimulus here 

		wait;
	end process;

end;
