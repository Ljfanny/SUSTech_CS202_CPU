`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/30 02:03:21
// Design Name: 
// Module Name: Leds
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


module Leds(
    input clk,
    input rst,
    input ioWrite,
    input[31:0] write_data,
    output reg[16:0] led
);

    //pos or neg?
    always @(posedge clk or posedge rst) begin
        if(rst)
            led <= 17'b0;
        else if (ioWrite)
            led <= write_data[16:0];
        else
            led <= led;
    end
endmodule
