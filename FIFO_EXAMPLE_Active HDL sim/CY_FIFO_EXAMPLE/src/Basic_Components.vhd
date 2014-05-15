--Basic Functions Library
--NASA Goddard Space Flight Center
--Developed by Code 564

--DO NOT DISTRIBUTE

--Please refer to the entity description of each component for a description of the intended functionality.

library IEEE;
	use IEEE.Std_Logic_1164.all;
	use IEEE.std_logic_unsigned.all;
	use IEEE.numeric_std.all;
	
package Basic_Components is

	function ciellog2(x: integer) return integer;    --computes the log of integer x rounded up to the nearest integer.  Useful for sizing address fields in re-sizable design units.
	
	Component DFlipFlop
	generic(
		 BitSize: integer := 1;  --Specifies the bitsize of the input and output.  Default is 1.  Must be >0.
		 EdgeTrig: integer := 1;  --Specifies on which clock edge to trigger.  Use 1 (default) for rising and 0 for falling edge.  Must be 0 or 1.
		 Depth: integer := 1; --Specifies how many times to register.  To create a double register, use 2.  Use 3 for triple and so on.  Must be > 0.
		 DefaultVal: integer := 0  --Specifies what value the registers go to during reset. Interpreted as an unsigned integer and converted to binary.
		 );
	port(
		 Clk: in Std_logic;
		 n_Rst: in Std_logic;
		 En: in Std_logic;
		 DIn: in Std_logic_vector(BitSize-1 downto 0);
		 DOut: out Std_logic_vector(BitSize-1 downto 0)
		 );
	end component;
		
	Component DFlipFlopSynRst
	generic(
		 BitSize: integer := 1;  --Specifies the bitsize of the input and output.  Default is 1.  Must be >0.
		 EdgeTrig: integer := 1;  --Specifies on which clock edge to trigger.  Use 1 (default) for rising and 0 for falling edge.  Must be 0 or 1.
		 Depth: integer := 1; --Specifies how many times to register.  To create a double register, use 2.  Use 3 for triple and so on.  Must be > 0.
		 DefaultVal: integer := 0  --Specifies what value the registers go to during reset. Interpreted as an unsigned integer and converted to binary.
		 );
	port(
		 Clk: in Std_logic;
		 n_Rst: in Std_logic;
		 y_Rst: in Std_Logic;
		 En: in Std_logic;
		 DIn: in Std_logic_vector(BitSize-1 downto 0);
		 DOut: out Std_logic_vector(BitSize-1 downto 0)
		 );
	end component;

	Component DFlipFlopVarDepth
	generic(
		 BitSize: integer := 1;  --Specifies the bitsize of the input and output.  Default is 1.  Must be >0.
		 EdgeTrig: integer := 1;  --Specifies on which clock edge to trigger.  Use 1 (default) for rising and 0 for falling edge.  Must be 0 or 1.
		 MaxDepth: integer := 1; --Specifies the maximum amount of latency that can be used.  Must be greater than 0.
		 DefaultVal: integer := 0  --Specifies what value the registers go to during reset. Interpreted as an unsigned integer and converted to binary.
		 );		
	port(
		 Clk: in Std_logic;
		 n_Rst: in Std_logic;
		 En: in Std_logic;
		 Depth: in std_logic_vector(ciellog2(MaxDepth)-1 downto 0);
		 DIn: in Std_logic_vector(BitSize-1 downto 0);
		 DOut: out Std_logic_vector(BitSize-1 downto 0)
		 );
	end component;

	Component JKFlipFlop
	generic(
		 BitSize: integer := 1;  --Specifies the bitsize of the input and output.  Default is 1.  Must be >0.
		 EdgeTrig: integer := 1;  --Specifies on which clock edge to trigger.  Use 1 (default) for rising and 0 for falling edge.  Must be 0 or 1.
		 DefaultVal: integer := 0  --Specifies what value the registers go to during reset.  Default is logic zero, use 1 for logic 1.  Must be 0 or 1.
		 );
	port(
		 Clk: in Std_logic;
		 n_Rst: in Std_logic;
		 Set, Unset: in Std_logic_vector(BitSize-1 downto 0);
		 DOut: out Std_logic_vector(BitSize-1 downto 0)
		 );
	end component;

	Component ShiftOut
	generic(
		 BitSize: integer := 1;  --Specifies the bitsize of the output count.  Default is 1.  Must be > 1.
		 EdgeTrig: integer := 1;  --Specifies on which edge to trigger.  Use 1 (default) for rising and 0 for falling edge.  Must be 0 or 1.
		 LSBFirst: integer := 1 --Specifies whether the LSB or MSB is shifted out first.  Use 1 (default) for LSB first and 0 for MSB first.  Must be 0 or 1.
		 );
	port(
		 Clk: in Std_logic;
		 n_Rst: in Std_logic;
		 En: in Std_logic;
		 Ld: in Std_logic;
		 Fill: in Std_logic;      --This bit fills in the empty bit after each shift.
		 DIn: in Std_logic_vector(BitSize-1 downto 0);
		 DOut: out Std_logic
		 );
	end component;

	Component ShiftIn
	generic(
		 BitSize: integer := 1;  --Specifies the bitsize of the output count.  Default is 1.  Must be > 1.
		 EdgeTrig: integer := 1;  --Specifies on which edge to trigger.  Use 1 (default) for rising and 0 for falling edge.  Must be 0 or 1.
		 DefaultVal: integer := 0;  --Specifies what value the registers go to during reset. Interpreted as an unsigned integer and converted to binary.
		 MSBFirst: integer := 1 --Specifies whether fill data is shifted into the MSB or LSB (remaining bits are shifted to the other end).  Use 1 (default) to shift into the MSB and 0 to shift into the LSB.  Must be 0 or 1.
		 );                        --Note:  If incoming data is formated as LSB first, then it should shift towards LSB.
	port(
		 Clk: in Std_logic;
		 n_Rst: in Std_logic;
		 En: in Std_logic;
		 Fill: in Std_logic;      --This bit fills in the empty bit after each shift.
		 DOut: out Std_logic_vector(BitSize-1 downto 0)
		 );
	end component;

	Component EdgePulse
	generic(
		EdgeType: integer := 1   --Defaults to 1 (rising edge).  Use 0 for falling edge or 2 for any edge.
		);	
	port(
		Clk, DIn: in Std_logic;
		DOut: out Std_logic
		);
	end component;

	Component Counter
	generic(
		 BitSize: integer := 1;  --Specifies the bitsize of the output count.  Default is 1.  Must be >0.
		 EdgeTrig: integer := 1;  --Specifies on which edge to trigger.  Use 1 (default) for rising and 0 for falling edge.  Must be 0 or 1.
		 StepSize: integer := 1 --Specifies how to increment the count on each trigger.  Use positive or negative number for up and down counting.
		 );						--		 Be careful if you set the stepsize larger than the range specified by the bitsize.
		
	port(
		 Clk: in Std_logic;
		 n_Rst: in Std_logic;
		 En: in Std_logic;
		 DOut: out Std_logic_vector(BitSize-1 downto 0)
		 );
	end component;

	Component SynRstCounter
	generic(
		BitSize: integer := 1;  --Specifies the bitsize of the output count.  Default is 1.  Must be >0.
		EdgeTrig: integer := 1;  --Specifies on which edge to trigger.  Use 1 (default) for rising and 0 for falling edge.  Must be 0 or 1.
		StepSize: integer := 1 --Specifies how to increment the count on each trigger.  Use positive or negative number for up and down counting.
		);						--		 Be careful if you set the stepsize larger than the range specified by the bitsize.
	port(
		Clk: in Std_logic;
		n_Rst: in Std_logic;
		y_Rst: in Std_logic;
		En: in Std_logic;
		DOut: out Std_logic_vector(BitSize-1 downto 0)
		);
	end component;
	
	Component RolloverCounter
	generic(
		BitSize: integer := 1;  --Specifies the bitsize of the output count.  Default is 1.  Must be >0.
		EdgeTrig: integer := 1;  --Specifies on which edge to trigger.  Use 1 (default) for rising and 0 for falling edge.  Must be 0 or 1.
		StepSize: integer := 1; --Specifies how to increment the count on each trigger.  Use positive or negative number for up and down counting.
		DefaultVal: integer := 0;  --Specifies the starting value on reset.  Interpreted as unsigned integer.
		MaxVal: integer := 0  --Specifies the threshold over which the counter will roll back to zero (on the next count)
		);                                      --Be careful when using large values for stepsize.
	port(
		Clk: in Std_logic;
		n_Rst: in Std_logic;
		En: in Std_logic;
		DOut: out Std_logic_vector(BitSize-1 downto 0)
		);
	end component;

	Component ParLdCounter
	generic(
		 BitSize: integer := 1;  --Specifies the bitsize of the output count.  Default is 1.  Must be >0.
		 EdgeTrig: integer := 1;  --Specifies on which edge to trigger.  Use 1 (default) for rising and 0 for falling edge.  Must be 0 or 1.
		 StepSize: integer := 1 --Specifies how to increment the count on each trigger.  Use positive or negative number for up or down counting.
		 );						--		 Be careful if you set the stepsize larger than the range specified by the bitsize.
	port(
		 Clk: in Std_logic;
		 n_Rst: in Std_logic;
		 En, Ld: in Std_logic;
		 DIn: in Std_logic_vector(BitSize-1 downto 0);
		 DOut: out Std_logic_vector(BitSize-1 downto 0)
		 );
	end component;

	Component UpDnCounter
	generic(
		 BitSize: integer := 1;  --Specifies the bitsize of the output count.  Default is 1.  Must be >0.
		 EdgeTrig: integer := 1;  --Specifies on which edge to trigger.  Use 1 (default) for rising and 0 for falling edge.  Must be 0 or 1.
		 StepSize: integer := 1 --Specifies how to increment the count on each trigger.  Use positive or negative number.  This number will be inverted when the RevDir bit is set high.
		 );						--		 Be careful if you set the stepsize larger than the range specified by the bitsize.
	port(
		 Clk: in Std_logic;
		 n_Rst: in Std_logic;
		 En: in Std_logic;
		 RevDir:  in Std_logic;  --Reverses the counting direction when set to 1.  If stepsize = 1, then setting this bit low will enable upcounting and high enables upcounting.
		 DOut: out Std_logic_vector(BitSize-1 downto 0)
		 );
	end component;

	Component Incrementer
	generic(
		 BitSize: integer := 1;  --Specifies the bitsize of the output count.  Default is 1.  Must be >0.
		 IncSize: integer := 1;  --Specifies the bitsize of the increment input.  Must be <= bitsize.
		 EdgeTrig: integer := 1  --Specifies on which edge to trigger.  Use 1 (default) for rising and 0 for falling edge.  Must be 0 or 1.
		 );						--		 Be careful if you set the stepsize larger than the range specified by the bitsize.
	port(
		 Clk: in Std_logic;
		 n_Rst: in Std_logic;
		 y_Rst: in Std_logic;
		 En: in Std_logic;
		 Inc:  in Std_logic_vector(IncSize-1 downto 0);  --controls how much to increment while the enable bit is high
		 DOut: out Std_logic_vector(BitSize-1 downto 0)
		 );
	end component;
	
	Component GrayEncoder is
	generic(
		BitSize: integer := 3
		);
	port(
		Clk: in std_logic;
		DIn: in std_logic_vector(BitSize-1 downto 0);
		DOut: out std_logic_vector(BitSize-1 downto 0)
		);
	End component;
	
	Component GrayDecoder is
	generic(
		BitSize: integer := 3
		);
	port(
		Clk: in std_logic;
		DIn: in std_logic_vector(BitSize-1 downto 0);
		DOut: out std_logic_vector(BitSize-1 downto 0)
		);
	End component;

