`timescale 1ns/1ns

module debug_tb();
    
    
    reg rst;
    reg clk = 1;
    reg memoryUpdated;
    wire tx;
    
    
    debug d(
    .nRst(rst),
    .clk(clk),
    .memoryUpdated(memoryUpdated),
    .tx(tx)
    );
    
    always@(*) begin
        #10;
        clk <= ~clk;
    end
    
    initial begin
        rst           = 0;
        memoryUpdated = 0;
        #200;
        rst = 1;
        
        memoryUpdated = 1;
        #40;
        memoryUpdated = 0;

        #30000;
        
        memoryUpdated = 1;
        #40;
        memoryUpdated = 0;
        
        #90000000;
        
        $stop;
    end
    
    
endmodule
