module audio_codec (
    input  clk,
    input  reset,
    output [1:0]  sample_end,
    input  [15:0] audio_output,
    output [15:0] audio_input,
    // 1 - left, 0 - right
    input  [1:0] channel_sel,

    output AUD_ADCLRCK,
    input AUD_ADCDAT,
    output AUD_DACLRCK,
    output AUD_DACDAT,
    output AUD_BCLK
);

wire lrck;
wire bclk;

reg [7:0] lrck_divider;
reg [2:0] bclk_divider;

assign lrck = !lrck_divider[7];

reg [15:0] shift_out;
reg [15:0] shift_temp;
reg [15:0] shift_in;

assign AUD_ADCLRCK = lrck;
assign AUD_DACLRCK = lrck;
assign AUD_BCLK = bclk_divider[2];
assign AUD_DACDAT = shift_out[15];

always @(posedge clk) begin
    if (reset) begin
        lrck_divider <= 8'hff;
        bclk_divider <= 3'b111;
    end else begin
        lrck_divider <= lrck_divider + 1'b1;
        bclk_divider <= bclk_divider + 1'b1;
    end
end

assign sample_end[1] = (lrck_divider == 8'h7e) ? 1'b1 : 1'b0;
assign sample_end[0] = (lrck_divider == 8'hfe) ? 1'b1 : 1'b0;
assign audio_input = shift_in;

wire clr_lrck = (lrck_divider == 8'h7f) ? 1'b1 : 1'b0;
wire set_lrck = (lrck_divider == 8'hff) ? 1'b1 : 1'b0;
wire set_bclk = (bclk_divider == 3'b100) ? 1'b1 : 1'b0;
wire clr_bclk = (bclk_divider == 3'b111) ? 1'b1 : 1'b0;

always @(posedge clk) begin
    if (reset) begin
        shift_out <= 16'h0;
        shift_in <= 16'h0;
        shift_in <= 16'h0;
    end else if (set_lrck || clr_lrck) begin
        // check if current channel is selected
        if (channel_sel[set_lrck]) begin
            shift_out <= audio_output;
            shift_temp <= audio_output;
            shift_in <= 16'h0;
        end else shift_out <= shift_temp;
    end else if (set_bclk == 1) begin
        // only read in if channel is selected
        if (channel_sel[lrck])
            shift_in <= {shift_in[14:0], AUD_ADCDAT};
    end else if (clr_bclk == 1) begin
        shift_out <= {shift_out[14:0], 1'b0};
    end
end

endmodule
