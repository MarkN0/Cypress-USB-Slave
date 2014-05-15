----------------------------------------------------------------------------------
-- Engineer:
-- 
-- Design Name:  FX2LP-FPGA interface (loopback)
-- Module Name:  
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;      
use IEEE.STD_LOGIC_ARITH.ALL;     
use IEEE.STD_LOGIC_UNSIGNED.ALL;	
use ieee.numeric_std.all;
--library UNISIM;
--use UNISIM.vcomponents.all;

entity fx2lp_slaveFIFO2b_loopback_fpga_top is
	Port ( 
		--	 reset_n_out   : out STD_LOGIC;                     --used for TB
		fdata     : inout  STD_LOGIC_VECTOR(15 downto 0);  --  FIFO data lines.
		faddr     : out STD_LOGIC_VECTOR(1 downto 0);     --  FIFO select lines
		slrd      : out STD_LOGIC;                        -- Read control line
		slwr      : out STD_LOGIC;                        -- Write control line
		
		flagd     : in  STD_LOGIC;                        --EP6 full flag
		flaga     : in  STD_LOGIC;                        --EP2 empty flag
		clk       : in  STD_LOGIC;                        --FPGA Clock
		sloe      : out STD_LOGIC;                        --Slave Output Enable control
		done      : out STD_LOGIC;
		clk_out   : out STD_LOGIC;
		pkt_end   : out STD_LOGIC;
		dbug_sig  : out STD_LOGIC
		
		);
end fx2lp_slaveFIFO2b_loopback_fpga_top;

architecture fx2lp_slaveFIFO2b_loopback_fpga_top_arch of fx2lp_slaveFIFO2b_loopback_fpga_top is
	
	component FPGA_CLK
		port(	
			POWERDOWN : in    std_logic;
			CLKA      : in    std_logic;
			LOCK      : out   std_logic;
			GLA       : out   std_logic;
			GLB       : out   std_logic
			);
	end component;
	
	--component fifo_512x8
	--		port(
	--			din		: in std_logic_vector(15 downto 0);
	--			write_busy	: in std_logic;
	--			fifo_full	: out std_logic;
	--			dout		: out std_logic_vector(15 downto 0);
	--			read_busy 	: in std_logic;
	--			fifo_empty	: out std_logic;
	--			fifo_clk	: in std_logic;
	--			reset_al	: in std_logic;
	--			fifo_flush	: in std_logic
	--			);
	--	end component;
	
	component AN_FIFO_512x16 is
		
		port( DATA   : in    std_logic_vector(15 downto 0);
			Q      : out   std_logic_vector(15 downto 0);
			WE     : in    std_logic;
			RE     : in    std_logic;
			WCLOCK : in    std_logic;
			RCLOCK : in    std_logic;
			FULL   : out   std_logic;
			EMPTY  : out   std_logic;
			RESET  : in    std_logic
			);
	end component;
	
	
	--loopback fsm signal
	type loop_back_states is (loop_back_idle, loop_back_read, loop_back_wait_flagd, loop_back_write);
	signal current_loop_back_state, next_loop_back_state : loop_back_states;
	
	signal slrd_n, slwr_n, sloe_n : std_logic;
	signal fifo_data_in, fifo_data_out, data_out : std_logic_vector(15 downto 0);
	
	signal CLK_OUT_0, clk_out_90, clk_out_180, CLK_OUT_270 : std_logic;
	signal reset_n : std_logic;
	signal faddr_n : std_logic_vector(1 downto 0);
	signal fifo_push, fifo_pop, fifo_full, fifo_empty : std_logic;
	signal slwr_d_n : std_logic;
	signal fifo_flush : std_logic;
	signal done_d : std_logic;
	signal wait_s : std_logic_vector(3 downto 0); 
	
	signal n_reset_n : std_logic;  	
	signal n_fifo_empty : std_logic;
	
	
