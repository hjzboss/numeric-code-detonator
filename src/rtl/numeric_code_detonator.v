////////////////////////////////////////////////////////////////////////////////
// Company: nudt
// Engineer: huang junzhe
//
// Create Date: 2022/11/07                        
// Design Name: numeric_code_detonator
// Module Name: numeric_code_detonator
// Target Device: PYNQ-Z2
// Tool versions: vivado 18.2
// Description:
// 1. The digital code detonator adopts 4 decimal numbers, 
//    and the currently entered number is displayed through the digital tube 
//    when entering the password.
// 2. When the 4-digit password is entered correctly, the system can 
//    start the detonation device correctly; 
//    The system alerts you when a password is entered incorrectly 
//    (one more, one less, or incorrect).
// 3. After the system reset, it is in the waiting state after the system reset,
//    press the waiting state, press the Ready button, 
//    and you are ready to enter the password.
// 4. After the password is entered correctly, it can be detonated 
//    after the password is entered correctly
// 5. When the password is entered incorrectly, the system gives an alarm 
//    When the password is entered incorrectly, the system gives an alarm 
//    and the red light flashes, at this time, Ready and Wait_t are invalid 
//    and must be reset to the waiting state by the security personnel.
// 6. After the detonation event, the system shall return to the waiting state, 
//    and after the detonation event, the system shall return to the waiting state
// 7. Ten numeric keys are entered as a password
//
// Dependencies: 
//
// Revision:
// 3.0
////////////////////////////////////////////////////////////////////////////////

module numeric_code_detonator (
  input clk,
  input rst,
  input wait_t,
  input setup,
  input ready,
  input fire,
  input sure,
  input [3:0] A, // passport input
  input confirm, // passport confirm
  output lt, // green led
  output bt, // yellow led
  output rt_en, // red led
  output disp_en, // Nixie tube enable
  output reg [15:0] passport // current passport input, connect to Nixie tube
);

localparam WAIT = 4'd0, READY = 4'd1, INPUT1 = 4'd2, INPUT2 = 4'd3, INPUT3 = 4'd4, INPUT4 = 4'd5, CHECK = 4'd6, ERROR = 4'd7, OK = 4'd8, FIRE = 4'd9, RST = 4'd10;
parameter ORIGIN_PASSPORT = 16'h2580; // initial passport

reg [3:0] current_state, next_state;
reg [31:0] cnt;
reg [3:0] ptr; // The current password input pointer
wire any_input = fire | ready | sure | wait_t; // for fpga bug

always @(*) begin
	case (current_state)
    RST: begin
      // This state is set simply to solve the bug where the FPGA board reset causes all buttons to press at the same time
      next_state = any_input ? WAIT : RST;
    end
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
      else if (confirm)
        next_state = INPUT1;
      else
				next_state = READY;
    end
		INPUT1: begin
			if (fire || sure)
        next_state = ERROR;
      else if (wait_t)
        next_state = WAIT;
      else if (confirm)
        next_state = INPUT2;
      else
				next_state = INPUT1;
    end
    INPUT2: begin
      if (fire || sure)
        next_state = ERROR;
      else if (wait_t)
        next_state = WAIT;
      else if (confirm)
        next_state = INPUT3;
      else
        next_state = INPUT2;
    end
    INPUT3: begin
      if (fire || sure)
        next_state = ERROR;
      else if (wait_t)
        next_state = WAIT;
      else if (confirm)
        next_state = INPUT4;
      else
        next_state = INPUT3;
    end
    INPUT4: begin
      if (fire || confirm)
        next_state = ERROR;
      else if (wait_t)
        next_state = WAIT;
      else if (sure)
        next_state = CHECK;
      else
        next_state = INPUT4;
    end       
    CHECK: begin
      // check the passport
      if (passport == ORIGIN_PASSPORT)
        next_state = OK;
      else
        next_state = ERROR;
    end
    OK: begin
      next_state = fire ? FIRE : OK;
    end         
		FIRE: begin
			next_state = wait_t ? WAIT : FIRE;
    end
    ERROR: begin
      next_state = setup ? WAIT : ERROR;
    end
    default: next_state = WAIT;
  endcase
end

always @(posedge clk) begin
	if (rst)
    current_state <= RST;
  else
		current_state <= next_state;
end

// save the input number
always @(posedge clk) begin
  if (rst) begin
    passport <= 16'd0;
    ptr <= 4'd15;
  end
  else if (current_state == READY || current_state == INPUT1 || current_state == INPUT2 || current_state == INPUT3)
		if (confirm) begin
      passport[ptr -: 4] <= A;
      ptr <= ptr - 4'd4;
    end
    else begin
      passport <= passport;
      ptr <= ptr;
    end
  else if (current_state == INPUT4 || current_state == CHECK || current_state == OK) begin
    passport <= passport;
    ptr <= ptr;
  end
  else begin
    passport <= 16'd0;
    ptr <= 4'd15;
  end
end

assign rt_en = current_state == ERROR;
assign disp_en = current_state == INPUT1 || current_state == INPUT2 || current_state == INPUT3 || current_state == INPUT4 || current_state == CHECK;
assign lt = current_state == OK;
assign bt = current_state == FIRE;
endmodule