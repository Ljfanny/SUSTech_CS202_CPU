`timescale 1ns / 1ps

module Top(
    input rst,
    input clk,
    input[23:0] sw, //[23:21], [16:0]
    output[23:0] led,
    input[4:0] bt,
    output reg[7:0] seg_out,
    output reg[7:0] seg_en
    //uart programmer pinouts
    //start uart communicate at high level
    //input start_pg, //active high
    //input rx, //receive data by uart
    //output tx //send data by uart
    );
//    wire clk_23;
//    assign clk_23 = clk;
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
    wire regDst, aluSrc,regWrite, memWrite, i_format, sftmd, memoryIOtoReg;
    wire[1:0] aluOp;
    wire[31:0] alu_result; //address
    wire memorIOtoReg, memRead, ioRead, ioWrite, ioBt, ioSeg;
    Control32 controller(
        instruction[31:26], instruction[5:0],
        jr, regDst, aluSrc, regWrite, memWrite,
        branch, nbranch, jmp, jal, i_format, sftmd,
        aluOp, alu_result,
        memorIOtoReg, memRead, ioRead, ioWrite, ioBt, ioSeg
    );

    //decoder
    wire[31:0] read_data; //read from MemOrIO, lw into register
    wire[31:0] sign_extend;
    Decode32 decoder(
        reg_read_data1, reg_read_data2,
        instruction, read_data, alu_result,
        jal, regWrite, memorIOtoReg, regDst,
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
    wire[31:0] write_data; //write into mem, from MemOrIO processing reg_data2
    wire[31:0] mem_data;
    dmemory32 data_memory(
        clk_23, memWrite, alu_result, write_data,
        mem_data
    );

    //wire ledCtrl, swCtrl;
    // reg swCtrl;
    //switch

    //ioread(convert sw into r_rdata)
//    wire[23:0] io_read_data;
//    wire[4:0] io_bt_data;
    wire[4:0] bt_out;
//    assign bt_out = bt;
    BUFG U0(.I(bt[0]), .O(bt_out[0]));
    BUFG U1(.I(bt[1]), .O(bt_out[1]));
    BUFG U2(.I(bt[2]), .O(bt_out[2]));
    BUFG U3(.I(bt[3]), .O(bt_out[3]));
    BUFG U4(.I(bt[4]), .O(bt_out[4]));
     
    
//    reg[4:0] bt_delay;
//    IOread read_sw_module(sw, bt_out, io_read_data, io_bt_data);
//    IOread read_sw_module(rst, ioRead, swCtrl, sw, io_read_data);

    //memoryOrIO, read_data is the one into decoder
    //change reg_read_data2 to 1?
    MemOrIO memorio(
        memRead, memWrite, ioRead, ioWrite, ioBt, ioSeg, alu_result,
        mem_data, {bt_out, sw}, reg_read_data2,
        read_data, write_data
    );

    //io - led
    wire[7:0] dis_seg_out, dis_seg_en;
    Leds io_led(clk_23, rst, ioWrite, write_data, led);
    Display display(clk, rst, ioSeg, write_data, dis_seg_out, dis_seg_en);
//    Buttons io_button(clk, rst, bt, bt_out);
   
    always @(posedge clk) begin
         seg_out = dis_seg_out;
         seg_en = dis_seg_en;
    end
   
endmodule
