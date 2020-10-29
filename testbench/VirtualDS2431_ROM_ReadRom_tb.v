`timescale 1ns/1ns

module VirtualDS2431_ROM_ReadRom_tb();
    
    
    
    reg rst;
    reg clk = 1'd1;
    reg cmdTrig;
    wire[7:0]sentDat;
    wire transTrig;
    reg ByteTransDone;
    wire cmdDone;
    
    VirtualDS2431_ROM_ReadRom u1(
    .nRst(rst),
    .clk(clk),
    .romID(64'hc500002c40e4d42d),
    .cmdRunTrig(cmdTrig),
    .sentDat(sentDat),
    .transTrig(transTrig),
    .ByteTransDone(ByteTransDone),
    .cmdDone(cmdDone)
    );
    
    always @ (*) begin
        #10;
        clk <= ~clk;
    end
    
    
    task t;
        begin
            cmdTrig = 1;
            #40;
            ByteTransDone = 0;
            
            #100;
            ByteTransDone = 1;
            #20;
            ByteTransDone = 0;
            #100;
            
            #100;
            ByteTransDone = 1;
            #20;
            ByteTransDone = 0;
            #100;
            
            #100;
            ByteTransDone = 1;
            #20;
            ByteTransDone = 0;
            #100;
            
            #100;
            ByteTransDone = 1;
            #20;
            ByteTransDone = 0;
            #100;
            
            #100;
            ByteTransDone = 1;
            #20;
            ByteTransDone = 0;
            #100;
            
            #100;
            ByteTransDone = 1;
            #20;
            ByteTransDone = 0;
            #100;
            
            #100;
            ByteTransDone = 1;
            #20;
            ByteTransDone = 0;
            #100;
            
            #100;
            ByteTransDone = 1;
            #20;
            ByteTransDone = 0;
            #500;
            
            cmdTrig = 0;
        end
    endtask
    
    initial begin
        rst           = 0;
        cmdTrig       = 0;
        ByteTransDone = 1;
        #200;
        rst = 1;
        #200;
        
        t();
        #1000;
        
        
        //////////////////////////////////////
        cmdTrig = 1;
        #40;
        ByteTransDone = 0;
        
        #100;
        ByteTransDone = 1;
        #20;
        ByteTransDone = 0;
        #100;
        
        #100;
        ByteTransDone = 1;
        #20;
        ByteTransDone = 0;
        #100;
        
        #100;
        ByteTransDone = 1;
        #20;
        ByteTransDone = 0;
        #100;
        
        rst = 0;
        #200;
        rst = 1;
        #500;
        
        $stop;
        
        
        
    end
    
    
    
endmodule
