////////////////////////////////////////////////////////////////////////////////
// Company: nudt
// Engineer: huang junzhe
//
// Create Date: 2022/11/07                        
// Design Name: numeric_code_detonator
// Module Name: numeric_code_detonator_tb
// Target Device: PYNQ-Z2
// Tool versions: vivado 18.2
// Description:
// testbench of numeric_code_detonator
//
// Dependencies: 
//
// Revision:
// 1.0
////////////////////////////////////////////////////////////////////////////////
`timescale 1us/1ns

module numeric_code_detonator_tb ();

reg clk, rst;
reg wait_t, setup, ready, fire, sure;
reg [9:0] A;
wire [3:0] m_disp;
wire lt, bt, rt, lb;

initial begin            
  $dumpfile("wave.vcd");        //生成的vcd文件名称
  $dumpvars(0, numeric_code_detonator_tb);    //tb模块名称
end

initial begin
	clk <= 1'b0;
	forever #20 clk = ~clk;
end

initial begin
  clk <= 1'b1;
  rst <= 1'b1;
  ready <= 1'b0;
  wait_t <= 1'b0;
  sure <= 1'b0;
  setup <= 1'b0;
  fire <= 1'b0;
  A <= 10'd0;
  #40
  rst_n <= 1'b0;
end

/*
initial begin
	#40
	ready <= 1'b1;
	#40
	ready <= 1'b0;
	#40
	A <= 10'b00000_00100; // 2
	#40
	A <= 10'b00001_00000; // 5
	#40
	A <= 10'b01000_00000; // 8
	#40
	A <= 10'b00000_00001; // 0
	#40
	A <= 10'b00000_00000; // 松开按键
	#40
	sure <= 1'b1;
	#40
	sure <= 1'b0;
	#40
	fire <= 1'b1;
	#40
	fire <= 1'b0;
	#120
	$finish;
end
*/

initial begin
  #40
  ready <= 1'b1;
  #40
  ready <= 1'b0;
  #40
	A <= 10'b00000_00100; // 2
	#40
	A <= 10'b00001_00000; // 5
	#40
	A <= 10'b01000_00000; // 8
	#40
	A <= 10'b00000_00010; // 1
	#40
	A <= 10'b00000_00000; // 松开按键
	#40
	sure <= 1'b1;
	#40
	sure <= 1'b0;
	#40
	fire <= 1'b1;
	#520
	$finish;
end

numeric_code_detonator tb(
	.clk(clk),
	.rst(rst),
	.A(A),
	.fire(fire),
	.m_disp(m_disp),
	.setup(setup),
	.sure(sure),
	.wait_t(wait_t),
	.ready(ready),
	.lt(lt),
	.bt(bt),
	.rt(rt),
	.lb(lb)
);
endmodule