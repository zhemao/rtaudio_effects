module i2c_av_config (
    input clk,
    input reset,

    output i2c_sclk,
    inout  i2c_sdat
);

reg [23:0] i2c_data;

reg  i2c_start;
wire i2c_done;
wire i2c_ack;

i2c_controller control (
    .clk (clk),
    .i2c_sclk (i2c_sclk),
    .i2c_sdat (i2c_sdat),
    .i2c_data (i2c_data),
    .start (i2c_start),
    .done (i2c_done),
    .ack (i2c_ack)
);

endmodule
