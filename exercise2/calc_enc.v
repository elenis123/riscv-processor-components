`timescale 1ns/1ps

module decoder
  (output wire[3:0]alu_op,
   input wire btnc,btnl,btnr);
  
  wire m0,m1,m2,m3,m5,m6,m7,m8,m10,m11,m12,m13,m15,m16,m17,m18;
  
  //alu_op[0]
  
  not U0(m0,btnr);
  and U1(m1,m0,btnl);
  xor U2(m2,btnl,btnc);
  and U3(m3,m2,btnr);
  or U4(alu_op[0],m3,m1);
  
  //alu_op[1]
  
  and U5(m5,btnl,btnr);
  not U6(m6,btnl);
  not U7(m7,btnc);
  and U8(m8,m6,m7);
  or U9(alu_op[1],m5,m8);
  
  //alu_op[2]
  
  and U10(m10,btnr,btnl);
  xor U11(m11,btnr,btnl);
  or U12(m12,m10,m11);
  not U13(m13,btnc);
  and U14(alu_op[2],m12,m13);
  
  //alu_op[3]
  
  not U15(m15,btnr);
  and U16(m16,m15,btnc);
  xnor U17(m17,btnr,btnc);
  or U18(m18,m16,m17);
  and U19(alu_op[3],m18,btnl);
endmodule
  
  
  
  