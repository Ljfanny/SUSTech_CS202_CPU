`timescale 1ns / 1ps

module dmemory32(
    //memWrite comes from controller, 1'b1 -> write data-memory.
    input clock,
    input memWrite,
    input [31:0] address,
    input [31:0] writeData,
    output [31:0] readData
    );
    //Create a instance of RAM(IP core), binding the ports
    wire clk;
    assign clk = ~clock;
    RAM ram (
        .clka(clk),
        .wea(memWrite),
        .addra(address[15:2]),
        .dina(writeData),
        .douta(readData)
    );
    
endmodule
