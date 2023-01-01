////////////////////////////////////////////////////////////////////////////////
// Company: nudt
// Engineer: huang junzhe
//
// Create Date: 2023/01/01                        
// Design Name: numeric_code_detonator
// Module Name: disp_num
// Target Device: PYNQ-Z2
// Tool versions: vivado 18.2
// Description:
// Digital tube control module
//
// Dependencies: 
//
// Revision:
// 1.0
////////////////////////////////////////////////////////////////////////////////

module disp_ctrl (
  input clk,
  input rst,
    
  input en,
  input [15:0] data,
  output [3:0] sel,
  output reg [6:0] m_disp
);

reg [3:0] sel_n;
reg [3:0] current_input;
reg [15:0] count;
reg clk_out;

assign sel = en ? ~sel_n : 4'b1111;

always@(posedge clk) begin
	if(rst) begin
		count <= 16'd0;
		clk_out <= 1'b1;
	end
	else begin
		if(count == 16'd49999) begin
			clk_out <= ~clk_out;
			count <= 16'd0;
		end
		else
			count <= count + 16'd1;	
	end
end

always @(posedge clk_out) begin
	if (rst)
		sel_n <= 4'b1000;
	else if (en)
		sel_n <= sel_n == 4'b0001 ? 4'b1000 : (sel_n >> 1);
	else
		sel_n <= sel_n;
end

always @(*) begin
	case(current_input)
		0: m_disp = 7'b0000001;
		1: m_disp = 7'b1001111;
		2: m_disp = 7'b0010010;
		3: m_disp = 7'b0000110;
		4: m_disp = 7'b1001100;
		5: m_disp = 7'b0100100;
		6: m_disp = 7'b0100000;
		7: m_disp = 7'b0001111;
		8: m_disp = 7'b0000000;
		9: m_disp = 7'b0000100;
		default: m_disp = 7'b0000001;
	endcase
end

always @(*) begin
	case (sel)
		4'b0111: current_input = data[15:12];
		4'b1011: current_input = data[11:8];
		4'b1101: current_input = data[7:4];
		4'b1110: current_input = data[3:0];
		default: current_input = data[3:0];
	endcase
end
endmodule