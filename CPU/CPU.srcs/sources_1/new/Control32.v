`timescale 1ns / 1ps

module Control32(
    input [5:0] Opcode,
    input [5:0] Function_opcode,
    output Jr,
    output RegDST,
    output ALUSrc,
  //  output MemtoReg,
    output RegWrite,
    output MemWrite,
    output Branch,
    output nBranch,
    output Jmp,
    output Jal,
    output I_format,
    output Sftmd,
    output [1:0] ALUOp,
    input[31:0] Alu_result,
    output MemorIOtoReg,
    output MemRead,
    output IORead,
    output IOWrite    
    );
    wire R_format, Lw, Sw;
    assign R_format = (Opcode == 6'b000000)? 1'b1:1'b0;
    assign Lw = (Opcode==6'b100011)? 1'b1:1'b0;
    assign Sw = (Opcode==6'b101011)? 1'b1:1'b0;
    assign Jr = ((Opcode==6'b000000) && (Function_opcode==6'b001000)) ? 1'b1 : 1'b0; 
    assign RegDST = R_format && (~I_format && ~Lw);
    assign ALUSrc = (I_format || Lw || Sw);
  //  assign MemtoReg = Lw;
    assign RegWrite = (R_format || Lw || Jal || I_format) && (~Jr);
    assign MemWrite = ((Sw == 1'b1) || (Alu_result[31:10] != 22'h3FFFFF)) ? 1'b1 : 1'b0;
    assign Branch = (Opcode==6'b000100)? 1'b1:1'b0;
    assign nBranch = (Opcode==6'b000101)? 1'b1:1'b0;
    assign Jal = (Opcode==6'b000011)? 1'b1:1'b0;
    assign Jmp=  (Opcode==6'b000010)? 1'b1:1'b0;
    assign I_format = (Opcode[5:3]==3'b001)?1'b1:1'b0;
    assign Sftmd = (((Function_opcode==6'b000000) || (Function_opcode==6'b000010)
                            || (Function_opcode==6'b000011) || (Function_opcode==6'b000100)
                            || (Function_opcode==6'b000110) || (Function_opcode==6'b000111))
                            && R_format)? 1'b1:1'b0;
     assign ALUOp = {(R_format || I_format),(Branch || nBranch)};

     //C = 1100
     assign MemRead = (Lw  == 1'b1 && (Alu_result[31:10] != 22'h3FFFFF)) ? 1'b1 : 1'b0;
     assign IORead = (Lw  == 1'b1 && (Alu_result[31:4] == 28'hFFFFFC7)) ? 1'b1 : 1'b0;
     assign IOWrite = (Sw  == 1'b1 && (Alu_result[31:4] == 28'hFFFFFC6)) ? 1'b1 : 1'b0;
     // Read operations require reading data from memory or I/O to write to the register
     assign MemorIOtoReg = IORead || MemRead;
endmodule
