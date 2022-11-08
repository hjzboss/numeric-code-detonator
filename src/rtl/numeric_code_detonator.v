////////////////////////////////////////////////////////////////////////////////
// 公司: NUDT
// 工程师: 黄俊哲
// 创建日期: 2022/11/07
// 设计名称: 数字密码引爆器
// 模块名: numeric_code_detonator
// 目标器件: 未定
// 工具软件版本号: vivado
// 描述:
// 数字密码引爆器的主模块
// 修订版本:
// rev1.1
// 额外注释:
// 待定
////////////////////////////////////////////////////////////////////////////////
module numeric_code_detonator (
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
    output reg rt, // 红灯
    output lb, // 蜂鸣器
    output [3:0] m_disp // 当前输入数字
);

parameter WAIT = 4'd0, READY = 4'd1, INPUT1 = 4'd2, INPUT2 = 4'd3, INPUT3 = 4'd4, INPUT4 = 4'd5, CHECK = 4'd6, ERROR = 4'd7, OK = 4'd8, FIRE = 4'd9;
parameter ORIGIN_PASSPORT = 16'h2580; // 初始密码
// parameter RT_CNT_MAX = 16'd12499;
parameter RT_CNT_MAX = 16'd2;

reg [3:0] current_state, next_state;
reg [3:0] current_input; // 上一次输入的按键
reg [15:0] passport; // 输入的密码
reg [15:0] cnt;

// 保存上一次的按键输入
always @(posedge A[0], posedge A[1], posedge A[2], posedge A[3], posedge A[4], posedge A[5], posedge A[6], posedge A[7], posedge A[8], posedge A[9]) begin
    if (A[0])
        current_input <= 4'h0;
    else if (A[1])
        current_input <= 4'h1;
    else if (A[2])
        current_input <= 4'h2;
    else if (A[3])
        current_input <= 4'h3;
    else if (A[4])
        current_input <= 4'h4;
    else if (A[5])
        current_input <= 4'h5;
    else if (A[6])
        current_input <= 4'h6;
    else if (A[7])
        current_input <= 4'h7;
    else if (A[8])
        current_input <= 4'h8;
    else if (A[9])
        current_input <= 4'h9;
    else
        current_input <= current_input;
end

always @(*) begin
    case (current_state)
        WAIT: begin
            if (fire)
                next_state = ERROR;
            else if (ready)
                next_state = READY;
            else
                next_state = WAIT;
        end
        READY: begin
            if (sure || fire)
                next_state = ERROR;
            else if (wait_t)
                next_state = WAIT;
            else if (A != 10'd0)
                next_state = INPUT1;
            else
                next_state = READY;
        end
        INPUT1: begin
            if (fire || sure)
                next_state = ERROR;
            else if (wait_t)
                next_state = WAIT;
            else if (A != 10'd0)
                next_state = INPUT2;
            else
                next_state = INPUT1;
        end
        INPUT2: begin
            if (fire || sure)
                next_state = ERROR;
            else if (wait_t)
                next_state = WAIT;
            else if (A != 10'd0)
                next_state = INPUT3;
            else
                next_state = INPUT2;
        end
        INPUT3: begin
            if (fire || sure)
                next_state = ERROR;
            else if (wait_t)
                next_state = WAIT;
            else if (A != 10'd0)
                next_state = INPUT4;
            else
                next_state = INPUT3;
        end
        INPUT4: begin
            if (fire || (A != 10'd0))
                next_state = ERROR;
            else if (wait_t)
                next_state = WAIT;
            else if (sure)
                next_state = CHECK;
            else
                next_state = INPUT4;
        end       
        CHECK: begin
            // 检查密码正确与否
            if (passport === ORIGIN_PASSPORT)
                next_state = OK;
            else
                next_state = ERROR;
        end
        OK: begin
            next_state = fire ? FIRE : OK;
        end         
        FIRE: begin
            next_state = WAIT;
        end
        ERROR: begin
            next_state = setup ? WAIT : ERROR;
        end
    endcase
end

// 状态转换
always @(posedge clk, negedge rst) begin
    if (~rst)
        current_state <= WAIT;
    else
        current_state <= next_state;
end

// 如果输入密码导致状态变化则保存输入的密码
always @(posedge clk, negedge rst) begin
    if (~rst)
        passport <= 16'd0;
    else if (current_state == READY | current_state == INPUT1 | current_state == INPUT2 | current_state == INPUT3)
        if (current_state != next_state)
            passport <= {passport[11:0], current_input};
    else
        passport <= passport;
end

// 计数，计数0.5s
always @(posedge clk, negedge rst) begin
    if (~rst)
        cnt <= 16'd0;
    else if (current_state == ERROR)
        cnt <= (cnt == RT_CNT_MAX) ? 16'd0 : cnt + 16'd1;
    else
        cnt <= 16'd0;
end

// 红灯闪烁
always @(posedge clk, negedge rst) begin
    if (~rst)
        rt <= 1'b0;
    else if (cnt == RT_CNT_MAX)
        rt <= ~rt;
    else
        rt <= rt;
end

// todo：蜂鸣器控制

assign m_disp = current_input; // 当前的输入显示
assign lt = current_state == OK;
assign bt = current_state == FIRE;
assign lb = current_state == ERROR; // todo：蜂鸣器控制
endmodule