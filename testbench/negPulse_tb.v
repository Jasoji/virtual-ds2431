`timescale 1ns/1ns

module negPulse_tb();
    
    
    reg ii;
    wire qq;
    reg clkk = 0;

    negPulse np(
    .i(ii),
    .q(qq),
    .clk(clkk)
    );
    
    
    
    always begin
        #10;
        clkk <= ~clkk;
    end
    
    initial begin
        // clk = 0;
        
        ii = 1;
        #210;
        ii = 0;
        #910;
        ii = 1;
        #210;
        ii = 0;
        #60;
        $stop;
        
    end
    
endmodule
