`timescale 1ns / 1ps

module Display(
    input clk, rst,
    input ioSeg,
    input[31:0] write_data,
    output [7:0] seg_out,
    output [7:0] seg_en
);

    parameter null = 8'hFF;
//    wire ms_clk, ms100_clk, ms100_edge;
    reg[7:0] i0, i1, i2, i3, i4, i5, i6, i7;

//    DivideClk #(100_000) ms_clk_inst(clk, rst, ms_clk);
//    DivideClk #(70) ms100_clk_inst(ms_clk, rst, ms100_clk);
//    GenBound ms100_edge_inst(clk, ms100_clk, ms100_edge);
    
    SegAllocation seg_allo(clk ,rst , i0, i1, i2, i3, i4, i5, i6, i7, seg_out, seg_en);
    
    reg [4:0] seg0_num;
    wire [7:0] seg0_out;
    SegShow seg0(seg0_num,seg0_out);

    reg [4:0] seg1_num;
    wire [7:0] seg1_out;
    SegShow seg1(seg1_num,seg1_out);

    reg [4:0] seg2_num;
    wire [7:0] seg2_out;
    SegShow seg2(seg2_num,seg2_out);

    reg [4:0] seg3_num;
    wire [7:0] seg3_out;
    SegShow seg3(seg3_num,seg3_out);

    reg [4:0] seg4_num;
    wire [7:0] seg4_out;
    SegShow seg4(seg4_num,seg4_out);
    
    reg[31:0] num = 32'h0000_0000;
         
    always @* begin
        if (rst)
            {i0,i1,i2,i3,i4,i5,i6,i7} = {8{null}}; 
        else if (ioSeg) begin
             num = {16'h0000, write_data[15:0]};
             seg0_num <= num % 10;
             seg1_num <= (num % 100) / 10;
             seg2_num <= (num % 1000) / 100;
             seg3_num <= (num % 10000) / 1000;   
             seg4_num <= num / 10000;
             {i3, i4, i5, i6, i7} = {seg4_out,seg3_out,seg2_out,seg1_out,seg0_out};
             {i0,i1,i2} = {3{null}};
        end
        else
             {i0,i1,i2,i3,i4,i5,i6,i7} = {i0,i1,i2,i3,i4,i5,i6,i7};    
    end

endmodule