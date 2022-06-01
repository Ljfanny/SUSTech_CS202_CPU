`timescale 1ns / 1ps

module Leds(
    input clk,
    input rst,
    input ioWrite,
    input[31:0] write_data,
    output reg[23:0] led
);

    //pos or neg?
    always @(posedge clk or posedge rst) begin
        if(rst)
            led = {24{1'b0}};
        else if (ioWrite)
            led = {{15{1'b0}},write_data[16:0]};
        else
            led = led;
    end
endmodule
