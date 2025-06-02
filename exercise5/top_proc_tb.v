`include "ram.v"
`include "rom.v"

module TB_multicycle;

  reg clk;
  reg rst;
  wire [31:0] instr;
  wire [31:0] dReadData;
  wire [31:0] PC, dAddress, dWriteData, WriteBackData;
  wire MemRead, MemWrite;
  
  // Συνδέουμε τον multicycle module με το testbench
  multicycle DUT (
    .PC(PC), .dAddress(dAddress), .dWriteData(dWriteData),
    .WriteBackData(WriteBackData), .clk(clk),
    .rst(rst), .instr(instr),
    .MemRead(MemRead), .MemWrite(MemWrite), .dReadData(dReadData)
  );
  
  DATA_MEMORY DUT_DATA_MEMORY (
    .clk(clk), .we(MemWrite), .addr(dAddress[8:0]),
    .din(dWriteData), .dout(dReadData)
  );
  
  INSTRUCTION_MEMORY DUT_INSTRUCTION_MEMORY (
    .clk(clk), .addr(PC[8:0]), .dout(instr)
  );
  
  // Clock generation
   always #5 clk = ~clk;
     
    initial begin
       
      $dumpfile("TB_multicycle.vcd");
      $dumpvars(0, TB_multicycle);
     
        clk = 0;
        rst = 1;
        #10;
        rst = 0;
        #1250;
        $finish;
    end
endmodule