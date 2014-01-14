module i2c_controller_tb ();

reg  clk = 1'b1;
wire i2c_sclk;
wire i2c_sdat;
reg  start;
wire done;
wire ack;
reg [23:0] i2c_data;

i2c_controller i2c (
    .clk (clk),
    .i2c_sclk (i2c_sclk),
    .i2c_sdat (i2c_sdat),
    .start (start),
    .done  (done),
    .ack   (ack),
    .i2c_data (i2c_data)
);

always #10000 clk = !clk;

initial begin
    i2c_data = 24'h3a42f2;
    start = 1'b1;
    #20000 start = 1'b0;
end

endmodule
