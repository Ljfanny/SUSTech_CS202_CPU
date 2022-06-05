`timescale 1ns / 1ps

module ButtonMistaken(
        input clk,
        input but_in,
        output but_out
    );
    
    wire out;
    Counter counter(clk, but_in, out);
    
    reg [1:0] record = 2'b00;
    
    always @(posedge clk)
        record <= {record[0], out};
    assign but_out = record[0] & ~record[1];
endmodule
