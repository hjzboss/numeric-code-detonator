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

module top #(
  parameter KEY_CNT_MAX     = 625_000   ,
  parameter RT_CNT_MAX      = 62_500_000,
  parameter ORIGIN_PASSPORT = 16'h2580
)(
  input         clk,
  input         rst,
  input         wait_t,
  input         setup,
  input         ready,
  input         fire,
  input         sure,
  input[3:0]    A,
  input         confirm,
  output[3:0]   sel,
  output        lt,
  output        bt,
  output        rt,
  output[6:0]   m_disp 
);

wire db_wait_t, db_setup, db_ready, db_fire, db_sure, db_confirm;
wire disp_en, rt_en;
wire[15:0] passport;

key_debounce wait_db (
  .clk            (clk      ),
  .rst            (rst      ),
  .key            (wait_t   ),
  .debounced_key  (db_wait_t)
);

key_debounce setup_db (
  .clk            (clk      ),
  .rst            (rst      ),
  .key            (setup    ),
  .debounced_key  (db_setup )
);

key_debounce ready_db (
  .clk            (clk      ),
  .rst            (rst      ),
  .key            (ready    ),
  .debounced_key  (db_ready )
);

key_debounce fire_db (
  .clk            (clk      ),
  .rst            (rst      ),
  .key            (fire     ),
  .debounced_key  (db_fire  )
);

key_debounce sure_db (
  .clk            (clk      ),
  .rst            (rst      ),
  .key            (sure     ),
  .debounced_key  (db_sure  )
);

key_debounce confirm_db (
  .clk            (clk        ),
  .rst            (rst        ),
  .key            (confirm    ),
  .debounced_key  (db_confirm )
);

disp_ctrl u_disp_ctrl (
  .clk            (clk        ),
  .rst            (rst        ),

  .en             (disp_en    ),
  .data           (passport   ),
  .sel            (sel        ),
  .m_disp         (m_disp     )
);

red_led u_red_led (
  .clk            (clk        ),
  .rst            (rst        ),

  .en             (rt_en      ),
  .rt             (rt         )
);

numeric_code_detonator numeric_code_detonator_inst (
  .clk            (clk        ),
  .rst            (rst        ),

  .wait_t         (db_wait_t  ),
  .setup          (db_setup   ),
  .ready          (db_ready   ),
  .fire           (db_fire    ),
  .sure           (db_sure    ),
  .A              (A          ),
  .confirm        (db_confirm ),
  .lt             (lt         ),
  .bt             (bt         ),
  .rt_en          (rt_en      ),
  .disp_en        (disp_en    ),
  .passport       (passport   )
);
endmodule