end package Basic_Components;




library IEEE;
	use IEEE.Std_Logic_1164.all;
	use IEEE.std_logic_unsigned.all;
	use IEEE.numeric_std.all;

package body Basic_Components is

	function ciellog2(x: integer) return integer is  --computes the log of x rounded up to the nearest integer
		variable i: integer := 0;
	begin
		while 2**i < x loop
			i := i + 1;
		end loop;
		return i;
	end ciellog2;

end package body Basic_Components;
		
library IEEE;
	use IEEE.Std_Logic_1164.all;
	use IEEE.std_logic_unsigned.all;
	use IEEE.numeric_std.all;

-------------------------------------------------------------------------------------------------------------------------
----                                                                                                                 ----
----                                                  D Flip Flop                                                    ----
----                                                                                                                 ----
-------------------------------------------------------------------------------------------------------------------------
--This is a configurable edge-triggered register.  Various
--configuration settings may be set using generics.  Refer
--to the documentation notes in the generics section for
--details on default settings as well as parameters that may
--be configured.
	
library IEEE;
	use IEEE.Std_Logic_1164.all;
	use IEEE.std_logic_unsigned.all;
	use IEEE.numeric_std.all;

entity DFlipFlop is
	generic(
		 BitSize: integer := 1;  --Specifies the bitsize of the input and output.  Default is 1.  Must be >0.
		 EdgeTrig: integer := 1;  --Specifies on which clock edge to trigger.  Use 1 (default) for rising and 0 for falling edge.  Must be 0 or 1.
		 Depth: integer := 1; --Specifies how many times to register.  To create a double register, use 2.  Use 3 for triple and so on.  Must be > 0.
		 DefaultVal: integer := 0  --Specifies what value the register goes to during reset. Interpreted as an unsigned integer and converted to binary.
		 );
	port(
		 Clk: in Std_logic;
		 n_Rst: in Std_logic;
		 En: in Std_logic;
		 DIn: in Std_logic_vector(BitSize-1 downto 0);
		 DOut: out Std_logic_vector(BitSize-1 downto 0)
		 );