begin --archetecture begining
	
	--oddr_y : ODDR2 	                                           -- clk out buffer
	--	port map
	--		(
	--		D0 	=> '1',
	--		D1 	=> '0',
	--		CE 	=> '1',
	--		C0	=> clk_out_180,  
	--		C1	=> (not clk_out_180), 
	--		R  	=> '0',
	--		S  	=> '0',
	--		Q  	=> clk_out
	--		);
	
	n_reset_n <= not reset_n;
	clk_out <= clk_out_180;
	
	pll : FPGA_CLK  	                                    --PLL
	port map(
		POWERDOWN => '1',
		CLKA => clk,
		LOCK => reset_n,
		GLA  => clk_out_180,
		GLB  => clk_out_0
		);
	
	fifo1 : 	AN_FIFO_512x16
	port map( 
		DATA   => fifo_data_in,
		Q      => fifo_data_out,
		WE     => fifo_push,
		RE     => fifo_pop,
		WCLOCK => clk_out_0,
		RCLOCK => clk_out_0,
		FULL   => fifo_full, 
		EMPTY  => fifo_empty,
		RESET  => n_reset_n
		);	  
	
	--fifo_empty <= not n_fifo_empty;
	--fifo : fifo_512x8
	--	port map(
	--		din	          => fifo_data_in,	
	--		write_busy	  => (fifo_push),
	--		fifo_full	  => fifo_full, 
	--		dout		  => fifo_data_out,
	--		read_busy 	  => (fifo_pop),
	--		fifo_empty	  => fifo_empty,
	--		fifo_clk	  => clk_out_0,
	--		reset_al	  => reset_n,
	--		fifo_flush	  => fifo_flush
	--		);
	
	
	--output signal asignment
	
	--reset_n_out <= reset_n;	
	slwr  <= slwr_n;
	slrd  <= slrd_n;
	sloe  <= sloe_n;
	faddr <= faddr_n;
	
	fdata <= data_out;
	pkt_end <= fifo_empty;
	
	done <= done_d;
	
	process(clk_out_0, reset_n) begin
		if(reset_n = '0')then
			done_d <= '0';
		elsif(clk_out_0'event and clk_out_0 = '1')then
			if(wait_s = "1010")then
				done_d <= '1';
			end if;	
		end if;
	end process;
	
	process(clk_out_0, reset_n) begin
		if(reset_n = '0')then
			wait_s <= "0000";
		elsif(clk_out_0'event and clk_out_0 = '1')then
			if(wait_s < "1010")then
				wait_s <= wait_s + '1';
			end if;	
		end if;
	end process;
	
	fifo_push <= ((not slrd_n) and (not fifo_full));
	fifo_pop  <= ((not slwr_n) and (not fifo_empty));
	
	process(clk_out_0, reset_n) begin
		if(reset_n = '0')then
			slwr_d_n <= '1';
		elsif(clk_out_0'event and clk_out_0 = '1')then
			slwr_d_n <= slwr_n;
		end if;
	end process;
	
	dbug_sig <= slwr_d_n;
	
	--address of slavefifo
	
	process(current_loop_back_state)begin
		if((current_loop_back_state = loop_back_idle) or (current_loop_back_state = loop_back_read))then
			faddr_n <= "00";
		else
			faddr_n <= "10"	;
		end if;
	end process;
	
	process(current_loop_back_state)begin
		if((current_loop_back_state = loop_back_idle))then
			fifo_flush <= '1';
		else
			fifo_flush <= '0';
		end if;
	end process;
	
	
	
	--read control signal generation
	process(current_loop_back_state, flaga)begin
		if((current_loop_back_state = loop_back_read) and (flaga = '1'))then
			slrd_n <= '0';
			sloe_n <= '0';
		else
			slrd_n <= '1';
			sloe_n <= '1';
		end if;
	end process;
	
	
	process(fdata, slrd_n)begin
		if(slrd_n = '0')then
			fifo_data_in <= fdata;
		else
			fifo_data_in <= "0000000000000000";
		end if;
	end process;	
	
	--write control signal generation
	process(current_loop_back_state, flagd)begin
		if((current_loop_back_state = loop_back_write) and (flagd = '1') and (fifo_empty = '0'))then
			slwr_n <= '0';
		else
			slwr_n <= '1';
		end if;
	end process;
	
	
	--loopback mode state machine 
	loopback_mode_fsm_f : process(clk_out_0, reset_n) begin
		if(reset_n = '0')then
			current_loop_back_state <= loop_back_idle;
		elsif(clk_out_0'event and clk_out_0 = '1')then
			current_loop_back_state <= next_loop_back_state;
		end if;
	end process;
	
	--LoopBack mode state machine combo
	loopback_mode_fsm : process(flaga, flagd, current_loop_back_state) begin
		next_loop_back_state <= current_loop_back_state;
		case current_loop_back_state is
			when loop_back_idle =>
				if(flaga = '1')then
					next_loop_back_state <= loop_back_read;
				else
					next_loop_back_state <= loop_back_idle;
				end if;
			
			when loop_back_read => 
				if(flaga = '0')then
					next_loop_back_state <= loop_back_wait_flagd;
				else
					next_loop_back_state <= loop_back_read;
				end if;
			
			when loop_back_wait_flagd =>
				if(flagd = '1')then
					next_loop_back_state <= loop_back_write;
				else 
					next_loop_back_state <= loop_back_wait_flagd;
				end if;
			
			when loop_back_write =>
				if((flagd = '0') or (fifo_empty = '1'))then
					next_loop_back_state <= loop_back_idle;
				else 
					next_loop_back_state <= loop_back_write;
				end if;
			
			when others =>
			next_loop_back_state <= loop_back_idle;
		end case;
	end process;
	
	
	process(slwr_n, fifo_data_out)begin
		if(slwr_n = '1')then
			data_out <= (others =>'Z');
		else
			data_out <= fifo_data_out;  
			--data_out <= std_logic_vector(to_signed(1,16));
		end if;
	end process;
	
	
end architecture;

