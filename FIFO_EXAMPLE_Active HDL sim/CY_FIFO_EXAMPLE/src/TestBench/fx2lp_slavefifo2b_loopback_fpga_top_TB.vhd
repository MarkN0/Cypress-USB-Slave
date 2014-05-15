library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; 
use ieee.numeric_std.all;

-- Add your library and packages declaration here ...

entity fx2lp_slavefifo2b_loopback_fpga_top_tb is
end fx2lp_slavefifo2b_loopback_fpga_top_tb;

architecture TB_ARCHITECTURE of fx2lp_slavefifo2b_loopback_fpga_top_tb is
	-- Component declaration of the tested unit
	component fx2lp_slavefifo2b_loopback_fpga_top
		port(
			fdata : inout STD_LOGIC_VECTOR(15 downto 0);
			faddr : out STD_LOGIC_VECTOR(1 downto 0);
			slrd : out STD_LOGIC;
			slwr : out STD_LOGIC;
			flagd : in STD_LOGIC;
			flaga : in STD_LOGIC;
			clk : in STD_LOGIC;
			sloe : out STD_LOGIC;
			done : out STD_LOGIC;
			clk_out : out STD_LOGIC;
			pkt_end : out STD_LOGIC;
			dbug_sig : out STD_LOGIC );
	end component;
	
	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal flagd : STD_LOGIC;
	signal flaga : STD_LOGIC;
	signal clk : STD_LOGIC;
	signal fdata : STD_LOGIC_VECTOR(15 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal faddr : STD_LOGIC_VECTOR(1 downto 0);
	signal slrd : STD_LOGIC;
	signal slwr : STD_LOGIC;
	signal sloe : STD_LOGIC;
	signal done : STD_LOGIC;
	signal clk_out : STD_LOGIC;
	signal pkt_end : STD_LOGIC;
	signal dbug_sig : STD_LOGIC;
	
	-- Add your code here ...	
	signal fdata_in : STD_LOGIC_VECTOR(15 downto 0);  
	signal fdata_out : STD_LOGIC_VECTOR(15 downto 0);  
	
	signal temp : std_logic_vector(1 downto 0);
	
begin
	
	-- Unit Under Test port map
	UUT : fx2lp_slavefifo2b_loopback_fpga_top
	port map (
		fdata => fdata,
		faddr => faddr,
		slrd => slrd,
		slwr => slwr,
		flagd => flagd,
		flaga => flaga,
		clk => clk,
		sloe => sloe,
		done => done,
		clk_out => clk_out,
		pkt_end => pkt_end,
		dbug_sig => dbug_sig
		);
	
	-- Add your stimulus here ... 	
	
	-- 40MHz Osc. Clk into FPGA
	process begin
		clk <= '1';
		wait for 25 ns;
		clk <= '0';
		wait for 25 ns;
	end process;	
	
	--fdata <= (others => '0');
	--fdata <= std_logic_vector(TO_SIGNED(1, 16));
	--flagd <= '0';	  
	
	-- invoke flaga not empty flag
	process begin
		flaga <= '0';
		wait for 4500 ns;
		flaga <= '1';
		--fdata <= std_logic_vector(TO_SIGNED(2, 16));
		wait for 9000 ns; 	
		flaga <= '0'; 
		wait;
	end process;	
	
	-- invoke flagd not empty flag
	process begin
		flagd <= '0';
		wait for 18000 ns;
		flagd <= '1';
		wait for 22500 ns; 
		flagd <= '0'; 
		wait;
	end process;	
	
	temp <= flaga & flagd;
	with temp select
	fdata <= x"0002" when "10",
	         (others => 'Z') when others;
	
	
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_fx2lp_slavefifo2b_loopback_fpga_top of fx2lp_slavefifo2b_loopback_fpga_top_tb is
	for TB_ARCHITECTURE
		for UUT : fx2lp_slavefifo2b_loopback_fpga_top
			use entity work.fx2lp_slavefifo2b_loopback_fpga_top(fx2lp_slavefifo2b_loopback_fpga_top_arch);
		end for;
	end for;
end TESTBENCH_FOR_fx2lp_slavefifo2b_loopback_fpga_top;

