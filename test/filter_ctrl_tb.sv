module filter_ctrl_tb ();

reg audio_clk = 1'b1;
reg main_clk = 1'b1;
reg reset = 1'b0;

reg sample_end = 1'b0;
reg sample_req = 1'b0;

reg [15:0] audio_input;
wire [15:0] audio_output;

always #10000 main_clk = !main_clk;
always #44289 audio_clk = !audio_clk;

reg [7:0] i;
reg [6:0]  romaddr;
reg [15:0] romdata [0:99];

wire filter_finish;

filter_ctrl fc (
    .audio_clk (audio_clk),
    .main_clk (main_clk),
    .reset (reset),

    .sample_end (sample_end),
    .sample_req (sample_req),

    .audio_input (audio_input),
    .audio_output (audio_output),
    .finish (filter_finish)
);

initial begin
    romdata[0] = 16'h0000;
    romdata[1] = 16'h0805;
    romdata[2] = 16'h1002;
    romdata[3] = 16'h17ee;
    romdata[4] = 16'h1fc3;
    romdata[5] = 16'h2777;
    romdata[6] = 16'h2f04;
    romdata[7] = 16'h3662;
    romdata[8] = 16'h3d89;
    romdata[9] = 16'h4472;
    romdata[10] = 16'h4b16;
    romdata[11] = 16'h516f;
    romdata[12] = 16'h5776;
    romdata[13] = 16'h5d25;
    romdata[14] = 16'h6276;
    romdata[15] = 16'h6764;
    romdata[16] = 16'h6bea;
    romdata[17] = 16'h7004;
    romdata[18] = 16'h73ad;
    romdata[19] = 16'h76e1;
    romdata[20] = 16'h799e;
    romdata[21] = 16'h7be1;
    romdata[22] = 16'h7da7;
    romdata[23] = 16'h7eef;
    romdata[24] = 16'h7fb7;
    romdata[25] = 16'h7fff;
    romdata[26] = 16'h7fc6;
    romdata[27] = 16'h7f0c;
    romdata[28] = 16'h7dd3;
    romdata[29] = 16'h7c1b;
    romdata[30] = 16'h79e6;
    romdata[31] = 16'h7737;
    romdata[32] = 16'h7410;
    romdata[33] = 16'h7074;
    romdata[34] = 16'h6c67;
    romdata[35] = 16'h67ed;
    romdata[36] = 16'h630a;
    romdata[37] = 16'h5dc4;
    romdata[38] = 16'h5820;
    romdata[39] = 16'h5222;
    romdata[40] = 16'h4bd3;
    romdata[41] = 16'h4537;
    romdata[42] = 16'h3e55;
    romdata[43] = 16'h3735;
    romdata[44] = 16'h2fdd;
    romdata[45] = 16'h2855;
    romdata[46] = 16'h20a5;
    romdata[47] = 16'h18d3;
    romdata[48] = 16'h10e9;
    romdata[49] = 16'h08ee;
    romdata[50] = 16'h00e9;
    romdata[51] = 16'hf8e4;
    romdata[52] = 16'hf0e6;
    romdata[53] = 16'he8f7;
    romdata[54] = 16'he120;
    romdata[55] = 16'hd967;
    romdata[56] = 16'hd1d5;
    romdata[57] = 16'hca72;
    romdata[58] = 16'hc344;
    romdata[59] = 16'hbc54;
    romdata[60] = 16'hb5a7;
    romdata[61] = 16'haf46;
    romdata[62] = 16'ha935;
    romdata[63] = 16'ha37c;
    romdata[64] = 16'h9e20;
    romdata[65] = 16'h9926;
    romdata[66] = 16'h9494;
    romdata[67] = 16'h906e;
    romdata[68] = 16'h8cb8;
    romdata[69] = 16'h8976;
    romdata[70] = 16'h86ab;
    romdata[71] = 16'h845a;
    romdata[72] = 16'h8286;
    romdata[73] = 16'h8130;
    romdata[74] = 16'h8059;
    romdata[75] = 16'h8003;
    romdata[76] = 16'h802d;
    romdata[77] = 16'h80d8;
    romdata[78] = 16'h8203;
    romdata[79] = 16'h83ad;
    romdata[80] = 16'h85d3;
    romdata[81] = 16'h8875;
    romdata[82] = 16'h8b8f;
    romdata[83] = 16'h8f1d;
    romdata[84] = 16'h931e;
    romdata[85] = 16'h978c;
    romdata[86] = 16'h9c63;
    romdata[87] = 16'ha19e;
    romdata[88] = 16'ha738;
    romdata[89] = 16'had2b;
    romdata[90] = 16'hb372;
    romdata[91] = 16'hba05;
    romdata[92] = 16'hc0df;
    romdata[93] = 16'hc7f9;
    romdata[94] = 16'hcf4b;
    romdata[95] = 16'hd6ce;
    romdata[96] = 16'hde7a;
    romdata[97] = 16'he648;
    romdata[98] = 16'hee30;
    romdata[99] = 16'hf629;


    reset = 1'b1;
    #20000 reset = 1'b0;
    #68578 sample_req = 1'b1;
    #88578 sample_req = 1'b0;
    for (i = 7'd0; i < 200; i = i + 1'b1) begin
        #5668992 sample_end = 1'b1;
        romaddr = i % 100;
        audio_input = romdata[romaddr];
        #88578 sample_end = 1'b0;
        #16829820 sample_req = 1'b1;
        #88578 sample_req = 1'b0;
    end
end

endmodule
