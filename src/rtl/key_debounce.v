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

module key_debounce #(
  parameter KEY_CNT_MAX = 2_500_000 // 20ms
)(
  input               clk,
  input               rst,
  input               key,
  output              debounced_key
);

reg[31:0] cnt;
reg key_flag;
 
always @(posedge clk) begin
  if (rst)
    cnt <= 1'b0;
  else if (key == 1'b1)
    cnt <= cnt == (KEY_CNT_MAX - 1'b1) ? 32'd0 : cnt + 1;
  else
    cnt <= 16'd0;
end
 
always @(posedge clk) begin
  if (rst)
    key_flag <= 1'b0;
  else if (cnt == KEY_CNT_MAX - 1)
    key_flag <= 1'b1;
  else
    key_flag <= 1'b0;
end

assign debounced_key = key_flag;
endmodule
