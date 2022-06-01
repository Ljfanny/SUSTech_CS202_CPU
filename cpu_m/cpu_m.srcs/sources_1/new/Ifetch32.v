`timescale 1ns / 1ps

// Maybe add PC and next_PC, to send out.
module Ifetc32(
    input[31:0] instruction_i,
    output [31:0] Instruction_o,
    output [31:0] branch_base_addr,
    //from ALU.
    input [31:0] Addr_result,
    // Jr's address.
    input [31:0] Read_data_1,
    input Branch,
    input nBranch,
    input Jmp,
    input Jal,
    input Jr,
    input Zero,
    input clock,
    input reset,
    output reg [31:0] link_addr,
    output[13:0] rom_adr_o

    );
    
    reg[31:0] PC;
    reg[31:0] next_PC;
    
    assign branch_base_addr = PC + 4;

    assign rom_adr_o = PC[15:2];
    assign Instruction_o = instruction_i;
   
    // prgrom instmem(
    //     .clka(clock),
    //     .addra(PC[15:2]),
    //     .douta(Instruction)
    // );
    
    always@* begin
        if (Jr == 1'b1) begin
            next_PC = Read_data_1;
        end
        else if ((Branch == 1'b1 && Zero == 1'b1) || (nBranch == 1'b1 && Zero == 1'b0)) begin
            next_PC = Addr_result;
        end
        else begin
            next_PC = PC + 4;
        end
    end
    
    always@(negedge clock) begin
        if (reset == 1'b1) begin
            PC <= 32'h0000_0000;
        end
        else if (Jmp == 1'b1 || Jal == 1'b1) begin
            link_addr <= next_PC;
            PC <= {PC[31:28], Instruction_o[25:0], 2'b00};
        end
        else begin
            PC <= next_PC;
        end
    end
endmodule
