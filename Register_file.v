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
