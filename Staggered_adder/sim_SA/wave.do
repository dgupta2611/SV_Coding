onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/Clock
add wave -noupdate /tb/A
add wave -noupdate /tb/B
add wave -noupdate /tb/CI
add wave -noupdate /tb/S
add wave -noupdate /tb/CO
add wave -noupdate /tb/Error
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 88
configure wave -valuecolwidth 142
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
WaveRestoreZoom {0 ns} {48 ns}
