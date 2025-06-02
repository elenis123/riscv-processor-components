`timescale 1ns/1ps
module regfile
(output reg [31:0] readData1 ,readData2,
   input wire clk,write,
   input wire [4:0] readReg1,readReg2,writeReg,
   input wire [31:0] writeData);
  
  
  reg [31:0] register [31:0];
  integer i;
 
  initial
    begin
      
      for (i=0;i<32;i=i+1)
    register[i] = 0;
    end
  
  always@(posedge clk)
    begin
      readData1 <= register[readReg1];
      readData2 <= register[readReg2];
      if (write==1'b1 && writeReg!=5'b00000)
      begin
      register[writeReg] <= writeData;
      if (readReg1 == writeReg)
          readData1 <= writeData;
      if (readReg2 == writeReg)
         readData2 <= writeData;
      end
   end
 
endmodule
     