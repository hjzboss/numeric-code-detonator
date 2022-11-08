/*
    顶层模块
*/
module top(
    input clk,
    input rst, // 低有效
    input wait_t,
    input setup,
    input ready,
    input fire,
    input sure,
    input [9:0] A, // 按键0-9
    output lt, // 绿灯
    output bt, // 黄灯
    output rt, // 红灯
    output lb, // 蜂鸣器
    output [3:0] m_disp // 当前输入数字    
);

wire db_wait_t, db_setup, db_ready, db_fire, db_sure;
wire [9:0] db_A;

key_debounce wait_db (
    .clk(clk),
    .rst_n(rst),
    .key(wait_t),
    .debounced_key(db_wait_t)
);

key_debounce setup_db (
    .clk(clk),
    .rst_n(rst),
    .key(setup),
    .debounced_key(setup_db)
);

key_debounce ready_db (
    .clk(clk),
    .rst_n(rst),
    .key(ready),
    .debounced_key(ready_db)
);

key_debounce fire_db (
    .clk(clk),
    .rst_n(rst),
    .key(fire),
    .debounced_key(db_fire)
);

key_debounce sure_db (
    .clk(clk),
    .rst_n(rst),
    .key(sure),
    .debounced_key(db_sure)
);

// 数字按键消抖
genvar i;

generate
    for (i = 0; i < 10; i = i+1) begin
        key_debounce A_db (
            .clk(clk),
            .rst_n(rst),
            .key(A[i]),
            .debounced_key(db_A[i])
        );
    end
endgenerate

// 实例化数字密码引爆器模块
numeric_code_detonator numeric_code_detonator_inst (
    .clk(clk),
    .rst(rst),
    .wait_t(db_wait_t),
    .setup(db_setup),
    .ready(db_ready),
    .fire(db_fire),
    .sure(db_sure),
    .A(db_A),
    .lt(lt),
    .bt(bt),
    .rt(rt),
    .lb(lb),
    .m_disp(m_disp)
);
endmodule