end DFlipFlop;

architecture behavior of DFlipFlop is
	type RegisterBank is array(Depth downto 0) of std_logic_vector(BitSize-1 downto 0);
	signal Intermediate: Registerbank;
	signal Clk_mod: std_logic;
begin
	
	With EdgeTrig select         --use inverted clock for falling edge triggers
	Clk_mod <=
		not Clk when 0,
		Clk when 1,
		'X' when others;
	
	DOut <= Intermediate(Depth);
	Intermediate(0) <= DIn;

	process(Clk_mod, n_Rst)
	begin
		if n_Rst = '0' then 
			Intermediate(Depth downto 1) <= (others => std_logic_vector(to_unsigned(DefaultVal,BitSize)));
		elsif Clk_mod = '1' and Clk_mod'Event then
			if En = '1' then
				Intermediate(Depth downto 1) <= Intermediate(Depth-1 downto 0);
			else
				Intermediate(Depth downto 1) <= Intermediate(Depth downto 1);
			end if;
		end if;
	end process;
end behavior;

-------------------------------------------------------------------------------------------------------------------------
----                                                                                                                 ----
----                                        D Flip Flop w/ Synchronous Reset                                         ----
----                                                                                                                 ----
-------------------------------------------------------------------------------------------------------------------------
--This is the same as the standard D-flip-flop except that it takes a synchronous reset signal in addition to 
--the asynchronous reset.


library IEEE;
	use IEEE.Std_Logic_1164.all;
	use IEEE.std_logic_unsigned.all;
	use IEEE.numeric_std.all;
	
entity DFlipFlopSynRst is
	generic(
		 BitSize: integer := 1;  --Specifies the bitsize of the input and output.  Default is 1.  Must be >0.
		 EdgeTrig: integer := 1;  --Specifies on which clock edge to trigger.  Use 1 (default) for rising and 0 for falling edge.  Must be 0 or 1.
		 Depth: integer := 1; --Specifies how many times to register.  To create a double register, use 2.  Use 3 for triple and so on.  Must be > 0.
		 DefaultVal: integer := 0  --Specifies what value the registers go to during reset. Interpreted as an unsigned integer and converted to binary.
		 );
	port(
		 Clk: in Std_logic;
		 n_Rst: in Std_logic;
		 y_Rst: in Std_Logic;
		 En: in Std_logic;
		 DIn: in Std_logic_vector(BitSize-1 downto 0);
		 DOut: out Std_logic_vector(BitSize-1 downto 0)
		 );
end DFlipFlopSynRst;

architecture behavior of DFlipFlopSynRst is
	type RegisterBank is array(Depth downto 0) of std_logic_vector(BitSize-1 downto 0);
	signal Intermediate: Registerbank;
	signal Clk_mod: std_logic;
begin
	
	With EdgeTrig select         --use inverted clock for falling edge triggers
	Clk_mod <=
		not Clk when 0,
		Clk when 1,
		'X' when others;
	
	DOut <= Intermediate(Depth);
	Intermediate(0) <= DIn;

	process(Clk_mod, n_Rst)
	begin
		if n_Rst = '0' then 
			Intermediate(Depth downto 1) <= (others => std_logic_vector(to_unsigned(DefaultVal,BitSize)));
		elsif Clk_mod = '1' and Clk_mod'Event then
			if y_Rst = '1' then
				if DefaultVal = 0 then
					Intermediate(Depth downto 1) <= (others => (others => '0'));
				else
					Intermediate(Depth downto 1) <= (others => (others => '1'));
				end if;
			elsif En = '1' then
				Intermediate(Depth downto 1) <= Intermediate(Depth-1 downto 0);
			else
				Intermediate(Depth downto 1) <= Intermediate(Depth downto 1);
			end if;
		end if;
	end process;
