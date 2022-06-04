`timescale 1ns / 1ps

module dmemory32(
    //memWrite comes from controller, 1'b1 -> write data-memory.
    input clock,
    input memWrite,
    input [31:0] address,
    input [31:0] writeData,
    output [31:0] readData,

    // UART Programmer Pinouts
    input upg_rst_i, // UPG reset (Active High)
    input upg_clk_i, // UPG ram_clk_i (10MHz)
    input upg_wen_i, // UPG write enable
    input [13:0] upg_adr_i, // UPG write address  upg_adr_o[14:1], ifetch [13:0]
    input [31:0] upg_dat_i, // UPG write data
    input upg_done_i // 1 if programming is finished
    );

    //Create a instance of RAM(IP core), binding the ports
    wire clk;
    assign clk = ~clock;
    
    /*  1 - normal
        0 - uart.  */
    wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i); 
    // wire kickOff = 1;

    RAM ram (
    .clka (kickOff ? clk : upg_clk_i),
    .wea (kickOff ? memWrite : upg_wen_i),
    .addra (kickOff ? address[15:2] : upg_adr_i),
    .dina (kickOff ? writeData : upg_dat_i),
    .douta (readData)
    );
    
    
    // RAM ram (
    //     .clka(clk),
    //     .wea(memWrite),
    //     .addra(address[15:2]),
    //     .dina(writeData),
    //     .douta(readData)
    // );
    
endmodule
