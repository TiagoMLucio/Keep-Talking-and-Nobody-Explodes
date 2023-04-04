onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color {Medium Aquamarine} -height 28 /ktne_tb/dut/uc/Eatual
add wave -noupdate -divider Entradas
add wave -noupdate -height 28 /ktne_tb/clk_in
add wave -noupdate -color {Dark Olive Green} -height 28 /ktne_tb/start_in
add wave -noupdate -height 28 /ktne_tb/sel_hex_in
add wave -noupdate -divider Saidas
add wave -noupdate -color Yellow -height 28 /ktne_tb/dut/minutes
add wave -noupdate -color Yellow -height 28 /ktne_tb/dut/seconds_ten
add wave -noupdate -color Yellow -height 28 /ktne_tb/dut/seconds_unit
add wave -noupdate -color Khaki -height 28 /ktne_tb/dut/errors
add wave -noupdate -color Khaki -height 28 -radix hexadecimal /ktne_tb/dut/serial1
add wave -noupdate -color Khaki -height 28 -radix hexadecimal /ktne_tb/dut/serial2
add wave -noupdate -color {Slate Blue} -height 28 /ktne_tb/defused_out
add wave -noupdate -color {Slate Blue} -height 28 /ktne_tb/exploded_out
add wave -noupdate -divider Genius
add wave -noupdate -color {Medium Aquamarine} -height 28 /ktne_tb/dut/genius/uc/Eatual
add wave -noupdate -color Cyan -height 28 /ktne_tb/botoes_gen_in
add wave -noupdate -color Salmon -height 28 /ktne_tb/leds_gen_out
add wave -noupdate -color {Slate Blue} -height 28 /ktne_tb/pronto_gen_out
add wave -noupdate -divider Memoria
add wave -noupdate -color {Medium Aquamarine} -height 28 /ktne_tb/dut/memoria/uc/Eatual
add wave -noupdate -color Cyan -height 28 /ktne_tb/botoes_mem_in
add wave -noupdate -color Salmon -height 28 /ktne_tb/estagio_mem_out
add wave -noupdate -color Gray60 -height 28 -radix unsigned /ktne_tb/dut/memoria/display_t
add wave -noupdate -color Gray60 -height 28 -radix unsigned /ktne_tb/dut/memoria/num1_t
add wave -noupdate -color Gray60 -height 28 -radix unsigned /ktne_tb/dut/memoria/num2_t
add wave -noupdate -color Gray60 -height 28 -radix unsigned /ktne_tb/dut/memoria/num3_t
add wave -noupdate -color Gray60 -height 28 -radix unsigned /ktne_tb/dut/memoria/num4_t
add wave -noupdate -color {Slate Blue} -height 28 /ktne_tb/pronto_mem_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {310632119 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 224
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {336193200 ps}
