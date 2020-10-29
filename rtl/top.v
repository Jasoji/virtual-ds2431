module top(nRst,
           clk,
           IO_i,
           IO_o,
           uartTx,
           vds1_idle);
    
    input nRst;
    input clk;
    input IO_i;
    output IO_o;
    output uartTx;
    output vds1_idle;
    
    wire o;
    assign IO_o = ~o;
    VirtualDS2431 vds1(
    .nRst(nRst),
    .clk(clk),
    .IO_i(IO_i),
    .IO_o(o),
    .uartTx(uartTx),
    .nIdle(vds1_idle)
    );
    
    
    
endmodule
