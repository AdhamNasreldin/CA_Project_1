module RegisterFile (
    input clk, reg_write,
    input [4:0] read_reg1, read_reg2, write_reg,
    input [31:0] write_data,
    output [31:0] read_data1, read_data2
);
    reg [31:0] registers [0:31];

    always @(posedge clk) begin
        if (reg_write & write_reg)
            registers[write_reg] <= write_data;
    end

    assign read_data1 = registers[read_reg1];
    assign read_data2 = registers[read_reg2];
endmodule

module ALU (input  [31:0] first_operand , [31:0] second_operand, [3:0] ALU_Control, output reg [31:0] result,zero );
    assign zero = 0 ; 
    case (ALU_Control)
    4'b 0000  :begin assign result =  first_operand && second_operand ; end  
    4'b 0001  :begin assign result =  first_operand || second_operand ; end  
    4'b 0010  :begin assign result =  first_operand +  second_operand ; end  
    4'b 0110  :begin assign result =  first_operand -  second_operand ;
    if (result === 32'b 0000 )
        assign zero = 1; 
    end 
    4'b 0111  :begin  
        if(first_operand <second_operand) 
        assign result = 32'b 00001 ; 
        else result = 0 ; end 
    4'b 1100  :begin assign result = ~ (first_operand || second_operand) ; end 
    endcase
    
endmodule

module ControlUnit (
    input [5:0] opcode,clk ,[5:0] funct,
    output reg reg_dst, alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch,
    output reg [3:0] ALU_Control
);
    always @(posedge clk) begin
        // Default values
        reg_dst = 0; alu_src = 0; mem_to_reg = 0; reg_write = 0;
        mem_read = 0; mem_write = 0; branch = 0; alu_op = 4'b0010;

        case (opcode)
            6'b000000: begin // R-type instructions
                reg_dst = 1; reg_write = 1;
                case (funct)
                    6'b 100000 : begin assign ALU_Control = 4'b 0010 ; end // ADD 
                    6'b 100010 : begin assign ALU_Control = 4'b 0110 ; end  //SUB
                    6'b 100100 : begin assign ALU_Control = 4'b 0000 ; end  //AND 
                    6'b 100101 : begin assign ALU_Control = 4'b 0001 ; end  // OR
                endcase
            end
            6'b100011: begin // lw
                alu_src = 1; mem_to_reg = 1; reg_write = 1;
                assign ALU_Control = 4'b 0010 ; // ADD
            end
            6'b101011: begin // sw
                alu_src = 1; mem_write = 1;
                assign ALU_Control = 4'b 0010 ; // ADD
            end
            6'b000100: begin // beq
                branch = 1; 
                assign ALU_Control = 4'b 0110 ;  //SUB
            end

        endcase
    end
endmodule


// We subsidary added the ALU_CONTROL unit to  main control unit

module ALU_Control_unit (input [5:0] funct,output reg [3:0]ALU_Control )
    case (funct)
 6'b 100000 : begin assign ALU_Control = 4'b 0010 ; end // ADD 
 6'b 100010 : begin assign ALU_Control = 4'b 0110 ; end  //SUB
 6'b 100100 : begin assign ALU_Control = 4'b 0000 ; end  //AND 
 6'b 100101 : begin assign ALU_Control = 4'b 0001 ; end  // OR

 endcase

endmodule

module DataMemory (
    input clk, mem_read, mem_write,mem_to_reg
    input [31:0] addr, write_data,
    output [31:0] read_data
);
    reg [7:0] memory [16383:0];
    
    always @(posedge clk) begin
        if (mem_read) begin
            read_data <= {DataMem[Address], DataMem[Address+1], DataMem[Address+2], DataMem[Address+3]};
        end
        if (mem_write)
            assign memory[addr]   = write_data[31:24];
            assign memory[addr+1] = write_data[23:16];
            assign memory[addr+2] = write_data[15:8];
            assign memory[addr+3] = write_data[7:0];
    end
    if(mem_to_reg == 0)
        assign read_data = addr ;
        
endmodule
module InstructionMemory( input [31:0] ReadAddress , output [31:0] ReadData );
    reg [7:0] Memory [4095:0];

    assign ReadData = {Memory[ReadAddress], Memory[ReadAddress+1], Memory[ReadAddress+2], Memory[ReadAddress+3]};
endmodule

module ProgramCounter (
    input clk, reset ,branch,equal ,[15:0] branch_offset
    input [31:0] pc_next  ,
    output reg [31:0] pc_out
);
// branch signal bteegy mn control unity 
// equal signal bteegy mn subtrac
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 0;
        else if (branch & equal )
             pc <= pc + 4 + (branch_offset << 2); // PC + 4 + branch offset
        else
            pc_out <= pc_next;
    end
endmodule

module Mips (input clk,reset );
wire [31:0]pc_in , [31:0]pc_next ; 
wire [31:0] instruction ; 

wire equal, branch ; 
wire [15:0] branch_offset ;
ProgramCounter Program_counter( clk, reset ,branch,equal ,branch_offset , pc_in , pc_next) ; 


InstructionMemory  IM (  pc_next , instruction );


wire [5:0] opcode = instruction[31:26] ; 
wire[5:0] funct = instruction [5:0]
wire [3:0]  alu_op  ;
wire reg_dst,alu_src, mem_read , mem_write ; 
wire [4:0] write_reg ; 


ControlUnit CU ( opcode, clk,funct ,reg_dst, alu_src, mem_to_reg, reg_write,
    , mem_read , mem_write, branch, alu_op );

if (reg_dst)
    assign write_reg = instruction [15:11] ; //reg_dst ==1 R-type
else assign write_reg = instruction [20:16] ; // reg_dst ==0

wire read_reg1 = instruction [25:21] ;
wire read_reg2 = instruction [20:16] ;
wire [31:0] write_data ; 
wire [31:0] read_data1 ; 
wire [31:0] read_data2 ; 

RegisterFile RF (clk, reg_write,
    read_reg1, read_reg2, write_reg,
    write_data, read_data1, read_data2  )   ; 


wire [31:0] second_operand ; 
if(alu_src)
    assign second_operand = instruction [15:0] ; 
else assign second_operand = read_data2 ;  

wire [31:0] Alu_result ; 

ALU Alu (read_data1, second_operand,alu_op,Alu_result,equal) ;

DataMemory DM (
    clk, mem_read, mem_write,
    Alu_result, write_data,
    read_data );


endmodule