end behavior;

-------------------------------------------------------------------------------------------------------------------------
----                                                                                                                 ----
----                                            Variable Delay Register                                              ----
----                                                                                                                 ----
-------------------------------------------------------------------------------------------------------------------------
--This module can be considered a D-flip-flop or a shift register.  The key difference between the basic D-flip-flop
--in this file is that the depth is variable on the fly.  The

library IEEE;
	use IEEE.Std_Logic_1164.all;
	use IEEE.std_logic_unsigned.all;
	use IEEE.numeric_std.all;
	use Basic_Components.all;  --this is here for the ceillog2 function
	
entity DFlipFlopVarDepth is
	generic(
		 BitSize: integer := 1;  --Specifies the bitsize of the input and output.  Default is 1.  Must be >0.
		 EdgeTrig: integer := 1;  --Specifies on which clock edge to trigger.  Use 1 (default) for rising and 0 for falling edge.  Must be 0 or 1.
		 MaxDepth: integer := 1; --Specifies the maximum amount of latency that can be used.  Must be greater than 0.
		 DefaultVal: integer := 0  --Specifies what value the registers go to during reset. Interpreted as an unsigned integer and converted to binary.
		 );		
	port(
		 Clk: in Std_logic;
		 n_Rst: in Std_logic;
		 En: in Std_logic;
		 Depth: in std_logic_vector(ciellog2(MaxDepth)-1 downto 0);
		 DIn: in Std_logic_vector(BitSize-1 downto 0);
		 DOut: out Std_logic_vector(BitSize-1 downto 0)
		 );
end DFlipFlopVarDepth;
		
architecture behavior of DFlipFlopVarDepth is
	type RegisterBank is array(MaxDepth downto 0) of std_logic_vector(BitSize-1 downto 0);
	signal Intermediate: Registerbank;
	signal Clk_mod: std_logic;
begin
	
	With EdgeTrig select         --use inverted clock for falling edge triggers
	Clk_mod <=
		not Clk when 0,
		Clk when 1,
		'X' when others;
	
	DOut <= Intermediate(to_integer(unsigned(Depth)));
	Intermediate(0) <= DIn;

	process(Clk_mod, n_Rst)
	begin
		if n_Rst = '0' then 
			Intermediate(MaxDepth downto 1) <= (others => std_logic_vector(to_unsigned(DefaultVal,BitSize)));
		elsif Clk_mod = '1' and Clk_mod'Event then
			if En = '1' then
				Intermediate(MaxDepth downto 1) <= Intermediate(MaxDepth-1 downto 0);
			else
				Intermediate(MaxDepth downto 1) <= Intermediate(MaxDepth downto 1);
			end if;
		end if;
	end process;
end behavior;


-------------------------------------------------------------------------------------------------------------------------
----                                                                                                                 ----
----                                                 J-K Flip Flop                                                   ----
----                                                                                                                 ----
-------------------------------------------------------------------------------------------------------------------------
library IEEE;
	use IEEE.Std_Logic_1164.all;
	use IEEE.std_logic_unsigned.all;
	use IEEE.numeric_std.all;


entity JKFlipFlop is
	generic(
		 BitSize: integer := 1;  --Specifies the bitsize of the input and output.  Default is 1.  Must be >0.
		 EdgeTrig: integer := 1;  --Specifies on which clock edge to trigger.  Use 1 (default) for rising and 0 for falling edge.  Must be 0 or 1.
		 DefaultVal: integer := 0  --Specifies what value the registers go to during reset.  Default is logic zero, use 1 for logic 1.  Must be 0 or 1.
		 );
	port(
		 Clk: in Std_logic;
		 n_Rst: in Std_logic;
		 Set, Unset: in Std_logic_vector(BitSize-1 downto 0);
		 DOut: out Std_logic_vector(BitSize-1 downto 0)
		 );
end JKFlipFlop;

architecture behavior of JKFlipFlop is
	signal Clk_mod: std_logic;
	signal DOut_Buf: std_logic_vector(BitSize-1 downto 0);
begin
	
	With EdgeTrig select         --use inverted clock for falling edge triggers
	Clk_mod <=
		not Clk when 0,
		Clk when 1,
		'X' when others;
		
	DOut <= DOut_Buf;
	
	process(Clk_mod, n_Rst)
		variable JK: std_logic_vector(1 downto 0);
	begin
		if n_Rst = '0' then 
			if DefaultVal = 0 then
				DOut_Buf <= (others => '0');
			else
				DOut_Buf <= (others => '1');
			end if;
		elsif Clk_mod = '1' and Clk_mod'Event then
			for i in BitSize-1 downto 0 loop
				JK := Set(i) & Unset(i);
				case JK is
					when "00" => DOut_Buf(i) <= DOut_Buf(i);
					when "01" => DOut_Buf(i) <= '0';
					when "10" => DOut_Buf(i) <= '1';
					when "11" => DOut_Buf(i) <= not DOut_Buf(i);
					when others => DOut_Buf(i) <= 'X';                    --commenting to eliminate warnings
				end case;
			end loop;
		end if;
	end process;
end behavior;

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
----                                                                                     ----
----                   Configurable Parallel Load Shift Register                         ----
----                                                                                     ----
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
--This is a highly configurable shift register using generics to allow one to use the same
--entity for a variety of shift register functions.  It has an active low,
--asynchronous reset, an enable bit, load bit, and fill bit.  When load is asserted, it
--will override the enable bit and cause the data on DIn to be registered internally.
--Asserting the enable bit while Ld is deserted will cause the shift operation.  The fill
--bit will replace the empty register bit during this operation.  Use the LSBFirst generic
--to configure the counter for shifting out the LSB first or MSB first.

