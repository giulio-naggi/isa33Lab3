set name "RV32I"
set architecture_name "structural"
set clock_name "CLK"
set clock_period 1.7

set file_names { "RISC" "FF" "REGISTER_en" "REGISTER" "ADDER_PC" "ALU" "BRANCH_ADDER" "BRANCH_COMP" "DECODING_UNIT"  "FORWARDING_UNIT" "HAZARD_UNIT" "RF" "CU" "DATAPATH" "RV32I" }

foreach file $file_names {
	analyze -library "work" -format vhdl "../src/${file}.vhd"
}

set power_preserve_rtl_hier_names true
elaborate $name -architecture $architecture_name -library work > elab.log
create_clock -name "CLK" -period $clock_period $clock_name
set_dont_touch_network CLK
set_clock_uncertainty 0.07 [get_clocks CLK]
set_input_delay 0.5 -max -clock CLK [remove_from_collection [all_inputs] CLK]
set_output_delay 0.5 -max -clock CLK [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]
compile_ultra
report_timing > ${name}_timing.txt
report_area > ${name}_area.txt
report_resources > ${name}_resources.txt
ungroup -all -flatten
change_names -hierarchy -rules verilog
write_sdf ${name}.sdf
write -f verilog -hierarchy -output ${name}.v
write_sdc ${name}.sdc
