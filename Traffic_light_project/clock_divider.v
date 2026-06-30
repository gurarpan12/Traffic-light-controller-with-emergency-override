module clock_divider#(
  parameter freq = 30000000
)(
  input wire clk,
  input wire rst_n,
  output reg clk_1hz
);
  
  reg[24:0] counter;
  
  always@(posedge clk or negedge rst_n)
    begin
      if(!rst_n)
        begin
          counter <= 25'd0;
          clk_1hz <= 1'b0;
        end
      else
        begin
          if(counter == (freq-1))
            begin
              counter <= 25'd0;
              clk_1hz <= 1;
            end
          else
            begin
              counter <= counter+1'b1;
              clk_1hz <= 0;
            end
        end
    end
  
endmodule