library IEEE;
	use IEEE.Std_Logic_1164.all;
	use IEEE.std_logic_unsigned.all;
	use IEEE.numeric_std.all;
	
entity ShiftOut is
	generic(
		 BitSize: integer := 1;  --Specifies the bitsize of the output count.  Default is 1.  Must be > 1.
		 EdgeTrig: integer := 1;  --Specifies on which edge to trigger.  Use 1 (default) for rising and 0 for falling edge.  Must be 0 or 1.
		 LSBFirst: integer := 1 --Specifies whether the LSB or MSB is shifted out first.  Use 1 (default) for LSB first and 0 for MSB first.  Must be 0 or 1.
		 );
	port(
		 Clk: in Std_logic;
		 n_Rst: in Std_logic;
		 En: in Std_logic;
		 Ld: in Std_logic;
		 Fill: in Std_logic;      --This bit fills in the empty bit after each shift.
		 DIn: in Std_logic_vector(BitSize-1 downto 0);
		 DOut: out Std_logic
		 );
end ShiftOut;

architecture behavior of ShiftOut is
	signal Clk_mod: Std_logic;                --modified clock according to EdgeTrig setting
	signal Data: Std_logic_vector((bitsize - 1) downto 0) := (others => '0');          --initial value set in order to clear up warnings in the simulation
begin
		
	With EdgeTrig select         --use inverted clock for falling edge triggers
	Clk_mod <=
		not Clk when 0,
		Clk when 1,
		'X' when others;
	
	With LSBFirst select
	DOut <= 
		Data(0) when 1,
		Data(BitSize - 1) when others;
	

	process(Clk_mod, n_Rst)
	begin
		if n_Rst = '0' then 
			Data <= (others => '0');
		elsif Clk_mod = '1' and Clk_mod'Event then          --using this code instead until the problem is solved
			if Ld = '1' then           --Assering the Ld bit will override assertion of the En bit.
				Data <= DIn;
			elsif En = '1' then
				if LSBFirst = 1 then
					Data((BitSize - 2) downto 0) <= Data((BitSize - 1) downto 1);   --shift towards LSB
					Data(BitSize - 1) <= Fill;
				else
					Data((BitSize - 1) downto 1) <= Data((BitSize - 2) downto 0);   --shift towards MSB
					Data(0) <= Fill;
				end if;
			else  --do nothing
			end if;
		end if;
	end process;
end behavior;


---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
----                                                                                     ----
----                          Parrallel Output Shift Register                            ----
----                                                                                     ----
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------

--This is a separate component that is used when you want parallel
--output.  It does not input in parallel.  Used for serial to parallel
--conversion.



library IEEE;
	use IEEE.Std_Logic_1164.all;
	use IEEE.std_logic_unsigned.all;
	use IEEE.numeric_std.all;
	
entity ShiftIn is
	generic(
		 BitSize: integer := 1;  --Specifies the bitsize of the output count.  Default is 1.  Must be > 1.
		 EdgeTrig: integer := 1;  --Specifies on which edge to trigger.  Use 1 (default) for rising and 0 for falling edge.  Must be 0 or 1.
		 DefaultVal: integer := 0;  --Specifies what value the registers go to during reset. Interpreted as an unsigned integer and converted to binary.
		 MSBFirst: integer := 1 --Specifies whether fill data is shifted into the MSB or LSB (remaining bits are shifted to the other end).  Use 1 (default) to shift into the MSB and 0 to shift into the LSB.  Must be 0 or 1.
		 );                        --Note:  If incoming data is formated as LSB first, then it should shift towards LSB.
	port(
		 Clk: in Std_logic;
		 n_Rst: in Std_logic;
		 En: in Std_logic;
		 Fill: in Std_logic;      --This bit fills in the empty bit after each shift.
		 DOut: out Std_logic_vector(BitSize-1 downto 0)
		 );
end ShiftIn;

architecture behavior of ShiftIn is
	signal Clk_mod: Std_logic;                --modified clock according to EdgeTrig setting
	signal Data: Std_logic_vector((bitsize - 1) downto 0) := (others => '0');          --initial value set in order to clear up warnings in the simulation
begin
		
	DOut((bitsize - 1) downto 0) <= Data((bitsize - 1) downto 0);	
	
	With EdgeTrig select         --use inverted clock for falling edge triggers
	Clk_mod <=
		not Clk when 0,
		Clk when 1,
		'X' when others;
		
	process(Clk_mod, n_Rst)
	begin
		if n_Rst = '0' then 
			Data <= std_logic_vector(to_unsigned(DefaultVal,BitSize));
		elsif Clk_mod = '1' and Clk_mod'Event then
			if En = '1' then
				if MSBFirst = 1 then
					Data((BitSize - 2) downto 0) <= Data((BitSize - 1) downto 1);   --shift towards LSB
					Data(BitSize - 1) <= Fill;
				else
					Data((BitSize - 1) downto 1) <= Data((BitSize - 2) downto 0);   --shift towards MSB
					Data(0) <= Fill;
				end if;
			else  --do nothing
			end if;
		end if;
	end process;
end behavior;

-------------------------------------------------------------------------------------------------------------------------
----                                                                                                                 ----
----                                                 Edge Detector                                                   ----
----                                                                                                                 ----
-------------------------------------------------------------------------------------------------------------------------

--This module uses a D-Flip-Flop and a logic gate
--to detect either a falling edge, a rising edge,
--or any edge on the input signal.  Its output will
--be a one clock-period wide "pulse" following the
--specified edge.

--Set EdgeType = 0 for falling edge
--Set EdgeType = 1 for rising edge
--Set EdgeType = 2 for any edge
--Default EdgeType = 0

