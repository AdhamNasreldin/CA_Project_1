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


module SingleCycleMIPS (
    input clk, reset
);
    wire [31:0] pc, next_pc, instruction, read_data1, read_data2, alu_result, mem_data;
    wire [4:0] write_reg;
    wire [31:0] sign_ext_imm, alu_input2, write_data;
    wire reg_dst, alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch, zero;
    wire [2:0] alu_op;

    ProgramCounter pc_reg(clk, reset, branch, zero, next_pc, sign_ext_imm, pc);
    InstructionMemory im(pc, instruction);
    ControlUnit cu(instruction[31:26], instruction[5:0], reg_dst, alu_src, mem_to_reg, reg_write,
                   mem_read, mem_write, branch, alu_op);
    RegisterFile rf(clk, reg_write, instruction[25:21], instruction[20:16], write_reg, write_data,
                    read_data1, read_data2);
    ALU alu(read_data1, alu_input2, alu_op, alu_result, zero);
    DataMemory dm(clk, mem_read, mem_write, alu_result, read_data2, mem_data);

    assign sign_ext_imm = {{16{instruction[15]}}, instruction[15:0]};
    assign alu_input2 = alu_src ? sign_ext_imm : read_data2;
    assign write_reg = reg_dst ? instruction[15:11] : instruction[20:16];
    assign write_data = mem_to_reg ? mem_data : alu_result;
    assign next_pc = pc + 4;
endmodule
