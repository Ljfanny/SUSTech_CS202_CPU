`timescale 1ns / 1ps

module MemOrIO(
    input mRead,
    input mWrite,
    input ioRead,
    input ioWrite,
    input [31:0] addr_in,
    output [31:0] addr_out,
    input [31:0] m_rdata,
    input [23:0] io_rdata,
    output [31:0] r_wdata,
    input [31:0] r_rdata,
    output reg [31:0] write_data,
    output LEDCtrl,
    output SwitchCtrl
    );
    
    assign addr_out= addr_in;
    // The data wirte to register file may be from memory or io. 
    // While the data is from io, it should be the lower 16bit of r_wdata. 
    assign r_wdata = (ioRead == 1'b1) ? {8'h00, io_rdata} : m_rdata;
    // Chip select signal of Led and Switch are all active high;
    assign LEDCtrl= (ioWrite == 1'b1) ? 1'b1 : 1'b0;
    assign SwitchCtrl= (ioRead == 1'b1) ? 1'b1 : 1'b0; 
    always @* begin
        if((mWrite==1)||(ioWrite==1))
        //wirte_data could go to either memory or IO. where is it from?
        //have something wrong.
            write_data = (mWrite == 1'b1) ? r_rdata : {{15{1'b1}}, r_rdata[16:0]};
        else
            write_data = 32'hZZZZZZZZ;
        end
    
endmodule
