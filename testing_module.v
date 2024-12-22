module TopModule ();

// module mips_tb();

reg clk,rst;

Mips processor (clk,rst);

initial begin
    clk = 0;
   forever #5 clk = ~clk; // Toggle clock every 5 time units
end

initial begin
    $readmemh("InstructionData.dat", processor.IM.Memory);
    $readmemh("DataMemory.dat",processor.DM.memory);
    $readmemh("RegisterData.dat",processor.RF.registers);
    rst=1;
    @(negedge clk);
    rst=0;
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    $stop;
end

endmodule 

