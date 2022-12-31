////////////////////////////////////////////////////////////////////////////////
// Company: nudt
// Engineer: huang junzhe
//
// Create Date: 2022/11/07                        
// Design Name: numeric_code_detonator
// Module Name: top
// Target Device: PYNQ-Z2
// Tool versions: vivado 18.2
// Description:
// top module of numeric_code_detonator
//
// Dependencies: 
//
// Revision:
// 2.0
////////////////////////////////////////////////////////////////////////////////

module top(
    input clk,
    input rst,
    input wait_t,
    input setup,
    input ready,
    input fire,
    input sure,
    input [3:0] A,
	input confirm,
	output [3:0] en,
	output lt,
    output bt,
    output rt,
    output [6:0] m_disp 
);

wire db_wait_t, db_setup, db_ready, db_fire, db_sure, db_confirm;

key_debounce wait_db (
    .clk(clk),
    .rst(rst),
    .key(wait_t),
    .debounced_key(db_wait_t)
);

key_debounce setup_db (
    .clk(clk),
    .rst(rst),
    .key(setup),
    .debounced_key(db_setup)
);

key_debounce ready_db (
    .clk(clk),
    .rst(rst),
    .key(ready),
    .debounced_key(db_ready)
);

key_debounce fire_db (
    .clk(clk),
    .rst(rst),
    .key(fire),
    .debounced_key(db_fire)
);

key_debounce sure_db (
    .clk(clk),
    .rst(rst),
    .key(sure),
    .debounced_key(db_sure)
);

key_debounce confirm_db (
    .clk(clk),
    .rst(rst),
    .key(confirm),
    .debounced_key(db_confirm)
);

numeric_code_detonator numeric_code_detonator_inst (
    .clk(clk),
    .rst(rst),
    .wait_t(db_wait_t),
    .setup(db_setup),
    .ready(db_ready),
    .fire(db_fire),
    .sure(db_sure),
    .A(A),
	.confirm(db_confirm),
    .lt(lt),
    .bt(bt),
    .rt(rt),
	.en(en),
    .m_disp(m_disp)
);
endmodule
