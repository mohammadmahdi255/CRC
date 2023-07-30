library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CRC_TB is
end CRC_TB;

architecture behavior of CRC_TB is

	-- Component Declaration for the Unit Under Test (UUT)

	component CRC
		port
		(
			i_Rst_n  : in  std_logic;
			i_Clk    : in  std_logic;
			i_En     : in  std_logic;
			i_RD     : in  std_logic;
			i_Poly   : in  std_logic_vector(7 downto 0);
			i_Init   : in  std_logic_vector(7 downto 0);
			i_XorOut : in  std_logic_vector(7 downto 0);
			i_RefIn  : in  std_logic;
			i_RefOut : in  std_logic;
			i_Byte   : in  std_logic_vector(7 downto 0);
			o_Valid  : out std_logic;
			o_CRC    : out std_logic_vector(7 downto 0)
		);
	end component;

	--Inputs
	signal i_Rst_n        : std_logic                    := '0';
	signal i_Clk          : std_logic                    := '0';
	signal i_En           : std_logic                    := '0';
	signal i_RD           : std_logic                    := '0';
	signal i_Poly         : std_logic_vector(7 downto 0) := (others => '0');
	signal i_Init         : std_logic_vector(7 downto 0) := (others => '0');
	signal i_XorOut       : std_logic_vector(7 downto 0) := (others => '0');
	signal i_RefIn        : std_logic                    := '0';
	signal i_RefOut       : std_logic                    := '0';
	signal i_Byte         : std_logic_vector(7 downto 0) := (others => '0');

	--Outputs
	signal o_Valid        : std_logic;
	signal o_CRC          : std_logic_vector(7 downto 0);

	-- Clock period definitions
	constant i_Clk_period : time := 10 ns;

begin

	-- Instantiate the Unit Under Test (UUT)
	uut : CRC port map
	(
		i_Rst_n  => i_Rst_n,
		i_Clk    => i_Clk,
		i_En     => i_En,
		i_RD     => i_RD,
		i_Poly   => i_Poly,
		i_Init   => i_Init,
		i_XorOut => i_XorOut,
		i_RefIn  => i_RefIn,
		i_RefOut => i_RefOut,
		i_Byte   => i_Byte,
		o_Valid  => o_Valid,
		o_CRC    => o_CRC
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
	begin
		-- hold reset state for 100 ns.
		i_Rst_n <= '0';
		i_En <= '0';
		i_RD <= '0';
		i_Poly <= x"07";
		i_Init <= x"00";
		i_XorOut <= x"00";
		i_RefIn <= '0';
		i_RefOut <= '0';
		i_Byte <= x"FF";
		wait for i_Clk_period * 10;
		
		i_Rst_n <= '1';
		i_En <= '1';
		i_RD <= '1';
		wait for i_Clk_period;
		i_En <= '1';
		i_RD <= '0';
		wait for i_Clk_period;
		i_En <= '0';
		i_RD <= '0';
		-- insert stimulus here 

		wait;
	end process;

end;
