/*
    数字密码引爆器
*/
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
    output rt, // 红灯
    output lb, // 蜂鸣器
    output [3:0] m_disp // 当前输入数字
);

parameter WAIT = 4'd0, READY = 4'd1, INPUT1 = 4'd2, INPUT2 = 4'd3, INPUT3 = 4'd4, INPUT4 = 4'd5, CHECK = 4'd6, ERROR = 4'd7, OK = 4'd8, FIRE = 4'd9;
parameter PASSPORT = 16'h2580; // 初始密码

reg [3:0] current_state, next_state;
reg [3:0] last_input; // 上一次输入的按键
reg [15:0] input_num; // 输入的密码

// 用移位寄存器保存输入的密码
always @(posedge clk, negedge rst) begin
    if (~rst)
        last_input <= 10'd0;
    else
        case (A)
            10'b11111_11110: last_input <= 4'h0;
            10'b11111_11101: last_input <= 4'h1;
            10'b11111_11011: last_input <= 4'h2;
            10'b11111_10111: last_input <= 4'h3;
            10'b11111_01111: last_input <= 4'h4;
            10'b11110_11111: last_input <= 4'h5;
            10'b11101_11111: last_input <= 4'h6;
            10'b11011_11111: last_input <= 4'h7;
            10'b10111_11111: last_input <= 4'h8;
            10'b01111_11111: last_input <= 4'h9;
            default: last_input <= last_input;
        endcase
end

always @(posedge clk, negedge rst) begin
    if (~rst)
        input_num <= 16'0;
    else if (state == INPUT1 | state == INPUT2 | state == INPUT3 | state == INPUT4) begin
        input_num <= {input_num[11:0], last_input};
    end
    else
        input_num <= input_num;
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
            else if (A != 10'b11111_11111)
                next_state = INPUT1;
            else
                next_state = READY;
        end
        INPUT1: begin
            if (fire || sure)
                next_state = ERROR;
            else if (wait_t)
                next_state = WAIT;
            else if (A != 10'b11111_11111)
                next_state = INPUT2;
            else
                next_state = INPUT1;
        end
        INPUT2: begin
            if (fire || sure)
                next_state = ERROR;
            else if (wait_t)
                next_state = WAIT;
            else if (A != 10'b11111_11111)
                next_state = INPUT3;
            else
                next_state = INPUT2;
        end
        INPUT3: begin
            if (fire || sure)
                next_state = ERROR;
            else if (wait_t)
                next_state = WAIT;
            else if (A != 10'b11111_11111)
                next_state = INPUT4;
            else
                next_state = INPUT3;
        end
        INPUT4: begin
            if (fire || (A != 10'b11111_11111))
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
            if (input_num === PASSPORT)
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

always @(posedge clk, negedge rst) begin
    if (~rst)
        current_state <= WAIT;
    else
        current_state <= next_state;
end

assign m_disp = last_input; // 当前的输入显示
assign lt = current_state == OK;
assign bt = current_state == FIRE;
assign rt = current_state == ERROR;
assign lb = current_state == ERROR;
endmodule