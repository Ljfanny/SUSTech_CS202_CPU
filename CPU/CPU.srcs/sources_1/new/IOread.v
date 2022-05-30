`timescale 1ns / 1ps

module IOread(
    input reset,
    input io_read_ctrl,
    input switchctrl,
    input[23:0] io_read_switch,
    // back to memorio.
    output reg[23:0] io_read_data
);
    always @* begin
        if(reset == 1'b1)
            io_read_data = 24'h0000_0000;
        else if(io_read_ctrl == 1'b1) begin
            if(switchctrl == 1'b1)
                io_read_data = io_read_switch;
//            else 
//                io_read_data = io_read_data;    
        end    
    end
endmodule
