module fir_filter (
    input clk,
    input reset,

    input  [6:0]  start_addr,
    input  [6:0]  last_addr,

    output [6:0]  audio_addr,
    input  [15:0] audio_data,

    output [6:0]  kernel_addr,
    input  [15:0] kernel_data,

    output [15:0] result,
    output done
);

wire [31:0] mac_result;
reg mac_en_0 = 1'b0;
reg mac_en_1 = 1'b0;

reg [6:0] audio_index;
reg [6:0] kernel_index;

mult_accum mac (
    .clock0 (clk),
    .result (mac_result),
    .dataa_0 (audio_data),
    .datab_0 (kernel_data),
    .ena0 (mac_en_1),
    .aclr0 (reset)
);

always @(posedge clk) begin
    mac_en_1 <= mac_en_0;

    if (reset) begin
        mac_en_0 <= 1'b1;
        audio_index <= start_addr;
        kernel_index <= 7'd0;
    end else if (!mac_en_0) begin
        if (audio_index == last_addr)
            audio_index <= 7'd0;
        else
            audio_index <= audio_index + 1'b1;
        if (kernel_index == last_addr)
            mac_en_0 <= 1'b0;
        else
            kernel_index <= kernel_index + 1'b1;
    end
end

assign done = !mac_en_1;
assign result = mac_result[31:16];

endmodule
