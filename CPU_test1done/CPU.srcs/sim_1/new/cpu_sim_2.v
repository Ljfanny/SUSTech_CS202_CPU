`timescale 1ns / 1ps

module cpu_sim_2();
reg clk = 0;
reg rst = 1;
reg  [23:0] sw = 24'b0;
wire [23:0] led;
reg [4:0] bt = 5'b0;
wire [7:0] seg_out;
wire [7:0] seg_en;

Top test(rst, clk, sw, led, bt, 
seg_out, seg_en);

initial begin
#6000
rst = 0;
sw = 24'b0000_0100_0000_0000_0110_0101;

#5000
bt[3] = 0;

#5000
bt[3] = 1;

#5000
bt[3] = 0;

#5000
bt[3] = 1;

#5000
bt[3] = 0;
sw = 24'b0000_0000_0000_0000_0000_0011;

#5000
bt[3] = 1;

#5000
bt[3] = 0;
sw = 24'b0000_1000_0000_0000_0000_0011;

#5000
bt[3] = 1;

#5000
bt[3] = 0;

#5000
bt[3] = 1;

#5000
bt[3] = 0;

#50000
$finish();

end
always #10 clk = ~clk;

endmodule
