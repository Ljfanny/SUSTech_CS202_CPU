`timescale 1ns / 1ps



module test1_sim(

    );

reg clk = 0;
reg rst = 1;
reg  [23:0] sw = 24'b0;
wire [23:0] led;
reg [4:0] bt = 5'b0;
wire [7:0] seg_out;
wire [7:0] seg_en;

reg rx;
wire tx;

Top test(rst, clk, sw, led, bt, 
seg_out, seg_en, rx, tx);

initial begin
#60000
rst = 0;
sw = 24'b0000_0000_0000_0000_0000_1001;

#15000
bt[3] = 0;

#5000
bt[3] = 1;

#5000
bt[3] = 0;

#5000
bt[3] = 1;

#5000
bt[3] = 0;

#50000
bt[3] = 1;

#500
bt[3] = 0;

#50000
$finish();

end
always #50 clk = ~clk;



endmodule
