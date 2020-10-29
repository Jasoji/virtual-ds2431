module negPulse(i,
                q,
                clk);
    
    
    input i;
    output reg q;
    input clk;
    
    
    reg lastI;
    always@(posedge clk) begin
        lastI <= i;
        if (lastI && !i)
            q <= 1'd1;
        else
            q <= 1'd0;
    end
    
endmodule
