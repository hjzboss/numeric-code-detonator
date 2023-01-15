`timescale 1ps/1ps

module top_tb;

reg clk, rst;
reg wait_t, setup, ready, fire, sure, confirm;
reg[3:0] A;
wire[3:0] sel;
wire lt, bt, rt, m_disp;

initial begin
  clk <= 1'b0;
  forever #10 clk = ~clk;
end

initial begin
  rst <= 1'b1;
  #20
  rst <= 1'b0
end

initial begin
  {wait_t, setup, ready, fire, sure, confirm,} <= 6'b0;
  @(posedge clk)
  ready <= 1'b1;
  @(posedge clk)
  ready <= 1'b0;
  @(posedge clk)
  ready <= 1'b1;
  @(posedge clk)
  @(posedge clk)
  @(posedge clk)
  ready <= 1'b0;
end


top #(
  .KEY_CNT_MAX (3),
  .RT_CNT_MAX  (1),
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