 `include"datapath.v"
module multicycle
  
 #(parameter [31:0] INITIAL_PC = 32'h00400000,
   parameter [2:0]  IF=3'b000,
   parameter [2:0]  ID=3'b001,
   parameter [2:0]  EX=3'b010,
   parameter [2:0]  MEM=3'b011,
   parameter [2:0]  WB=3'b100)
  
  (output wire [31:0] PC ,dAddress,dWriteData,WriteBackData,0
   output reg MemRead ,MemWrite,
   input wire clk,rst,
   input wire  [31:0] instr,dReadData);
  
  wire Zero;
  reg PCSrc,ALUSrc,RegWrite,MemtoReg,loadPC;
  reg [3:0] ALUCtrl;
  reg Branch;
  
  
  datapath D0 (.PC(PC),.dAddress(dAddress),.dWriteData(dWriteData)
               ,.dReadData(dReadData),.WriteBackData(WriteBackData)
               ,.Zero(Zero),.clk(clk),.rst(rst),.PCSrc(PCSrc)
               ,.ALUSrc(ALUSrc),.RegWrite(RegWrite),.MemToReg(MemToReg)
               ,.loadPC(loadPC),.instr(instr),.ALUCtrl(ALUCtrl));
  
 
      
  always @(posedge clk)
    begin
      case (instr[6:0]) // opcode
             
            7'b0000011: ALUSrc <= 1; //  load instructions
            7'b0100011: ALUSrc <= 1; //  store instructions
            7'b0010011: ALUSrc <= 1; //  ALU Immediate instructions

            default: ALUSrc = 0; 
        endcase
    end
      
      reg [2:0] current_state,next_state;
      
  always@(posedge clk or posedge rst)
        begin
          if(rst)
            current_state<=IF;
          else
            current_state<=next_state;
        end
      
      
      always@(current_state)
        begin
          case(current_state)
            IF:next_state=ID;
            ID:next_state=EX;
            EX:begin
              if(PCSrc)
                next_state=WB;
              else
                next_state=MEM;
            end
            MEM:next_state=WB;
            WB:next_state=IF;
          endcase
        end
  
  
  
      
      always@(current_state)
        begin
          case(current_state)
            IF:begin
              loadPC=1'b0;
              RegWrite=1'b0;
            end
            
            ID:begin
              if(Zero==1'b1 && instr[6:0]==7'b1100011)
                PCSrc=1'b1;
              else
                PCSrc=1'b0;
               
              
    case (instr[6:0]) // opcode
        7'b0110011: // R-type
            begin
               case (instr[31:25]) // funct7
                 7'b0000000:
                   begin 
                      case (instr[14:12]) // funct3
                        3'b000:ALUCtrl=4'b0010; //ADD
                        3'b001:ALUCtrl=4'b1001; //SLL
                        3'b010:ALUCtrl=4'b0111; //SLT
                        3'b100:ALUCtrl=4'b1101; //XOR
                        3'b101:ALUCtrl=4'b1000; //SRL
                        3'b110:ALUCtrl=4'b0001; //OR
                        3'b111:ALUCtrl=4'b0010; //AND
                      endcase
                    end
                  7'b0100000:
                      begin 
                        case (instr[14:12]) // funct3
                          3'b000:ALUCtrl=4'b0110; //SUB
                          3'b101:ALUCtrl=4'b1010; //SRA
                         endcase
                       end
               endcase
              end
         7'b0010011://I-type
             begin
                case (instr[14:12]) // funct3
                  3'b000:ALUCtrl=4'b0010; //ADDI
                  3'b010:ALUCtrl=4'b0111; //SLTI
                  3'b100:ALUCtrl=4'b1101; //XORI
                  3'b110:ALUCtrl=4'b0001; //ORI
                  3'b111:ALUCtrl=4'b0000; //ANDI
                 endcase
             end                
                          
                          
        7'b0000011: ALUCtrl = 4'b0010; // LW/SW -> ADD(LW)
        7'b0100011: ALUCtrl = 4'b0010; // LW/SW -> ADD(SW)
        7'b1100011: ALUCtrl = 4'b0110; // BEQ -> SUB
         
        default: ALUCtrl = 4'b0000; // Default case
    endcase
end
            EX:begin
               Branch=(instr[6:0]==7'b1100011)?1'b1:1'b0;
               
              PCSrc = (Branch & Zero);
            end
      
            MEM:begin
              if(instr[6:0]==7'b0100011)//store instr
                begin
                   MemWrite=1'b1;
                   MemRead=1'b0;
                end
                  
              else if(instr[6:0]==7'b0000011)//load
                begin
                   MemRead=1'b1;
                   MemWrite=1'b0;
                end
              else
                begin
                   MemWrite=1'b0;
                   MemRead=1'b0;
                end
                  
                 end    
      
            WB: begin
               loadPC=1'b1;
              if(PCSrc==1'b0)
                begin
                  MemWrite=1'b0;
                  MemRead=1'b0;
                  RegWrite=1'b1;
                  if(instr[6:0]==7'b0000011 )//load instr
                    RegWrite=1'b0;
                  if(instr[6:0]==7'b0000011)//load instr
                  MemtoReg=1'b1;
                  else
                    MemtoReg=1'b0;
                end
              
              
               end
            
    endcase 
      
    
      end
      
endmodule