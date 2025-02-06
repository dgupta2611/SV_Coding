onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/clk
add wave -noupdate /tb/rst_n
add wave -noupdate /tb/en_w1_mem1
add wave -noupdate /tb/en_w2_mem1
add wave -noupdate /tb/en_w1_mem0
add wave -noupdate /tb/en_w2_mem0
add wave -noupdate /tb/addr_w1_mem0
add wave -noupdate /tb/data_w1_mem0
add wave -noupdate /tb/addr_w1_mem1
add wave -noupdate /tb/addr_w2_mem0
add wave -noupdate /tb/addr_w2_mem1
add wave -noupdate /tb/data_w2_mem0
add wave -noupdate /tb/data_w1_mem1
add wave -noupdate /tb/data_w2_mem1
add wave -noupdate /tb/en_r1_mem0
add wave -noupdate /tb/en_r1_mem1
add wave -noupdate /tb/en_r2_mem0
add wave -noupdate /tb/en_r2_mem1
add wave -noupdate /tb/addr_r1_mem0
add wave -noupdate /tb/addr_r1_mem1
add wave -noupdate /tb/addr_r2_mem0
add wave -noupdate /tb/addr_r2_mem1
add wave -noupdate /tb/data_r1_mem0
add wave -noupdate /tb/data_r2_mem0
add wave -noupdate /tb/data_r1_mem1
add wave -noupdate /tb/data_r2_mem1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {741 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 163
configure wave -valuecolwidth 146
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
WaveRestoreZoom {704 ns} {822 ns}
