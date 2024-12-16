module ALU (output : [31:0] result, input : [31:0] first_operand , [31:0] second_operand, [3:0] ALU_Control );
    case (ALU_Control)
    4'b 0000  :begin assign result =  first_operand && second_operand ; end  
    4'b 0001  :begin assign result =  first_operand || second_operand ; end  
    4'b 0010  :begin assign result =  first_operand +  second_operand ; end  
    4'b 0110  :begin assign result =  first_operand -  second_operand ; end 
    4'b 0111  :begin  
        if(first_operand <second_operand) 
        assign result = 32'b 00001 ; 
        else result = 0 ; end 
    4'b 1100  :begin assign result = ~ (first_operand || second_operand) ; end 
    endcase
endmodule