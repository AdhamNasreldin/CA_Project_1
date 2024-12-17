module DataMemory (
    input clk, mem_read, mem_write,
    input [31:0] addr, write_data,
    output [31:0] read_data
);
    reg [31:0] memory [0:255];
    
    always @(posedge clk) begin
        if (mem_write)
            memory[addr[9:2]] <= write_data;
    end

    assign read_data = mem_read ? memory[addr[9:2]] : 32'b0;
endmodule