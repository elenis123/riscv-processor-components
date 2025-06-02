`timescale 1ns/1ps

module TB_calc;

  reg TB_clk, TB_btnc, TB_btnl, TB_btnu, TB_btnr, TB_btnd;
  reg [15:0] TB_sw;
  wire [15:0] TB_led;

   
  calc DUT (
    .led(TB_led),
    .clk(TB_clk),
    .btnc(TB_btnc),
    .btnl(TB_btnl),
    .btnu(TB_btnu),
    .btnr(TB_btnr),
    .btnd(TB_btnd),
    .sw(TB_sw)
  );

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, TB_calc);

     
    TB_clk = 0;
    TB_btnc = 0;
    TB_btnl = 0;
    TB_btnu = 1;
    TB_btnr = 0;
    TB_btnd = 0;
    TB_sw = 16'h0000; 
    #120;

  
    $finish;
  end
 
  always #5 TB_clk = ~TB_clk;

  
  initial begin
    #10;  
    TB_btnu = 0;
    TB_btnd = 1;
    
    TB_btnl = 0;
    TB_btnc = 1;
    TB_btnr = 1;
    TB_sw = 16'h1234;
    #20;  
  end
  
  initial 
    begin
    #20;  
    TB_btnu = 0;
    TB_btnd = 1;
    
    TB_btnl = 0;
    TB_btnc = 1;
    TB_btnr = 0;
    TB_sw = 16'h0ff0;
    #40;  
  end
  
  initial 
    begin
    #40;  
    TB_btnu = 0;
    TB_btnd = 1;
    
    TB_btnl = 0;
    TB_btnc = 0 ;
    TB_btnr = 0;
    TB_sw = 16'h324f;
    #50;  
  end
  
   initial 
    begin
    #50;  
    TB_btnu = 0;
    TB_btnd = 1;
    
    TB_btnl = 0;
    TB_btnc = 0 ;
    TB_btnr = 1;
    TB_sw = 16'h2d31;
    #60;  
  end
  
  initial 
    begin
    #60;  
    TB_btnu = 0;
    TB_btnd = 1;
    
    TB_btnl = 1;
    TB_btnc = 0 ;
    TB_btnr = 0;
    TB_sw = 16'hffff;
    #70;  
  end
  
  initial 
    begin
    #70;  
    TB_btnu = 0;
    TB_btnd = 1;
    
    TB_btnl = 1;
    TB_btnc = 0 ;
    TB_btnr = 1;
    TB_sw = 16'h7346 ;
    #80;  
  end
  
   initial 
    begin
    #80;  
    TB_btnu = 0;
    TB_btnd = 1;
    
    TB_btnl = 1;
    TB_btnc = 1 ;
    TB_btnr = 0;
    TB_sw = 16'h0004 ;
    #90;  
  end
  
  initial 
    begin
    #90;  
    TB_btnu = 0;
      
    TB_btnd = 1;
    
    TB_btnl = 1;
    
    TB_btnc = 1 ;
    TB_btnr = 1;
    TB_sw = 16'h0004 ;
    #100;  
  end
  
  initial 
    begin
    #100;  
    TB_btnu = 0;
    TB_btnd = 1;
    
    TB_btnl = 1;
    TB_btnc = 0 ;
    TB_btnr = 1;
    TB_sw = 16'hffff ;
    #120;  
  end
  
  
  
  
   

endmodule