onerror {resume}
radix define InputCommand {
    "2'b00" "ID" -color "blue",
    "2'b01" "SP" -color "yellow",
    "2'b10" "SK" -color "orange",
    "2'b11" "ST" -color "red",
    -default default
}
radix define ReadyBusy {
    "0" "BUSY" -color "red",
    "1" "READY" -color "blue",
    -default symbolic
}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Magenta -height 64 -itemcolor Magenta /input_interface_tb/clk_tb
add wave -noupdate -color {Blue Violet} -height 64 -itemcolor {Blue Violet} /input_interface_tb/rst_tb
add wave -noupdate -height 64 /input_interface_tb/din_tb
add wave -noupdate -height 64 -radix InputCommand -childformat {{{/input_interface_tb/cmd_tb[1]} -radix InputCommand} {{/input_interface_tb/cmd_tb[0]} -radix InputCommand}} -subitemconfig {{/input_interface_tb/cmd_tb[1]} {-height 15 -radix InputCommand} {/input_interface_tb/cmd_tb[0]} {-height 15 -radix InputCommand}} /input_interface_tb/cmd_tb
add wave -noupdate -height 64 -radix ReadyBusy -radixenum symbolic /input_interface_tb/ready_w
add wave -noupdate -color Maroon -height 64 -itemcolor Maroon /input_interface_tb/enginC_w
add wave -noupdate -color Yellow -height 64 -itemcolor Yellow /input_interface_tb/plain_tb
add wave -noupdate -color Orange -height 64 -itemcolor Orange /input_interface_tb/key_tb
add wave -noupdate -height 64 -radix ReadyBusy /input_interface_tb/engind
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {12 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 211
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ns} {60 ns}
