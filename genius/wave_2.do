onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 40 /modulo_genius_tb_2/dut/uc/Eatual
add wave -noupdate -divider Entradas
add wave -noupdate -height 40 /modulo_genius_tb_2/dut/clock
add wave -noupdate -height 40 /modulo_genius_tb_2/rst_in
add wave -noupdate -height 40 /modulo_genius_tb_2/iniciar_in
add wave -noupdate -height 40 /modulo_genius_tb_2/botoes_in
add wave -noupdate -height 40 /modulo_genius_tb_2/tem_letra_in
add wave -noupdate -height 40 -radix unsigned /modulo_genius_tb_2/erros_in
add wave -noupdate -divider Saidas
add wave -noupdate -height 40 /modulo_genius_tb_2/pronto_out
add wave -noupdate -height 40 /modulo_genius_tb_2/errou_out
add wave -noupdate -height 40 /modulo_genius_tb_2/leds_out
add wave -noupdate -divider Depuracao
add wave -noupdate -height 40 /modulo_genius_tb_2/igual_out
add wave -noupdate -height 40 /modulo_genius_tb_2/dut/jogada_feita
add wave -noupdate -height 40 -radix unsigned /modulo_genius_tb_2/dut/db_contagem_t
add wave -noupdate -height 40 -radix binary /modulo_genius_tb_2/dut/db_jogada_t
add wave -noupdate -height 40 -radix unsigned /modulo_genius_tb_2/dut/db_rodada_t
add wave -noupdate -height 40 -radix unsigned /modulo_genius_tb_2/dut/db_memoria_t
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {234731688 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 288
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
WaveRestoreZoom {0 ps} {277495808 ps}
