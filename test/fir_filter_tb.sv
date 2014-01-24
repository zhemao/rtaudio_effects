module fir_filter_tb ();

parameter expected = 7'd5;

reg [15:0] audio_rom [0:3];
reg [15:0] kernel_rom [0:3];

wire [6:0] audio_addr;
reg  [15:0] audio_data;

wire [6:0] kernel_addr;
reg  [15:0] kernel_data;

reg clk = 1'b1;
reg reset;

wire [15:0] result;
wire done;

always #10000 clk = !clk;

always @(posedge clk) begin
    audio_data <= audio_rom[audio_addr];
    kernel_data <= kernel_rom[kernel_addr];
end

fir_filter fir (
    .clk (clk),
    .reset (reset),

    .start_addr (7'd1),
    .last_addr (7'd3),

    .audio_addr (audio_addr),
    .audio_data (audio_data),

    .kernel_addr (kernel_addr),
    .kernel_data (kernel_data),

    .result (result),
    .done (done)
);

initial begin
    audio_rom[0] = 16'd2;
    audio_rom[1] = 16'd3;
    audio_rom[2] = 16'd6;
    audio_rom[3] = 16'd1;

    kernel_rom[0] = 16'd32767;
    kernel_rom[1] = 16'd32764;
    kernel_rom[2] = 16'd32745;
    kernel_rom[3] = 16'd32677;

    reset = 1'b0;
    #20000 reset = 1'b1;
    #20000 reset = 1'b0;

    #140000 assert (done);
    assert (result == expected);
end

endmodule
