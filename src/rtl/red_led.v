////////////////////////////////////////////////////////////////////////////////
// Company: nudt
// Engineer: huang junzhe
//
// Create Date: 2023/01/01                        
// Design Name: numeric_code_detonator
// Module Name: red_led
// Target Device: PYNQ-Z2
// Tool versions: vivado 18.2
// Description:
// fpga red led module
//
// Dependencies: 
//
// Revision:
// 1.0
////////////////////////////////////////////////////////////////////////////////

module red_led #(
  parameter RT_CNT_MAX = 62_500_000 // 125MHZ 0.5s
)(
  input   clk,
  input   rst,

  input   en,
  output  rt
);

reg rt_tmp;
reg[31:0] cnt;

assign rt = en ? rt_tmp : 1'b0;

// count 0.5s
always @(posedge clk) begin
  if (rst)
    cnt <= 0;
  else if (en)
    cnt <= (cnt == RT_CNT_MAX - 1) ? 0 : cnt + 1;
  else
    cnt <= 0;
end

always @(posedge clk) begin
  if (rst)
    rt_tmp <= 1'b0;
  else if (cnt == RT_CNT_MAX - 1)
    rt_tmp <= ~rt_tmp;
  else
    rt_tmp <= rt_tmp;
end
endmodule