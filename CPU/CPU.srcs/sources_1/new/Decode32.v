`timescale 1ns / 1ps

module Decode32(
    output [31:0] read_data_1,
    output [31:0] read_data_2, 
    input [31:0] Instruction,
    input [31:0] read_data, //from mem or io
    input [31:0] ALU_result,
    input Jal,
    input RegWrite,
    input MemtoReg, // MemOrIOtoReg
    input RegDst,
    output [31:0] Sign_extend,
    input clock,
    input reset,
    input [31:0] opcplus4
    );
    //all the register.
    reg [31:0] Regs[0:31];
    reg [4:0] WriteReg;
    reg [31:0] WriteRegData;
    //rs and rt
    wire[4:0] ReadReg_1;
    wire[4:0] ReadReg_2;
    wire[4:0] R_WriteReg;
    wire[4:0] I_WriteReg;
    wire[5:0] Opcode;
    
    assign ReadReg_1 = Instruction[25:21];
    assign ReadReg_2 = Instruction[20:16];
    assign R_WriteReg = Instruction[15:11];
    assign I_WriteReg = Instruction[20:16];
    assign Opcode = Instruction[31:26];
    
    //except addiu and sltiu.
    assign Sign_extend = (Opcode == 6'b001011 || Opcode == 6'b001100 || Opcode == 6'b001101 || Opcode == 6'b001110)? {16'h0000, Instruction[15:0]}:
    {{16{Instruction[15]}}, Instruction[15:0]};
    assign read_data_1 = Regs[ReadReg_1];
    assign read_data_2 = Regs[ReadReg_2];
    
    //what's targer registers?
    always @* begin
        if (RegWrite == 1'b1) begin 
            if (Opcode == 6'b000000 && RegDst == 1'b1) begin
                WriteReg = R_WriteReg;
            end
            else if (Opcode == 6'b000011 && Jal == 1'b1) begin
                WriteReg = 5'b11111;
            end
            else begin
                WriteReg = I_WriteReg;
            end
        end
    end
    
    //write into registers.
    integer i = 0;
    always @(posedge clock) begin
        if(reset == 1'b1) begin
            for(i = 0; i < 32; i = i + 1)
                Regs[i] <= 32'h0000_0000;
        end
        else begin
            if (RegWrite == 1'b1 && WriteReg != 1'b0) begin
                    Regs[WriteReg] <= WriteRegData;
            end
        end
    end
    
    //write what?
    always @* begin
        if (MemtoReg == 1'b1) WriteRegData <= read_data;
        else if (Opcode == 6'b000011 && Jal == 1'b1) WriteRegData <= opcplus4;
        else WriteRegData <= ALU_result;
    end
    
endmodule