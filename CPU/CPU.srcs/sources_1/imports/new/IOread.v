`timescale 1ns / 1ps

//补 button
module IOread(
    input reset,
//    input io_read_ctrl,
//    input switchctrl,
//    input btctrl,
    input[23:0] io_read_switch,
    input[4:0] io_read_bt,
    // back to memorio.
    output reg[23:0] io_read_data,
    output reg[4:0] io_bt_data
);
    always @* begin
        if(reset == 1'b1) begin
            io_bt_data = 5'b00000;
            io_read_data = 24'hFFFF_FF;
        end    
        else begin
            io_bt_data = io_read_bt;
            io_read_data = io_read_switch;
        end    
//        else if(io_read_ctrl == 1'b1) begin
//            if(switchctrl == 1'b1)
//                io_read_data = io_read_switch;
//            else 
//               io_read_data = 24'hFFFF_FF;    
//        end    
    end
endmodule
