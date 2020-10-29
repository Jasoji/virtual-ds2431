module posPulse_io(nRst,
                   i,
                   q,
                   clk);
    
    input nRst;
    input i;
    output reg q;
    input clk;
    
    reg a;
    reg b;
    reg c;
    always@(negedge nRst or posedge clk) begin
        if (!nRst)begin
            a <= 1'b0;
            b <= 1'b0;
            c <= 1'b0;
            q <= 1'b0;
        end
        else begin
            a <= i;
            b <= a;
            c <= b;
            if (!c && b)
                q <= 1'd1;
            else
                q <= 1'd0;
        end
    end
    
endmodule
