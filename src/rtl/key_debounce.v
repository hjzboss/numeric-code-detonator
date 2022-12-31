////////////////////////////////////////////////////////////////////////////////
// Company: nudt
// Engineer: huang junzhe
//
// Create Date: 2022/11/07                        
// Design Name: numeric_code_detonator
// Module Name: key_debounce
// Target Device: PYNQ-Z2
// Tool versions: vivado 18.2
// Description:
// FPGA key debounce module
//
// Dependencies: 
//
// Revision:
// 1.0
////////////////////////////////////////////////////////////////////////////////

module key_debounce (
	input clk,
	input rst,
	input key,
	output debounced_key // 稳定信号
);

parameter CNT_END = 625_000;// 延时5ms
 
reg	[32:0] cnt;
reg	cnt_flag;
reg key_flag;
 
always @(posedge clk) begin
	if (rst)
		cnt <= 1'b0;
	else if (key == 1'b0)
		cnt <= cnt + 16'd1;
	else
		cnt <= 16'd0;
end
 
always @(posedge clk) begin
	if (rst)
		cnt_flag <= 1'b0;
	else if(key == 1'b1)
		cnt_flag <= 1'b0;
	else if (cnt == CNT_END)
		cnt_flag <= 1'b1;
end
 
always @(posedge clk) begin
	if (rst)
		key_flag <= 1'b0;
	else if (cnt_flag == 1'b0 && cnt == CNT_END) // 避免稳定后重复计数
		key_flag <= 1'b1;
	else
		key_flag <= 1'b0;
end

assign debounced_key = key_flag;
endmodule
