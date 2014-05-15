SetActiveLib -work
comp -include "$dsn\src\AN_FIFO_512x16.vhd" 
comp -include "$dsn\src\TestBench\an_fifo_512x16_TB.vhd" 
asim +access +r TESTBENCH_FOR_an_fifo_512x16 
wave 
wave -noreg DATA
wave -noreg Q
wave -noreg WE
wave -noreg RE
wave -noreg WCLOCK
wave -noreg RCLOCK
wave -noreg FULL
wave -noreg EMPTY
wave -noreg RESET
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\an_fifo_512x16_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_an_fifo_512x16 
