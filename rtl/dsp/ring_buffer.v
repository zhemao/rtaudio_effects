module ring_buffer (
    input clk,
    input reset,

    input  [6:0] last_addr,
    output [6:0] cur_addr,

    input  fifo_write,
    input  [15:0] fifo_data,

    input  [6:0]  readaddr,
    output [15:0] readdata
);

reg [6:0] cur_index = 7'd0;
assign cur_addr = cur_index;

audio_ram aram (
    .clock (clk),
    .data (fifo_data),
    .rdaddress (readaddr),
    .wraddress (cur_index),
    .wren (fifo_write),
    .q (readdata)
);

always @(posedge clk) begin
    if (reset) begin
        cur_index <= 7'd0;
    end else if (fifo_write) begin
        if (cur_index == last_addr)
            cur_index <= 7'd0;
        else
            cur_index <= cur_index + 1'b1;
    end
end

endmodule
