`timescale 1ns/1ns

module posPulse_tb();
    
    
    reg ii;
    wire qq;
    reg clkk = 0;

    posPulse pp(
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
        
        ii = 0;
        #210;
        ii = 1;
        #910;
        ii = 0;
        #210;
        ii = 1;
        #60;
        $stop;
        
    end
    
endmodule
