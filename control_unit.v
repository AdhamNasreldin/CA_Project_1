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
