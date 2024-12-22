module ALU (input  [31:0] first_operand , [31:0] second_operand, [3:0] ALU_Control, output reg [31:0] result,output zero );
 
    assign zero = ~(| result) ;
    always @(*) begin
    case (ALU_Control)
    4'b 0000  :begin result =  first_operand & second_operand ; end  
    4'b 0001  :begin result =  first_operand | second_operand ; end  
    4'b 0010  :begin result =  first_operand +  second_operand ; end  
    4'b 0110  :begin result =  first_operand -  second_operand ; end 
    4'b 1100  :begin result = ~ (first_operand | second_operand) ; end 
    default   :begin result =  first_operand +  second_operand ; end
    endcase
    end
endmodule 
