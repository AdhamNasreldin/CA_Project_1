module testbench();
    bit clk, rst;

    initial begin
        forever 
            #1 clk = ~clk;
    end
Mips processor(
    clk, rst
);

    initial begin
        $readmemh("InstructionData.dat", processor.IM.Memory);
        $readmemh("DataMemory.dat",processor.DM.memory);
        $readmemh("RegisterData.dat",processor.RF.registers);
        rst = 1;
        repeat(2) @(posedge clk);
        rst = 0;
        repeat(100) @(posedge clk);

            // at the end of simulation check the folowing value:
            // Register t2 represent MAX  =>  regmem[10] = 0x00CDAB00   

            $display("$t2 = 0x%08h (Hex), $t2 = %032b (bin)", processor.RF.registers[10], processor.RF.registers[10]);
            // $display("$t3 = 0x%08h (Hex), $t3 = %032b (bin)", processor.regfile.regmem[11], processor.regfile.regmem[11]);
        $stop;
    end
endmodule