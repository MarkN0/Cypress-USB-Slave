library ieee;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity an_fifo_512x16_tb is
end an_fifo_512x16_tb;

architecture TB_ARCHITECTURE of an_fifo_512x16_tb is
	-- Component declaration of the tested unit
	component an_fifo_512x16
	port(
		DATA : in STD_LOGIC_VECTOR(15 downto 0);
		Q : out STD_LOGIC_VECTOR(15 downto 0);
		WE : in STD_LOGIC;
		RE : in STD_LOGIC;
		WCLOCK : in STD_LOGIC;
		RCLOCK : in STD_LOGIC;
		FULL : out STD_LOGIC;
		EMPTY : out STD_LOGIC;
		RESET : in STD_LOGIC );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal DATA : STD_LOGIC_VECTOR(15 downto 0);
	signal WE : STD_LOGIC;
	signal RE : STD_LOGIC;
	signal WCLOCK : STD_LOGIC;
	signal RCLOCK : STD_LOGIC;
	signal RESET : STD_LOGIC;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal Q : STD_LOGIC_VECTOR(15 downto 0);
	signal FULL : STD_LOGIC;
	signal EMPTY : STD_LOGIC;

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : an_fifo_512x16
		port map (
			DATA => DATA,
			Q => Q,
			WE => WE,
			RE => RE,
			WCLOCK => WCLOCK,
			RCLOCK => RCLOCK,
			FULL => FULL,
			EMPTY => EMPTY,
			RESET => RESET
		);

	-- Add your stimulus here ...

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_an_fifo_512x16 of an_fifo_512x16_tb is
	for TB_ARCHITECTURE
		for UUT : an_fifo_512x16
			use entity work.an_fifo_512x16(def_arch);
		end for;
	end for;
end TESTBENCH_FOR_an_fifo_512x16;

