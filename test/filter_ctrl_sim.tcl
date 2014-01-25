add wave audio_clk
add wave main_clk

add wave sample_req
add wave sample_end
add wave reset

add wave -radix hexadecimal audio_input
add wave -radix hexadecimal audio_output
add wave -radix unsigned romaddr

add wave -radix hexadecimal fc/fir_result
add wave -radix hexadecimal fc/fir/accum_value

add wave -radix hexadecimal fc/fir_audio_data
add wave -radix hexadecimal fc/fir_kernel_data

add wave -radix unsigned fc/fir_audio_addr
add wave -radix unsigned fc/fir_kernel_addr

add wave -radix unsigned fc/rb_cur_addr

add wave fc/rb/fifo_write
add wave -radix unsigned fc/rb/cur_index
add wave -radix hexadecimal fc/rb/fifo_data

add wave fc/fir/reset

run 4536 us
