`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/28 23:03:32
// Design Name: 
// Module Name: Top
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


module Top(
    input rst,
    input clk,
    input[23:0] sw,
    output[23:0] led
    //uart programmer pinouts
    //start uart communicate at high level
    //input start_pg, //active high
    //input rx, //receive data by uart
    //output tx //send data by uart
    );
    
    wire clk_23, clk_10;
    cpu_clk clock(
        .clk_in1(clk),
        .clk_out1(clk_23),
        .clk_out2(clk_10)
    );

    //ifetch
    wire branch, nbranch, jmp, jal, jr, zero;
    wire[31:0] reg_read_data1, reg_read_data2;
    wire[31:0] addr_result;
    wire[31:0] instruction, branch_base_addr, link_addr;
    Ifetc32 ifetch(
        instruction, branch_base_addr,
        addr_result, reg_read_data1,
        branch, nbranch, jmp, jal, jr, zero,
        clk_23, rst,
        link_addr
    );
    
    //controller
    wire regDst, aluSrc, memToReg, regWrite, memWrite, i_format, sftmd, memoryIOtoReg;
    wire[1:0] aluOp;
    wire[31:0] alu_result;
    wire memorIOtoReg, memRead, ioRead, ioWrite;
    Control32 controller(
        instruction[31:26], instruction[5:0],
        jr, regDst, aluSrc, memToReg, regWrite, memWrite,
        branch, nbranch, jmp, jal, i_format, sftmd,
        aluOp, alu_result[31:10],
        memorIOtoReg, memRead, ioRead, ioWrite
    );

    //decoder
    
    wire[31:0] mem_data;
    wire[31:0] sign_extend;
    Decode32 decoder(
        reg_read_data1, reg_read_data2,
        instruction, mem_data, alu_result,
        jal, regWrite, memToReg, regDst,
        sign_extend, clk_23, rst,
        link_addr
    );
    
    //alu
    Executs32 alu(
        reg_read_data1, reg_read_data2, sign_extend,
        instruction[5:0], instruction[31:26],
        aluOp, instruction[10:6],
        sftmd, aluSrc, i_format, jr, zero,
        alu_result, addr_result, branch_base_addr
    );

    //data memory
    dmemory32 data_memory(
        clk_23, memWrite, addr_result, reg_read_data2,
        mem_data
    );
    
    
    
endmodule
