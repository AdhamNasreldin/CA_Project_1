module Mips (input clk,reset );


wire [31:0] PCResult;
wire [31:0] PCNext;

ProgramCounter pc (.clk(clk), .rst(reset),
    .PCNext(PCNext), .PCResult(PCResult) );

wire [31:0] PCadderResult;
PCadder pcAdder(
    .PCResult(PCResult),
    .PCadderResult(PCadderResult)
);

wire [15:0] branch_offset ;
// ProgramCounter Program_counter( clk, reset ,branch,equal ,branch_offset , pc_in , pc_next) ; 
// ProgramCounter ProgramCount (
//     .clk(clk), .reset(reset) , .branch(branch) , .equal(equal) ,
//     .branch_offset(branch_offset) , .pc_next(pc_in) , .pc_out(pc_next) );


wire [31:0] instruction ; 
InstructionMemory  IM (  PCResult , instruction );


wire [5:0] opcode = instruction[31:26] ; 
wire[5:0] funct = instruction [5:0] ;
wire [3:0]  alu_op  ;
wire reg_dst,alu_src, mem_read , mem_write ,branch, mem_to_reg,reg_write ; 
wire [4:0] write_reg ; 


ControlUnit CU (
    opcode ,funct,
    reg_dst, alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch, alu_op 
);


assign write_reg = reg_dst ? instruction[15:11] : instruction[20:16];

wire [4:0] read_reg1 = instruction [25:21] ;
wire [4:0] read_reg2 = instruction [20:16] ;
assign branch_offset = instruction [15:0] ; 
wire [31:0] write_data ; 
wire [31:0] read_data1 ; 
wire [31:0] read_data2 ; 


RegisterFile RF (clk, reg_write,
    read_reg1, read_reg2, write_reg,
    write_data, read_data1, read_data2  )   ; 


wire [31:0] second_operand ; 
wire [31:0] imm_signextend ; 
assign imm_signextend = { {16{instruction[15]}}, instruction[15:0] } ;
assign second_operand = alu_src ? imm_signextend : read_data2 ; 
// assign second_operand = alu_src ?  read_data2 : instruction [15:0] ; 

wire [31:0] Alu_result ; 
wire equal ; 

ALU Alu (read_data1, second_operand,alu_op,Alu_result,equal) ;

// ALU Alu (read_data1 , second_operand, [3:0] ALU_Control, output reg [31:0] result,output zero );

wire [31:0] DM_read ; 

DataMemory DM (
    clk, mem_read, mem_write,
    Alu_result, write_data,
    DM_read );

assign  write_data = mem_to_reg ?  DM_read : Alu_result ; 
// assign  write_data = mem_to_reg ? Alu_result: read_data ; 

// conditional_expression ? true_expression: false_expression 

BranchAddr Branch (PCadderResult , branch_offset, branch_target);
assign PCNext = (branch & equal)? branch_target : PCadderResult;

endmodule

