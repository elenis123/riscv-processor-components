 `timescale 1ns/1ps
`include"alu.v"
`include"calc_enc.v"

module calc
  (output reg [15:0] led,
   input wire clk,btnc,btnl,btnu,btnr,btnd,
   input wire [15:0] sw);
  
  reg  [15:0] accumulator;
  wire [3:0] new_alu_op;
  wire [31:0] extended_accumulator;
  wire [31:0] extended_sw;
  wire zero;
  wire [31:0] result;
  
  
  assign extended_accumulator ={{16{accumulator[15]}}, accumulator};
  assign extended_sw = {{16{sw[15]}}, sw};
                      
  alu ALU_CALC (.result(result),.zero(zero),.op1(extended_accumulator),
              .op2(extended_sw),.alu_op(new_alu_op));
                      
  decoder DECODER_CALC(.alu_op(new_alu_op),
                     .btnc(btnc),.btnl(btnl),.btnr(btnr));
  
  always @(posedge clk)
    begin
      if(btnu)//the accumulator gets the value 0
        accumulator <=16'b0;
      else if (btnd)
          
        accumulator <= result[15:0]; //the accumulator gets the value of alu's rsult 
      
      led = accumulator;
      
    end                  
   
endmodule  
  
   