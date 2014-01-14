add wave i2c_sclk
add wave i2c_sdat

add wave start
add wave done
add wave ack

add wave i2c/sclk_divider
add wave i2c/stage
add wave i2c/acks

add wave -radix hexadecimal i2c_data;
add wave -radix hexadecimal slave_data;

run 80 us
