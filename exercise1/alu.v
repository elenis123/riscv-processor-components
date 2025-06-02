 `timescale 1ns/1ps
 module alu 
 #(parameter [3:0] ALUOP_AND = 4'b0000,
  parameter [3:0] ALUOP_OR = 4'b0001,
  parameter [3:0] ALUOP_SUM = 4'b0010,
  parameter [3:0] ALUOP_SUB = 4'b0110,
  parameter [3:0] ALUOP_LESSTHAN = 4'b0111,
  parameter [3:0] ALUOP_LOGSHIFTR = 4'b1000,
  parameter [3:0] ALUOP_LOGSHIFTL = 4'b1001,
  parameter [3:0] ALUOP_SHIFTR = 4'b1010,
  parameter [3:0] ALUOP_XOR = 4'b1101)
   
 (output reg [31:0] result,
  output reg zero,
  input wire [31:0] op1,
  input wire [31:0] op2,
  input wire [3:0] alu_op);

   reg [31:0] m0, m1, m2, m3, m4, m5, m6, m7, m8;

  always @(*)
  begin
    m0 = op1 & op2;
    m1 = op1 | op2;
    m2 = op1 + op2;
    m3 = op1 - op2;
    m4 = ($signed(op1) < $signed(op2));
    m5 = op1 >> op2[4:0];
    m6 = op1 << op2[4:0];
    m7 =  $unsigned($signed( op1) >>> op2[4:0]);
    m8 = (op1 ^ op2);
    
    result = (alu_op == ALUOP_AND) ? m0 ://AND
    (alu_op == ALUOP_OR) ? m1 ://OR
    (alu_op == ALUOP_SUM) ? m2 ://SUM
    (alu_op == ALUOP_SUB) ? m3 ://SUB
    (alu_op == ALUOP_LESSTHAN) ? m4 ://LESS THAN
    (alu_op == ALUOP_LOGSHIFTR) ? m5 ://LOGICAL SHIFT RIGHT
    (alu_op == ALUOP_LOGSHIFTL) ? m6 ://LOGICAL SHIFT LEFT
    (alu_op == ALUOP_SHIFTR) ? m7 ://SHIFT RIGHT
    (alu_op == ALUOP_XOR) ? m8 ://XOR
     32'b00000000000000000000000000000000;
    zero = (result == 32'b00000000000000000000000000000000) ? 1'b1 : 1'b0;
  end
endmodule