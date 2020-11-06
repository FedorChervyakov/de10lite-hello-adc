onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_BCD_7_segment/dut/BCD
add wave -noupdate /tb_BCD_7_segment/dut/reset
add wave -noupdate /tb_BCD_7_segment/dut/seven_sig
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
configure wave -namecolwidth 196
configure wave -valuecolwidth 44
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 50
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {600 ns}
