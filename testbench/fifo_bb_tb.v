`timescale 1ns/1ns

module fifo_bb_tb();
    
    reg rst;
    reg clk = 1;
    
    reg [7:0]datIn;
    wire [7:0]datOut;
    
    reg readTrig;
    reg writeTrig;
    
    wire isEmpty;
    wire isFull;
    wire [14:0]memUsed;
    
    fifo a(
    .clock(clk),
    .data(datIn),
    .rdreq(readTrig),
    .sclr(rst),
    .wrreq(writeTrig),
    .empty(isEmpty),
    .full(isFull),
    .q(datOut),
    .usedw(memUsed)
    );
    
    always@(*) begin
        #10;
        clk <= ~clk;
    end
    
    task write;
        input [7:0]dat;
        begin
            datIn     = dat;
            writeTrig = 1;
            #20;
            writeTrig = 0;
            #20;
        end
    endtask
    
    task read;
        begin
            readTrig = 1;
            #20;
            readTrig = 0;
            #20;
        end
    endtask
    
    
    
    initial begin
        readTrig  = 0;
        writeTrig = 0;
        datIn     = 8'd0;
        rst       = 1;
        #200;
        rst = 0;
        
        write(8'h01);
        write(8'h02);
        write(8'h03);
        write(8'h04);
        write(8'h05);
        
        read();
        read();
        read();
        
        #60;
        rst = 1;
        #20;
        rst = 0;
        #80;
        
        write(8'h51);
        write(8'h52);
        write(8'h53);
        
        read();
        read();
        read();
        read();
        read();
        read();
        read();
        
        $stop;
    end
    
endmodule
