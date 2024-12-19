module DataMemory (
    input clk, mem_read, mem_write,mem_to_reg
    input [31:0] addr, write_data,
    output [31:0] read_data
);
    reg [7:0] memory [16383:0];
    
    always @(posedge clk) begin
        if (mem_read) begin
            read_data <= {DataMem[Address], DataMem[Address+1], DataMem[Address+2], DataMem[Address+3]};
        end
        if (mem_write)
            assign memory[addr]   = write_data[31:24];
            assign memory[addr+1] = write_data[23:16];
            assign memory[addr+2] = write_data[15:8];
            assign memory[addr+3] = write_data[7:0];
    end
    if(mem_to_reg == 0)
        assign read_data = addr ;
        
endmodule