library IEEE;
	use IEEE.Std_Logic_1164.all;
	use IEEE.std_logic_unsigned.all;
	use IEEE.numeric_std.all;
	
entity EdgePulse is
	generic(
		EdgeType: integer := 1   --Defaults to 1 (rising edge).  Use 0 for falling edge or 2 for any edge.
		);	
	port(
		Clk, Din: in Std_logic;
		DOut: out Std_logic
		);
end EdgePulse;

architecture Behavior of EdgePulse is
	Signal DIn_1: Std_logic;
begin
	
	with EdgeType select
	DOut <= 
		DIn_1 and not DIn when 0,  --falling edge
		DIn and not DIn_1 when 1,  --rising edge
		DIn xor DIn_1 when 2,      --any edge
		'X' when others;
		
	DFF: process(Clk)
	begin
		if Clk = '1' and Clk'Event then   --use a DFF to delay the signal 1 clock cycle to
			DIn_1 <= DIn;               --compareits previous value to its current value
		end if;
	end process;	

end Behavior;

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
----                                                                                     ----
----                         	  Configurable Counter                                   ----
----                                                                                     ----
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
--This is a highly configurable counter using generics to allow one to use the same
--entity for a variety of counting and clock division functions.  It has an active low
--asynchronous reset, an enable bit, and can count up or down with any integer step size
--by changing the step size.  It will be followed by a separate entity that contains a 
--parallel load option to allow for initialization of the counter.

library IEEE;
	use IEEE.Std_Logic_1164.all;
	use IEEE.std_logic_unsigned.all;
	use IEEE.numeric_std.all;
	
entity Counter is
	generic(
		 BitSize: integer := 1;  --Specifies the bitsize of the output count.  Default is 1.  Must be >0.
		 EdgeTrig: integer := 1;  --Specifies on which edge to trigger.  Use 1 (default) for rising and 0 for falling edge.  Must be 0 or 1.
		 StepSize: integer := 1 --Specifies how to increment the count on each trigger.  Use positive or negative number for up and down counting.
		 );						--		 Be careful if you set the stepsize larger than the range specified by the bitsize.		
	port(
		 Clk: in Std_logic;
		 n_Rst: in Std_logic;
		 En: in Std_logic;
		 DOut: out Std_logic_vector(BitSize-1 downto 0)
		 );
end Counter;

architecture behavior of Counter is
	signal Clk_mod: Std_logic;                --modified clock according to EdgeTrig setting
	signal DOut_Buf: Std_logic_vector(BitSize-1 downto 0);
begin
		
	DOut <= DOut_Buf;	
	
	With EdgeTrig select         --use inverted clock for falling edge triggers
	Clk_mod <=
		not Clk when 0,
		Clk when 1,
		'X' when others;

	process(Clk_mod, n_Rst)
	begin
		if n_Rst = '0' then 
			DOut_Buf(BitSize-1 downto 0) <= (others => '0');
		elsif Clk_mod = '1' and Clk_mod'Event then          --using this code instead until the problem is solved
			if En = '1' then
				DOut_Buf <= DOut_Buf + StepSize;
			else  --do nothing
				DOut_Buf <= DOut_Buf;
			end if;
		end if;
	end process;
end behavior;

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
----                                                                                     ----
----                     Configurable Counter with Synchronous Reset                     ----
----                                                                                     ----
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
--This is a highly configurable counter using generics to allow one to use the same
--entity for a variety of counting and clock division functions.  It has an active low
--asynchronous reset, an active high synchronous reset, an enable bit, and can count up 
--or down with any integer step size by changing the step size.

library IEEE;
	use IEEE.Std_Logic_1164.all;
	use IEEE.std_logic_unsigned.all;
	use IEEE.numeric_std.all;
	
entity SynRstCounter is
	generic(
		 BitSize: integer := 1;  --Specifies the bitsize of the output count.  Default is 1.  Must be >0.
		 EdgeTrig: integer := 1;  --Specifies on which edge to trigger.  Use 1 (default) for rising and 0 for falling edge.  Must be 0 or 1.
		 StepSize: integer := 1 --Specifies how to increment the count on each trigger.  Use positive or negative number for up and down counting.
		 );						--		 Be careful if you set the stepsize larger than the range specified by the bitsize.
		
	port(
		 Clk: in Std_logic;
		 n_Rst: in Std_logic;
		 y_Rst: in Std_logic;
		 En: in Std_logic;
		 DOut: out Std_logic_vector(BitSize-1 downto 0)
		 );
end SynRstCounter;

architecture behavior of SynRstCounter is
	signal Clk_mod: Std_logic;                --modified clock according to EdgeTrig setting
	signal DOut_Buf: Std_logic_vector(BitSize-1 downto 0);
begin
		
	DOut <= DOut_Buf;	
	
	With EdgeTrig select         --use inverted clock for falling edge triggers
	Clk_mod <=
		not Clk when 0,
		Clk when 1,
		'X' when others;

	process(Clk_mod, n_Rst)
	begin
		if n_Rst = '0' then 
			DOut_Buf(BitSize-1 downto 0) <= (others => '0');
		elsif Clk_mod = '1' and Clk_mod'Event then          --using this code instead until the problem is solved
			if y_Rst = '1' then
				DOut_Buf(BitSize-1 downto 0) <= (others => '0');
			elsif En = '1' then
				DOut_Buf <= DOut_Buf + StepSize;
			else  --do nothing
				DOut_Buf <= DOut_Buf;
			end if;
		end if;
	end process;
end behavior;



