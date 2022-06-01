`timescale 1ns / 1ps

module dmemory32(
    //memWrite comes from controller, 1'b1 -> write data-memory.
    input clock, //from top
    input memWrite, //from controller
    input [31:0] address, //from alu
    input [31:0] writeData, //from memOrIO
    output [31:0] readData,

    // UART Programmer Pinouts
    input upg_rst_i, // UPG reset (Active High)
    input upg_clk_i, // UPG ram_clk_i (10MHz)
    input upg_wen_i, // UPG write enable
    input [13:0] upg_adr_i, // UPG write address  upg_adr_o[14:1], ifetch [13:0]
    input [31:0] upg_dat_i, // UPG write data
    input upg_done_i // 1 if programming is finished
    );

    // 时钟信号的频率取决于上游模块

    //Create a instance of RAM(IP core), binding the ports
    wire clk;
    assign clk = ~clock;

    /*  1 - normal
        0 - uart.  */
    wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i); 

    RAM ram (
    .clka (kickOff ? clk : upg_clk_i),
    .wea (kickOff ? memWrite : upg_wen_i),
    .addra (kickOff ? address[15:2] : upg_adr_i),
    .dina (kickOff ? writeData : upg_dat_i),
    .douta (readData)
    );
    
endmodule
