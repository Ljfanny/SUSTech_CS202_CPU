`timescale 1ns / 1ps

module SegShow(
    input[4:0] num,
    output reg [7:0] seg_out
);

always @(num) begin
    case(num)
        4'h0: seg_out  = 8'b1100_0000;
        4'h1: seg_out  = 8'b1111_1001;
        4'h2: seg_out  = 8'b1010_0100;
        4'h3: seg_out  = 8'b1011_0000;
        4'h4: seg_out  = 8'b1001_1001;
        4'h5: seg_out  = 8'b1001_0010;
        4'h6: seg_out  = 8'b1000_0010;
        4'h7: seg_out  = 8'b1111_1000;
        4'h8: seg_out  = 8'b1000_0000;
        4'h9: seg_out  = 8'b1001_0000;
        default: seg_out = 8'b1111_1111;
//        4'ha: seg_out  = 8'b1000_1000;
//        4'hb: seg_out  = 8'b1000_0011;
//        4'hc: seg_out  = 8'b1100_0110;
//        4'hd: seg_out  = 8'b1010_0001;
//        4'he: seg_out  = 8'b1000_0110;
//        4'hf: seg_out  = 8'b1000_1110;
    endcase
end
endmodule