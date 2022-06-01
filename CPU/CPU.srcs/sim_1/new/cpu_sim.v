`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/01 23:54:12
// Design Name: 
// Module Name: cpu_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cpu_sim();

reg clk = 0;
reg rst = 1;
reg  [23:0] sw = 24'b0;
wire [23:0] led;
reg [4:0] bt = 5'b0;
wire [7:0] seg_out;
wire [7:0] seg_en;

reg rx;
wire tx;

Top test(rst, clk, sw, led, bt, 
seg_out, seg_en, rx, tx);

initial begin
#6000
rst = 0;
sw = 24'b00000000_0000_0000_0000_0001;

#20
bt[3] = 1;

#20
bt[3] = 0;

end
always #10 clk = ~clk;

endmodule
