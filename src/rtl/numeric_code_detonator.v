module numeric_code_detonator (
    input clk,
    input rst, // 低有效
    input wait_t,
    input setup,
    input ready,
    input fire,
    input sure,
    input [9:0] A, // 按键0-9
    output lt,
    output bt,
    output rt,
    output lb,
    output [3:0] m_disp
);

parameter WAIT = 4'd0, READY = 4'd1, INPUT1 = 4'd2, INPUT2 = 4'd3, INPUT3 = 4'd4, INPUT4 = 4'd5, CHECK = 4'd6, ERROR = 4'd7, OK = 4'd8, FIRE = 4'd9;
parameter PASSPORT = 16'h2580; // 初始密码

reg [3:0] current_state, next_state;
reg [9:0] last_A; // 上一次输入的按键
reg [15:0] input_num; // 输入的密码

// 用移位寄存器保存输入的密码

// todo: m_disp信号的赋值

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
            // todo: 检查密码正确与否
        end         
    endcase
end

endmodule