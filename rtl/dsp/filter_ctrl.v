module filter_ctrl (
    input audio_clk,
    input main_clk,
    input reset,

    input sample_end,
    input sample_req,

    input      [15:0] audio_input,
    output reg [15:0] audio_output
);

parameter LASTADDR = 7'd100;

reg cur_end = 1'b0;
reg last_end = 1'b0;

reg  rb_fifo_write = 1'b0;
wire [6:0] rb_cur_addr;

reg  fir_reset = 1'b0;
wire [6:0]  fir_audio_addr;
wire [15:0] fir_audio_data;
wire [6:0]  fir_kernel_addr;
wire [15:0] fir_kernel_data;
wire [15:0] fir_result;

ring_buffer rb (
    .clk (main_clk),
    .reset (reset),

    .last_addr(LASTADDR),
    .cur_addr (rb_cur_addr),

    .fifo_write (rb_fifo_write),
    .fifo_data (audio_input),

    .readaddr (fir_audio_addr),
    .readdata (fir_audio_data)
);

fir_filter fir (
    .clk (main_clk),
    .reset (fir_reset),

    .start_addr (rb_cur_addr),
    .last_addr (LASTADDR),

    .audio_addr (fir_audio_addr),
    .audio_data (fir_audio_data),

    .kernel_addr (fir_kernel_addr),
    .kernel_data (fir_kernel_data),

    .result (fir_result)
);

kernel_rom krom (
    .address (fir_kernel_addr),
    .clock (main_clk),
    .q (fir_kernel_data)
);

always @(posedge audio_clk) begin
    if (sample_req) begin
        audio_output <= fir_result;
    end
end

always @(posedge main_clk) begin
    cur_end <= sample_end;
    last_end <= cur_end;

    if (cur_end && !last_end) begin
        rb_fifo_write <= 1'b1;
    end else if (rb_fifo_write) begin
        rb_fifo_write <= 1'b0;
        fir_reset <= 1'b1;
    end else begin
        fir_reset <= 1'b0;
    end
end

endmodule
