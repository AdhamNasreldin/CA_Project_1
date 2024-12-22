module DataMemory (
    input clk, mem_read, mem_write,mem_to_reg, 
    input [31:0] addr, write_data,
    output [31:0] read_data
);
    reg [7:0] memory [16383:0];
    wire [31:0]data_out
    
    always @(posedge clk) begin
        if (mem_read)
            data_out <= {memory[Address], memory[Address+1], memory[Address+2], memory[Address+3]} ;
        if (mem_write)
            memory[addr]   <= write_data[31:24];
            memory[addr+1] <= write_data[23:16];
            memory[addr+2] <= write_data[15:8];
            memory[addr+3] <= write_data[7:0];
    end
    always @(*) begin 
    if(mem_to_reg == 0)
        read_data <= addr ;
    else read_data <= data_out ;
    end 
        
endmodule