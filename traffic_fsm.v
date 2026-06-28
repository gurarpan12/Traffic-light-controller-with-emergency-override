module traffic_fsm(
  input  wire clk,
  input  wire rst_n,
  input  wire emergency_sensor,
  input  wire timer_done,
  output reg [2:0] current_state,
  output reg ns_red, ns_yellow, ns_green,
  output reg ew_red, ew_yellow, ew_green
);
  
  parameter NS_GREEN       = 3'b000;
  parameter NS_YELLOW      = 3'b001;
  parameter EW_GREEN       = 3'b010;
  parameter EW_YELLOW      = 3'b011;
  parameter EMERGENCY_HOLD = 3'b100;
  
  reg [2:0] next_state;
  
  always @(*)
    begin 
      case(current_state)
        NS_GREEN: begin
          if (timer_done || emergency_sensor) next_state = NS_YELLOW;
          else next_state = NS_GREEN;
        end
        NS_YELLOW: begin
          if (timer_done) begin
            if (emergency_sensor) next_state = EMERGENCY_HOLD;
            else next_state = EW_GREEN;
          end
          else next_state = NS_YELLOW;
        end
        EW_GREEN: begin
          if (timer_done || emergency_sensor) next_state = EW_YELLOW;
          else next_state = EW_GREEN;
        end
        EW_YELLOW: begin
          if (timer_done) begin
            if (emergency_sensor) next_state = EMERGENCY_HOLD;
            else next_state = NS_GREEN;
          end
          else next_state = EW_YELLOW;
        end
        EMERGENCY_HOLD: begin
          if (timer_done && !emergency_sensor) next_state = NS_GREEN;
          else next_state = EMERGENCY_HOLD;
        end
        default: next_state = NS_GREEN;
      endcase
    end
  
  always @(posedge clk or negedge rst_n)
    begin
      if (!rst_n) current_state <= NS_GREEN;
      else current_state <= next_state;
    end
  
  always @(*)
    begin
      ns_red = 0; ns_yellow = 0; ns_green = 0;
      ew_red = 0; ew_yellow = 0; ew_green = 0;
      case (current_state)
        NS_GREEN: begin
          ns_green = 1'b1;
          ew_red = 1'b1;
        end
        NS_YELLOW: begin
          ns_yellow = 1'b1;
          ew_red = 1'b1;
        end
        EW_GREEN: begin
          ew_green = 1'b1;
          ns_red = 1'b1;
        end
        EW_YELLOW: begin
          ew_yellow = 1'b1;
          ns_red = 1'b1;
        end
        EMERGENCY_HOLD: begin
          ns_red = 1'b1;
          ew_red = 1'b1;
        end
        default: begin
          ns_red = 1'b1;
          ew_red = 1'b1;
        end
      endcase
    end
  
endmodule
