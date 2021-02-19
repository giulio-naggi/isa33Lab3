onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/processor/CLK
add wave -noupdate /tb/processor/dp/RST_n
add wave -noupdate -radix hexadecimal -radixshowbase 0 /tb/processor/dp/PC_IF
add wave -noupdate -radix hexadecimal -childformat {{/tb/processor/dp/register_file_inst/reg_file(31) -radix hexadecimal} {/tb/processor/dp/register_file_inst/reg_file(30) -radix hexadecimal} {/tb/processor/dp/register_file_inst/reg_file(29) -radix hexadecimal} {/tb/processor/dp/register_file_inst/reg_file(28) -radix hexadecimal} {/tb/processor/dp/register_file_inst/reg_file(27) -radix hexadecimal} {/tb/processor/dp/register_file_inst/reg_file(26) -radix hexadecimal} {/tb/processor/dp/register_file_inst/reg_file(25) -radix hexadecimal} {/tb/processor/dp/register_file_inst/reg_file(24) -radix hexadecimal} {/tb/processor/dp/register_file_inst/reg_file(23) -radix hexadecimal} {/tb/processor/dp/register_file_inst/reg_file(22) -radix hexadecimal} {/tb/processor/dp/register_file_inst/reg_file(21) -radix hexadecimal} {/tb/processor/dp/register_file_inst/reg_file(20) -radix hexadecimal} {/tb/processor/dp/register_file_inst/reg_file(19) -radix hexadecimal} {/tb/processor/dp/register_file_inst/reg_file(18) -radix hexadecimal} {/tb/processor/dp/register_file_inst/reg_file(17) -radix hexadecimal} {/tb/processor/dp/register_file_inst/reg_file(16) -radix hexadecimal} {/tb/processor/dp/register_file_inst/reg_file(15) -radix hexadecimal} {/tb/processor/dp/register_file_inst/reg_file(14) -radix hexadecimal} {/tb/processor/dp/register_file_inst/reg_file(13) -radix hexadecimal} {/tb/processor/dp/register_file_inst/reg_file(12) -radix hexadecimal} {/tb/processor/dp/register_file_inst/reg_file(11) -radix hexadecimal} {/tb/processor/dp/register_file_inst/reg_file(10) -radix hexadecimal} {/tb/processor/dp/register_file_inst/reg_file(9) -radix hexadecimal} {/tb/processor/dp/register_file_inst/reg_file(8) -radix hexadecimal} {/tb/processor/dp/register_file_inst/reg_file(7) -radix hexadecimal} {/tb/processor/dp/register_file_inst/reg_file(6) -radix hexadecimal} {/tb/processor/dp/register_file_inst/reg_file(5) -radix hexadecimal} {/tb/processor/dp/register_file_inst/reg_file(4) -radix hexadecimal} {/tb/processor/dp/register_file_inst/reg_file(3) -radix hexadecimal} {/tb/processor/dp/register_file_inst/reg_file(2) -radix hexadecimal} {/tb/processor/dp/register_file_inst/reg_file(1) -radix hexadecimal} {/tb/processor/dp/register_file_inst/reg_file(0) -radix hexadecimal}} -radixshowbase 0 -subitemconfig {/tb/processor/dp/register_file_inst/reg_file(31) {-height 15 -radix hexadecimal -radixshowbase 0} /tb/processor/dp/register_file_inst/reg_file(30) {-height 15 -radix hexadecimal -radixshowbase 0} /tb/processor/dp/register_file_inst/reg_file(29) {-height 15 -radix hexadecimal -radixshowbase 0} /tb/processor/dp/register_file_inst/reg_file(28) {-height 15 -radix hexadecimal -radixshowbase 0} /tb/processor/dp/register_file_inst/reg_file(27) {-height 15 -radix hexadecimal -radixshowbase 0} /tb/processor/dp/register_file_inst/reg_file(26) {-height 15 -radix hexadecimal -radixshowbase 0} /tb/processor/dp/register_file_inst/reg_file(25) {-height 15 -radix hexadecimal -radixshowbase 0} /tb/processor/dp/register_file_inst/reg_file(24) {-height 15 -radix hexadecimal -radixshowbase 0} /tb/processor/dp/register_file_inst/reg_file(23) {-height 15 -radix hexadecimal -radixshowbase 0} /tb/processor/dp/register_file_inst/reg_file(22) {-height 15 -radix hexadecimal -radixshowbase 0} /tb/processor/dp/register_file_inst/reg_file(21) {-height 15 -radix hexadecimal -radixshowbase 0} /tb/processor/dp/register_file_inst/reg_file(20) {-height 15 -radix hexadecimal -radixshowbase 0} /tb/processor/dp/register_file_inst/reg_file(19) {-height 15 -radix hexadecimal -radixshowbase 0} /tb/processor/dp/register_file_inst/reg_file(18) {-height 15 -radix hexadecimal -radixshowbase 0} /tb/processor/dp/register_file_inst/reg_file(17) {-height 15 -radix hexadecimal -radixshowbase 0} /tb/processor/dp/register_file_inst/reg_file(16) {-height 15 -radix hexadecimal -radixshowbase 0} /tb/processor/dp/register_file_inst/reg_file(15) {-height 15 -radix hexadecimal -radixshowbase 0} /tb/processor/dp/register_file_inst/reg_file(14) {-height 15 -radix hexadecimal -radixshowbase 0} /tb/processor/dp/register_file_inst/reg_file(13) {-height 15 -radix hexadecimal -radixshowbase 0} /tb/processor/dp/register_file_inst/reg_file(12) {-height 15 -radix hexadecimal -radixshowbase 0} /tb/processor/dp/register_file_inst/reg_file(11) {-height 15 -radix hexadecimal -radixshowbase 0} /tb/processor/dp/register_file_inst/reg_file(10) {-height 15 -radix hexadecimal -radixshowbase 0} /tb/processor/dp/register_file_inst/reg_file(9) {-height 15 -radix hexadecimal -radixshowbase 0} /tb/processor/dp/register_file_inst/reg_file(8) {-height 15 -radix hexadecimal -radixshowbase 0} /tb/processor/dp/register_file_inst/reg_file(7) {-height 15 -radix hexadecimal -radixshowbase 0} /tb/processor/dp/register_file_inst/reg_file(6) {-height 15 -radix hexadecimal -radixshowbase 0} /tb/processor/dp/register_file_inst/reg_file(5) {-height 15 -radix hexadecimal -radixshowbase 0} /tb/processor/dp/register_file_inst/reg_file(4) {-height 15 -radix hexadecimal -radixshowbase 0} /tb/processor/dp/register_file_inst/reg_file(3) {-height 15 -radix hexadecimal -radixshowbase 0} /tb/processor/dp/register_file_inst/reg_file(2) {-height 15 -radix hexadecimal -radixshowbase 0} /tb/processor/dp/register_file_inst/reg_file(1) {-height 15 -radix hexadecimal -radixshowbase 0} /tb/processor/dp/register_file_inst/reg_file(0) {-height 15 -radix hexadecimal -radixshowbase 0}} /tb/processor/dp/register_file_inst/reg_file
add wave -noupdate -radix unsigned -radixshowbase 0 /tb/processor/dp/RD_ID
add wave -noupdate -radix unsigned -radixshowbase 0 /tb/processor/dp/RD_ID_EX
add wave -noupdate -radix unsigned -radixshowbase 0 /tb/processor/dp/RD_MEM_WB
add wave -noupdate -radix unsigned -radixshowbase 0 /tb/processor/dp/RD_OUT_ID
add wave -noupdate -radix unsigned -radixshowbase 0 /tb/processor/dp/RS1_ID
add wave -noupdate -radix unsigned -radixshowbase 0 /tb/processor/dp/RS1_ID_EX
add wave -noupdate -radix unsigned -radixshowbase 0 /tb/processor/dp/RS2_EX_MEM
add wave -noupdate -radix unsigned -radixshowbase 0 /tb/processor/dp/RS2_ID
add wave -noupdate -radix unsigned -radixshowbase 0 /tb/processor/dp/RS2_ID_EX
add wave -noupdate -color Cyan /tb/processor/dp/FW_EX_MEM_A
add wave -noupdate -color Cyan /tb/processor/dp/FW_EX_MEM_B
add wave -noupdate -color Cyan /tb/processor/dp/FW_EX_WB_A
add wave -noupdate -color Cyan /tb/processor/dp/FW_EX_WB_B
add wave -noupdate -color Cyan /tb/processor/dp/FW_ID_MEM_A
add wave -noupdate -color Cyan /tb/processor/dp/FW_ID_MEM_B
add wave -noupdate -color Cyan /tb/processor/dp/FW_ID_WB_A
add wave -noupdate -color Cyan /tb/processor/dp/FW_ID_WB_B
add wave -noupdate -color Cyan /tb/processor/dp/FW_MEM_WB
add wave -noupdate -radix decimal -radixshowbase 0 /tb/processor/dp/alu_component/A
add wave -noupdate -radix decimal -radixshowbase 0 /tb/processor/dp/alu_component/B
add wave -noupdate -radix decimal -radixshowbase 0 /tb/processor/dp/alu_component/ALU_func
add wave -noupdate -radix decimal -radixshowbase 0 /tb/processor/dp/alu_component/ALU_result
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {24 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {3 ns} {50 ns}
