`timescale 1ps/1ps

module top_tb;

reg clk, rst;
reg wait_t, setup, ready, fire, sure, confirm;
reg[3:0] A;
wire[3:0] sel;
wire lt, bt, rt;
wire[6:0] m_disp;

initial begin            
  $dumpfile("wave.vcd"); //生成的vcd文件名称
  $dumpvars(0, top_tb); //tb模块名称
end

initial begin
  clk <= 1'b0;
  forever #10 clk = ~clk;
end

initial begin
  rst <= 1'b1;
  #20
  rst <= 1'b0;
end

initial begin
  {wait_t, setup, ready, fire, sure, confirm} <= 6'b0;
  //----------------------------正确操作测试-------------------------------
  // 测试按键消抖
  @(posedge clk)
  ready <= 1'b1;
  @(posedge clk)
  ready <= 1'b0;
  repeat(3) begin
    @(posedge clk)
    ready <= 1'b1;
  end
  @(posedge clk)
  ready <= 1'b0;
  // 测试密码输入
  confirm <= 1'b1;
  repeat(3) begin
    @(posedge clk)
    confirm <= 1'b1;
  end
  @(posedge clk)
  A <= 4'd2;

  confirm <= 1'b1;
  repeat(3) begin
    @(posedge clk)
    confirm <= 1'b1;
  end
  @(posedge clk)
  A <= 4'd5;

  confirm <= 1'b1;
  repeat(3) begin
    @(posedge clk)
    confirm <= 1'b1;
  end
  @(posedge clk)
  A <= 4'd8;

  confirm <= 1'b1;
  repeat(3) begin
    @(posedge clk)
    confirm <= 1'b1;
  end
  @(posedge clk)
  A <= 4'd0;
  confirm <= 1'b0;

  // 密码确认
  sure <= 1'b1;
  repeat(3) begin
    @(posedge clk)
    sure <= 1'b1;
  end
  @(posedge clk)
  sure <= 1'b0;
  // 引爆
  fire <= 1'b1;
  repeat(3) begin
    @(posedge clk)
    fire <= 1'b1;
  end
  @(posedge clk)
  fire <= 1'b0;
  // 回到等待状态
  wait_t <= 1'b1;
  #200
  wait_t <= 1'b0;

  //----------------------------错误操作测试-------------------------------
  #200
  // 测试提前引爆进入错误状态
  ready <= 1'b1;
  repeat(3) begin
    @(posedge clk)
    ready <= 1'b1;
  end
  @(posedge clk)
  ready <= 1'b0;

  confirm <= 1'b1;
  repeat(3) begin
    @(posedge clk)
    confirm <= 1'b1;
  end
  @(posedge clk)
  confirm <= 1'b0;
  A <= 4'd2;

  fire <= 1'b1;
  repeat(3) begin
    @(posedge clk)
    fire <= 1'b1;
  end
  @(posedge clk)
  fire <= 1'b0;
  // 错误状态下等待信号无效
  wait_t <= 1'b1;
  repeat(3) begin
    @(posedge clk)
    wait_t <= 1'b1;
  end
  @(posedge clk)
  wait_t <= 1'b0;
  // 置位信号有效
  setup <= 1'b1;
  repeat(3) begin
    @(posedge clk)
    setup <= 1'b1;
  end
  @(posedge clk)
  setup <= 1'b0;

  // 测试少输入了密码
  ready <= 1'b1;
  repeat(3) begin
    @(posedge clk)
    ready <= 1'b1;
  end
  @(posedge clk)
  ready <= 1'b0;

  confirm <= 1'b1;
  repeat(3) begin
    @(posedge clk)
    confirm <= 1'b1;
  end
  @(posedge clk)
  confirm <= 1'b0;
  A <= 4'd2;

  sure <= 1'b1;
  repeat(3) begin
    @(posedge clk)
    sure <= 1'b1;
  end
  @(posedge clk)
  sure <= 1'b0;

  setup <= 1'b1;
  repeat(3) begin
    @(posedge clk)
    setup <= 1'b1;
  end
  @(posedge clk)
  setup <= 1'b0;

  // 测试多输入了密码
  ready <= 1'b1;
  repeat(3) begin
    @(posedge clk)
    ready <= 1'b1;
  end
  @(posedge clk)
  ready <= 1'b0;

  confirm <= 1'b1;
  repeat(3) begin
    @(posedge clk)
    confirm <= 1'b1;
  end
  @(posedge clk)
  A <= 4'd3;

  confirm <= 1'b1;
  repeat(3) begin
    @(posedge clk)
    confirm <= 1'b1;
  end
  @(posedge clk)
  A <= 4'd2;

  confirm <= 1'b1;
  repeat(3) begin
    @(posedge clk)
    confirm <= 1'b1;
  end
  @(posedge clk)
  A <= 4'd8;

  confirm <= 1'b1;
  repeat(3) begin
    @(posedge clk)
    confirm <= 1'b1;
  end
  @(posedge clk)
  A <= 4'd1;

  confirm <= 1'b1;
  repeat(3) begin
    @(posedge clk)
    confirm <= 1'b1;
  end
  @(posedge clk)
  A <= 4'd1;
  confirm <= 1'b0;

  setup <= 1'b1;
  repeat(3) begin
    @(posedge clk)
    setup <= 1'b1;
  end
  @(posedge clk)
  setup <= 1'b0;

  // 测试输入错误的密码
  ready <= 1'b1;
  repeat(3) begin
    @(posedge clk)
    ready <= 1'b1;
  end
  @(posedge clk)
  ready <= 1'b0;

  confirm <= 1'b1;
  repeat(3) begin
    @(posedge clk)
    confirm <= 1'b1;
  end
  @(posedge clk)
  A <= 4'd3;

  confirm <= 1'b1;
  repeat(3) begin
    @(posedge clk)
    confirm <= 1'b1;
  end
  @(posedge clk)
  A <= 4'd2;

  confirm <= 1'b1;
  repeat(3) begin
    @(posedge clk)
    confirm <= 1'b1;
  end
  @(posedge clk)
  A <= 4'd8;

  confirm <= 1'b1;
  repeat(3) begin
    @(posedge clk)
    confirm <= 1'b1;
  end
  @(posedge clk)
  A <= 4'd1;
  confirm <= 1'b0;

  sure <= 1'b1;
  repeat(3) begin
    @(posedge clk)
    sure <= 1'b1;
  end
  @(posedge clk)
  sure <= 1'b0;

  setup <= 1'b1;
  repeat(3) begin
    @(posedge clk)
    setup <= 1'b1;
  end
  @(posedge clk)
  setup <= 1'b0;

  #200
  $finish;
end


top #(
  .KEY_CNT_MAX  (4),
  .RT_CNT_MAX   (1),
  .DISP_COUNT   (1)
) dut(
  .clk      (clk    ),
  .rst      (rst    ),
  .wait_t   (wait_t ),
  .setup    (setup  ),
  .ready    (ready  ),
  .fire     (fire   ),
  .sure     (sure   ),
  .A        (A      ),
  .confirm  (confirm),
  .sel      (sel    ),
  .lt       (lt     ),
  .bt       (bt     ),
  .rt       (rt     ),
  .m_disp   (m_disp )
);

endmodule