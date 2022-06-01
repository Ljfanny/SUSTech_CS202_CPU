`timescale 1ns / 1ps

module Top(
    input fpga_rst,
    input fpga_clk,
    input[23:0] sw, //[23:21], [16:0]
    output[23:0] led,
    input[4:0] bt,
    output reg[7:0] seg_out,
    output reg[7:0] seg_en,
    //uart programmer pinouts
    input rx, //receive data by uart
    output tx //send data by uart
    );
//    wire clk_23;
//    assign clk_23 = clk;
    wire clk_23, clk_10;
    cpu_clk clock(
        .clk_in1(fpga_clk),
        .clk_out1(clk_23),
        .clk_out2(clk_10)
    );

    //Buttons io_button(clk_23, rst, bt, bt_out);
    wire[4:0] bt_out;
   // assign bt_out = bt;

    //-------------------------------------- UART ------------------------------------------

    //start uart communicate at high level
    wire start_pg; //active high
    assign start_pg = bt_out[0]; //right

    // UART Programmer Pinouts
    wire upg_clk_o;
    wire upg_wen_o; //Uart write out enable
    wire upg_done_o; //Uart rx data have done
    
    //data to which memory unit of program_rom/dmemory32
    wire [14:0] upg_adr_o;
    //data to program_rom or dmemory32
    wire [31:0] upg_dat_o;

    wire spg_bufg;
    BUFG U5(.I(start_pg), .O(spg_bufg)); // de-twitter
    // Generate UART Programmer reset signal
    reg upg_rst;
    always @ (posedge fpga_clk) begin
    if (spg_bufg) upg_rst = 0;
    if (fpga_rst) upg_rst = 1;
    end
    //used for other modules which don't relate to UART
    wire rst;
    assign rst = fpga_rst | !upg_rst;

    //fpga_rst : total reset, reset both program and uart, turn into uart
    //spg_bufg: turn from uart to program, only reset program

    uart_bmpg_0 uart(
        .upg_clk_i(clk_10),
        .upg_rst_i(upg_rst),
        .upg_rx_i(rx),
        .upg_clk_o(upg_clk_o),
        .upg_wen_o(upg_wen_o),
        .upg_adr_o(upg_adr_o),
        .upg_dat_o(upg_dat_o),
        .upg_done_o(upg_done_o),
        .upg_tx_o(tx)
    );

    // write into memory_data
    wire upg_wen_i_ifetch, upg_wen_i_memory;
    assign upg_wen_i_memory = upg_wen_o & upg_adr_o[14];
    assign upg_wen_i_ifetch = upg_wen_o & !upg_adr_o[14];

    //---------------------------------------------------------------------------- 

    //ifetch
    wire branch, nbranch, jmp, jal, jr, zero;
    wire[31:0] reg_read_data1, reg_read_data2;
    wire[31:0] addr_result;
    wire[31:0] instruction, instruction_i, branch_base_addr, link_addr;
    wire[13:0] rom_adr_o;
    Ifetc32 ifetch(
        instruction_i, instruction, branch_base_addr,
        addr_result, reg_read_data1,
        branch, nbranch, jmp, jal, jr, zero,
        clk_23, rst,
        link_addr, rom_adr_o
    );

    programrom prr(
        clk_23, 
        rom_adr_o, instruction_i,
        upg_rst, upg_clk_o, upg_wen_i_ifetch, upg_adr_o[13:0],
        upg_dat_o, upg_done_o
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
    wire[31:0] mem_data; //output, read from memory
    dmemory32 data_memory(
        clk_23, memWrite, alu_result, write_data, mem_data,
        upg_rst, upg_clk_o, upg_wen_i_memory, upg_adr_o[14:1], upg_dat_o, upg_done_o
    );

    //wire ledCtrl, swCtrl;
    // reg swCtrl;
    //switch

    //ioread(convert sw into r_rdata)
//    wire[23:0] io_read_data;
//    wire[4:0] io_bt_data;

  //  wire[4:0] bt_out;
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

    // wire bt_bufg;
    // BUFG U2(.I(bt[3]), .O(bt_bufg)); // de-twitter

    MemOrIO memorio(
        memRead, memWrite, ioRead, ioWrite, ioBt, ioSeg, alu_result,
        mem_data, {bt_out, sw}, reg_read_data2,
        read_data, write_data
    );

    //io - led
    wire[7:0] dis_seg_out, dis_seg_en;
    Leds io_led(clk_23, rst, ioWrite, write_data, led);
    Display display(clk, rst, ioSeg, write_data, dis_seg_out, dis_seg_en);
   // Buttons io_button(clk_23, rst, bt, bt_out);
   
    always @(posedge clk) begin
         seg_out = dis_seg_out;
         seg_en = dis_seg_en;
    end
   
endmodule
