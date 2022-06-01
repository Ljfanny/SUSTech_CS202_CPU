`timescale 1ns / 1ps

// [0] -> right, [1] -> left, [2] -> up, [3] -> middle, [4] -> down 
module Buttons(
        input clk, rst,
        input[4:0] but,
        output[4:0] but_out
);
        ButtonMistaken button_right(clk, but[0], but_out[0]);
        ButtonMistaken button_left(clk, but[1], but_out[1]);
        ButtonMistaken button_up(clk, but[2], but_out[2]);
        ButtonMistaken button_mid(clk, but[3], but_out[3]);
        ButtonMistaken button_down(clk, but[4], but_out[4]);
endmodule
