`timescale 1ns / 1ps
 
// 20ms!   
module Counter(
    input clk,
    input button_in,
    output button_out
);

reg [18:0] cnt;                
wire key_clk;
reg out;
reg [1:0] record = 2'b00;

always @ (posedge clk) begin
    record <= {record[0], button_in};
end

assign key_clk = record[0] ^ record[1];

always @(posedge clk) begin
    if(key_clk == 1) begin
        cnt <= 0;
    end
    else begin
        cnt <= cnt + 1'b1;
    end
end

always @(posedge clk) begin
    if(cnt == 1_00) begin
        out <= record[0];
    end
end

assign button_out = out;
endmodule
