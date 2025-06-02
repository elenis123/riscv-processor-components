`include"alu.v"
`include"regfile.v"
 

module datapath
   #(parameter [31:0] INITIAL_PC = 32'h00400000)
  
  (output reg [31:0] PC,WriteBackData,dWriteData,
   output wire [31:0] dAddress,dReadData,
   output wire Zero,
   input wire clk,rst,PCSrc,ALUSrc ,RegWrite,MemToReg,loadPC,
   input wire [31:0] instr,
   input wire [3:0] ALUCtrl);
  
   
  reg [31:0] branch_offset;
  
  wire [31:0] readData1;
  wire [31:0] readData2; 
  reg [31:0] extended_Itype,extended_Stype,extended_Btype;
  wire [6:0] opcode = instr[6:0];
  reg [31:0] ImmGen;
  reg [31:0] k;
   
  regfile REG_DATAPATH(.readData1(readData1),.readData2(readData2)
               ,.clk(clk),.write(RegWrite),.readReg1(instr[19:15])
               ,.readReg2(instr[24:20]),.writeReg(instr[11:7])
                        ,.writeData(WriteBackData));
  
 alu ALU_DATAPATH (.op1(readData1), .op2(k), .alu_op(ALUCtrl), .zero(Zero),    .result(dAddress));
  


  
  always @(posedge clk)
    begin
        
        if (rst) 
            PC <= INITIAL_PC;
         else 
            if (loadPC) 
              begin
                if (PCSrc)
                  PC<= PC +branch_offset;
                else
                  PC<=PC+4;  
              end
      branch_offset=extended_Btype<<1;
      
       
 
   
   
   extended_Itype={{20{instr[31]}},instr[31:20]};
   extended_Stype={{20{instr[31]}},instr[31:25],instr[11:7]};
   extended_Btype={{20{instr[31]}},instr[31],instr[7],instr[30:25],instr[11:8],1'b0};
  
   
      ImmGen= (opcode==7'b0010011)?extended_Itype:
    (opcode==7'b1100011)?extended_Btype:
    (opcode==7'b0100011)?extended_Stype:
    32'b00000000000000000000000000000000;
          

    
     k=(ALUSrc==0)?readData2:ImmGen;
  
 
  
   dWriteData =readData2;
   WriteBackData=(MemToReg==1'b1)?dReadData:dAddress;
    end
  
endmodule