---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
----                                                                                     ----
----                            Configurable Rollover Counter                            ----
----                                                                                     ----
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
--This is a configurable counter using generics to allow one to use the same
--entity for a variety of counting and clock division functions.  The defining feature
--of this counter is the rollover limit, which is configured using generics and provides
--a threshold over which the counter will automatically reset to zero.  It has an active low
--asynchronous reset, and an enable bit.  It can count up or down with any integer step 
--size by changing the step size, though counting down is not recommended unless the 
--resulting behavior has been carefully considered.  

library IEEE;
	use IEEE.Std_Logic_1164.all;
	use IEEE.std_logic_unsigned.all;
	use IEEE.numeric_std.all;
	
entity RolloverCounter is
	generic(
		BitSize: integer := 1;  --Specifies the bitsize of the output count.  Default is 1.  Must be >0.
		EdgeTrig: integer := 1;  --Specifies on which edge to trigger.  Use 1 (default) for rising and 0 for falling edge.  Must be 0 or 1.
		StepSize: integer := 1; --Specifies how to increment the count on each trigger.  Use positive or negative number for up and down counting.
		DefaultVal: integer := 0;  --Specifies the starting value on reset.  Interpreted as unsigned integer.
		MaxVal: integer := 0  --Specifies the threshold over which the counter will roll back to zero (on the next count)
		);                                      --Be careful when using large values for stepsize.
	port(
		Clk: in Std_logic;
		n_Rst: in Std_logic;
		En: in Std_logic;
		DOut: out Std_logic_vector(BitSize-1 downto 0)
		);
	end RolloverCounter;

architecture behavior of RolloverCounter is
	signal Clk_mod: Std_logic;                --modified clock according to EdgeTrig setting
	signal DOut_Buf: Std_logic_vector(BitSize-1 downto 0);
begin
		
	DOut <= DOut_Buf;	
	
	With EdgeTrig select         --use inverted clock for falling edge triggers
	Clk_mod <=
		not Clk when 0,
		Clk when 1,
		'X' when others;

	process(Clk_mod, n_Rst)
	begin
		if n_Rst = '0' then 
			DOut_Buf(BitSize-1 downto 0) <= std_logic_vector(to_unsigned(DefaultVal,BitSize));
		elsif Clk_mod = '1' and Clk_mod'Event then          --using this code instead until the problem is solved
			if En = '1' and DOut_Buf >= MaxVal and MaxVal /= 0 then
				DOut_Buf <= (others => '0');
			elsif En = '1' then
				DOut_Buf <= DOut_Buf + StepSize;
			else  --do nothing
				DOut_Buf <= DOut_Buf;
			end if;
		end if;
	end process;
end behavior;


---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
----                                                                                     ----
----                         	  Parrallel Load Counter                                 ----
----                                                                                     ----
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------

--This is a separate component that is used when you want to load
--a value then continue counting from there.  Its mechanics are the
--same as the regular counter, except that it loads the data from
--DIn synchronously while Ld is asserted.  




library IEEE;
	use IEEE.Std_Logic_1164.all;
	use IEEE.std_logic_unsigned.all;
	use IEEE.numeric_std.all;
	
entity ParLdCounter is
	generic(
		 BitSize: integer := 1;  --Specifies the bitsize of the output count.  Default is 1.  Must be >0.
		 EdgeTrig: integer := 1;  --Specifies on which edge to trigger.  Use 1 (default) for rising and 0 for falling edge.  Must be 0 or 1.
		 StepSize: integer := 1 --Specifies how to increment the count on each trigger.  Use positive or negative number for up or down counting.
		 );						--		 Be careful if you set the stepsize larger than the range specified by the bitsize.
	port(
		 Clk: in Std_logic;
		 n_Rst: in Std_logic;
		 En, Ld: in Std_logic;
		 DIn: in Std_logic_vector(BitSize-1 downto 0);
		 DOut: out Std_logic_vector(BitSize-1 downto 0)
		 );
end ParLdCounter;

architecture behavior of ParLdCounter is
	signal Clk_mod: Std_logic;
	signal DOut_Buf: Std_logic_vector(BitSize-1 downto 0);
begin
		
	DOut <= DOut_Buf;	
	
	With EdgeTrig select
	Clk_mod <=
		not Clk when 0,
		Clk when 1,
		'X' when others;

	process(Clk_mod, n_Rst)
	begin
		if n_Rst = '0' then 
			DOut_Buf(BitSize-1 downto 0) <= (others => '0');
		elsif Clk_mod = '1' and Clk_mod'Event then          --using this code instead until the problem is solved
			if Ld = '1' then
				DOut_Buf <= DIn;  --synchronous parallel loading (overrides counting)
			elsif En = '1' then
				DOut_Buf <= DOut_Buf + StepSize;
			else  --do nothing
				DOut_Buf <= DOut_Buf;
			end if;
		end if;
	end process;
end behavior;

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
----                                                                                     ----
----                         Configurable Up & Down Counter                              ----
----                                                                                     ----
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
--This is a separate component that is used when you want to count both up and down.
--Its mechanics are the same as the regular counter, except that it has a RevDir bit
--that reverses its counting direction.


library IEEE;
	use IEEE.Std_Logic_1164.all;
	use IEEE.std_logic_unsigned.all;
	use IEEE.numeric_std.all;
	
entity UpDnCounter is
	generic(
		 BitSize: integer := 1;  --Specifies the bitsize of the output count.  Default is 1.  Must be >0.
		 EdgeTrig: integer := 1;  --Specifies on which edge to trigger.  Use 1 (default) for rising and 0 for falling edge.  Must be 0 or 1.
		 StepSize: integer := 1 --Specifies how to increment the count on each trigger.  Use positive or negative number.  This number will be inverted when the RevDir bit is set high.
		 );						--		 Be careful if you set the stepsize larger than the range specified by the bitsize.
	port(
		 Clk: in Std_logic;
		 n_Rst: in Std_logic;
		 En: in Std_logic;
		 RevDir:  in Std_logic;  --Reverses the counting direction when set to 1.  If stepsize = 1, then setting this bit low will enable upcounting and high enables upcounting.
		 DOut: out Std_logic_vector(BitSize-1 downto 0)
		 );
