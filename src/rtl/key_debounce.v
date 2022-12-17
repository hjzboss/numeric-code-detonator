////////////////////////////////////////////////////////////////////////////////
// 公司: NUDT
// 工程师: hjz
// 创建日期: 2022/11/07
// 设计名称: 数字密码引爆器
// 模块名: key_debounce
// 目标器件: PYNQ-Z2
// 工具软件版本号: vivado
// 描述:
// 按键消抖电路
// 修订版本:
// rev1.1
// 额外注释:
// 待定
////////////////////////////////////////////////////////////////////////////////

module key_debounce (
	input clk,
	input rst_n,
	input key,
	output debounced_key // 稳定信号
);

parameter 	CNT_END = 50_000;// 延时5ms
 
reg	[15:0] cnt;
reg	cnt_flag;
reg key_flag;
 
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0)
		// reset
		cnt <= 1'b0;
	else if (key == 1'b0)
		cnt <= cnt + 16'd1;
	else
		cnt <= 16'd0;
end
 
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0)
		// reset
		cnt_flag <= 1'b0;
	else if(key == 1'b1)
		cnt_flag <= 1'b0;
	else if (cnt == CNT_END)
		cnt_flag <= 1'b1;
end
 
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0)
		// reset
		key_flag <= 1'b0;
	else if (cnt_flag == 1'b0 && cnt == CNT_END) // 避免稳定后重复计数
		key_flag <= 1'b1;
	else
		key_flag <= 1'b0;
end

assign debounced_key = key_flag;
endmodule
