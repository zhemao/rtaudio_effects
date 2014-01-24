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

reg acc_en_0 = 1'b0;
reg acc_en_1 = 1'b0;
reg acc_en_2 = 1'b0;
reg [31:0] accum_value;

reg [6:0] audio_index;
reg [6:0] kernel_index;

assign audio_addr = audio_index;
assign kernel_addr = kernel_index;

wire [31:0] mult_result;
reg  [31:0] mult_reg;

mult16 mult (
    .dataa (audio_data),
    .datab (kernel_data),
    .result (mult_result)
);

always @(posedge clk) begin
    acc_en_2 <= acc_en_1;
    acc_en_1 <= acc_en_0;
    mult_reg <= mult_result;

    if (reset) begin
        acc_en_0 <= 1'b1;
        audio_index <= start_addr;
        kernel_index <= 7'd0;
        accum_value <= 32'd0;
    end else begin
        if (acc_en_0) begin
            if (audio_index == last_addr)
                audio_index <= 7'd0;
            else
                audio_index <= audio_index + 1'b1;
            if (kernel_index == last_addr)
                acc_en_0 <= 1'b0;
            else
                kernel_index <= kernel_index + 1'b1;
        end
        if (acc_en_2) begin
            accum_value <= accum_value + mult_reg;
        end
    end
end

assign done = !(acc_en_2 || acc_en_0);
assign result = accum_value[31:16];

endmodule