end UpDnCounter;

architecture behavior of UpDnCounter is
	signal Clk_mod: Std_logic;                --modified clock according to EdgeTrig setting
	signal DOut_Buf: Std_logic_vector(BitSize-1 downto 0);
begin
		
	DOut <= DOut_Buf;	
	
	With EdgeTrig select         --use inverted clock for falling edge triggers
	Clk_mod <=
		not Clk when 0,
		Clk when 1,
		'X' when others;

	process(Clk_mod, n_Rst)
	begin
		if n_Rst = '0' then 
			DOut_Buf(BitSize-1 downto 0) <= (others => '0');
		elsif Clk_mod = '1' and Clk_mod'Event then          --using this code instead until the problem is solved
			if RevDir = '1' and En = '1' then                        --Reverse counting direction when RevDir is set high
				DOut_Buf <= DOut_Buf - StepSize;
			elsif RevDir = '0' and En = '1' then
				DOut_Buf <= DOut_Buf + StepSize;
			else
				DOut_Buf <= DOut_Buf;
			end if;
		end if;
	end process;
end behavior;

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
----                                                                                     ----
----                            Configurable Incrementer                                 ----
----                                                                                     ----
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
--This is a separate component that is used when you want to increment by a set amount.
--Its mechanics are the same as the regular counter, except that it has a scalable vector
--input called "Inc" which controls how much to add while the enable bit is high.


library IEEE;
	use IEEE.Std_Logic_1164.all;
	use IEEE.std_logic_unsigned.all;
	use IEEE.numeric_std.all;
	
entity Incrementer is
	generic(
		 BitSize: integer := 1;  --Specifies the bitsize of the output count.  Default is 1.  Must be >0.
		 IncSize: integer := 1;  --Specifies the bitsize of the increment input.  Must be <= bitsize.
		 EdgeTrig: integer := 1  --Specifies on which edge to trigger.  Use 1 (default) for rising and 0 for falling edge.  Must be 0 or 1.
		 );						--		 Be careful if you set the stepsize larger than the range specified by the bitsize.
	port(
		 Clk: in Std_logic;
		 n_Rst: in Std_logic;
		 y_Rst: in Std_logic;
		 En: in Std_logic;
		 Inc:  in Std_logic_vector(IncSize-1 downto 0);  --controls how much to increment while the enable bit is high
		 DOut: out Std_logic_vector(BitSize-1 downto 0)
		 );
end Incrementer;

architecture behavior of Incrementer is
	signal Clk_mod: Std_logic;                --modified clock according to EdgeTrig setting
	signal DOut_Buf: Std_logic_vector(BitSize-1 downto 0);
begin
		
	DOut <= DOut_Buf;	
	
	With EdgeTrig select         --use inverted clock for falling edge triggers
	Clk_mod <=
		not Clk when 0,
		Clk when 1,
		'X' when others;

	process(Clk_mod, n_Rst)
	begin
		if n_Rst = '0' then 
			DOut_Buf(BitSize-1 downto 0) <= (others => '0');
		elsif Clk_mod = '1' and Clk_mod'Event then          --using this code instead until the problem is solved
			if y_Rst = '1' then
				DOut_Buf <= (others => '0');
			elsif En = '1' then
				DOut_Buf <= DOut_Buf + Inc;
			else 
				DOut_Buf <= DOut_Buf;
			end if;
		end if;
	end process;
end behavior;

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
----                                                                                     ----
----                                  Gray Encoder                                       ----
----                                                                                     ----
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
--This is a component that will convert a variable size std_logic_vector into its 
--gray-encoded equivalent.

library IEEE;
	use IEEE.Std_Logic_1164.all;
	use IEEE.std_logic_unsigned.all;
	use IEEE.numeric_std.all;

Entity GrayEncoder is
generic(
	BitSize: integer := 3
	);
port(
	Clk: in std_logic;
	DIn: in std_logic_vector(BitSize-1 downto 0);
	DOut: out std_logic_vector(BitSize-1 downto 0)
	);
End GrayEncoder;

architecture behavior of GrayEncoder is

begin

	Clock_Process: Process(Clk, DIn)
	begin
		if Clk = '1' and Clk'Event then
			DOut(BitSize-1) <= DIn(BitSize-1);
			for i in BitSize-2 downto 0 loop
				DOut(i) <= DIn(i) xor DIn(i+1);
			end loop;
		end if;
	end process;
	
end behavior;

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
----                                                                                     ----
----                                  Gray Decoder                                       ----
----                                                                                     ----
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
--This is a component that will convert a variable size std_logic_vector into its 
--from gray-code to its bineary-encoded equivalent.

library IEEE;
	use IEEE.Std_Logic_1164.all;
	use IEEE.std_logic_unsigned.all;
	use IEEE.numeric_std.all;

Entity GrayDecoder is
generic(
	BitSize: integer := 3
	);
port(
	Clk: in std_logic;
	DIn: in std_logic_vector(BitSize-1 downto 0);
	DOut: out std_logic_vector(BitSize-1 downto 0)
	);
End GrayDecoder;
	
architecture behavior of GrayDecoder is
	signal Intermediate: std_logic_vector(BitSize-1 downto 0);	
begin
	
	Loop_Process: Process(DIn, Intermediate)
	begin
		Intermediate(BitSize - 1) <= DIn(BitSize-1);
		for i in BitSize-2 downto 0 loop
			Intermediate(i) <= DIn(i) xor Intermediate(i+1);
		end loop;
	end process;
	
	Clock_Process: Process(Clk, Intermediate)
	begin
		if Clk = '1' and Clk'Event then	
			DOut <= Intermediate;
		end if;
	end process;
	
end behavior;