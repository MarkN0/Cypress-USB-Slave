SetActiveLib -work
comp -include "$dsn\src\AN_FIFO_512x16.vhd" 
comp -include "$dsn\src\FPGA_CLK.vhd" 
comp -include "$dsn\src\fx2lp_slaveFIFO2b_loopback_fpga_top.vhd" 
comp -include "$dsn\src\TestBench\fx2lp_slavefifo2b_loopback_fpga_top_TB.vhd" 
asim +access +r TESTBENCH_FOR_fx2lp_slavefifo2b_loopback_fpga_top 
wave -noreg fdata
wave -noreg faddr
wave -noreg slrd
wave -noreg slwr
wave -noreg flagd
wave -noreg flaga
wave -noreg clk
wave -noreg sloe
wave -noreg done
wave -noreg clk_out
wave -noreg pkt_end
wave -noreg dbug_sig	

wave /fx2lp_slavefifo2b_loopback_fpga_top_tb/UUT/current_loop_back_state  
wave /fx2lp_slavefifo2b_loopback_fpga_top_tb/UUT/fifo1/DATA 
wave /fx2lp_slavefifo2b_loopback_fpga_top_tb/UUT/fifo1/Q 
wave /fx2lp_slavefifo2b_loopback_fpga_top_tb/UUT/fifo1/WE 
wave /fx2lp_slavefifo2b_loopback_fpga_top_tb/UUT/fifo1/RE
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\fx2lp_slavefifo2b_loopback_fpga_top_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_fx2lp_slavefifo2b_loopback_fpga_top 
																			
																			
trace -rec *
run 50 us