module InstructionMemory( input [31:0] ReadAddress , output [31:0] ReadData );
    reg [7:0] Memory [4095:0];

    assign ReadData = {Memory[ReadAddress], Memory[ReadAddress+1], Memory[ReadAddress+2], Memory[ReadAddress+3]};
endmodule
    
