/*
    按键消抖电路
*/
module key_debounce(
	input	wire	clk,
	input	wire	rst_n,
	input	wire	key,
	output	wire	debounced_key
);

parameter 	CNT_END = 249999;// 延时5ms
 
reg	[17:0]	cnt;
reg		cnt_flag;
reg		key_flag;
 
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		// reset
		cnt <= 1'b0;
	end
	else if (key == 1'b0) begin
		cnt <= cnt + 1;
	end
	else begin
		cnt <= 1'b0;
	end
end
 
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		// reset
		cnt_flag <= 1'b0;
	end
	else if(key == 1'b1)begin
		cnt_flag <= 1'b0;
	end
	else if (cnt == CNT_END) begin
		cnt_flag <= 1'b1;
	end
end
 
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		// reset
		key_flag <= 1'b0;
	end
	else if (cnt_flag == 1'b0 && cnt == CNT_END) begin // 避免稳定后重复计数
		key_flag <= 1'b1;
	end
	else begin
		key_flag <= 1'b0;
	end
end

assign debounced_key = key_flag;
endmodule