module ProgramCounter (
    input clk, reset ,branch,equal ,[15:0] branch_offset , 
    input [31:0] pc_next  ,
    output reg [31:0] pc_out
);
// branch signal bteegy mn control unity 
// equal signal bteegy mn subtrac
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc_out <= 0;
        else if (branch & equal )
             pc_out <= pc_next + 4 + (branch_offset << 2); // PC + 4 + branch offset
        else
            pc_out <= pc_next;
    end
endmodule