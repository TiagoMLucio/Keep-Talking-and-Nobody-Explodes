onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 45 /modulo_memoria_tb/dut/uc/Eatual
add wave -noupdate -divider Entradas
add wave -noupdate -height 45 /modulo_memoria_tb/clk_in
add wave -noupdate -height 45 /modulo_memoria_tb/rst_in
add wave -noupdate -height 45 /modulo_memoria_tb/iniciar_in
add wave -noupdate -height 45 /modulo_memoria_tb/botoes_in
add wave -noupdate -divider Saidas
add wave -noupdate -color Gold -height 45 /modulo_memoria_tb/estagio_out
add wave -noupdate -color {Slate Blue} -height 45 -radix unsigned /modulo_memoria_tb/dut/fd/display
add wave -noupdate -color {Slate Blue} -height 45 -radix unsigned /modulo_memoria_tb/dut/fd/num1
add wave -noupdate -color {Slate Blue} -height 45 -radix unsigned /modulo_memoria_tb/dut/fd/num2
add wave -noupdate -color {Slate Blue} -height 45 -radix unsigned /modulo_memoria_tb/dut/fd/num3
add wave -noupdate -color {Slate Blue} -height 45 -radix unsigned /modulo_memoria_tb/dut/fd/num4
add wave -noupdate -height 45 /modulo_memoria_tb/pronto_out
add wave -noupdate -height 45 /modulo_memoria_tb/errou_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3251669 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 220
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
WaveRestoreZoom {1816300 ps} {3538300 ps}
