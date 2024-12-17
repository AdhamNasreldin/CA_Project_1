module ProgramCounter (
    input clk, reset,,branch ,[15:0] branch_offset
    input [31:0] pc_in,
    output reg [31:0] pc
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 0;
        else if (branch)
             pc <= pc + 4 + (branch_offset << 2); // PC + 4 + branch offset
        else
            pc <= pc_in;
    end
endmodule
