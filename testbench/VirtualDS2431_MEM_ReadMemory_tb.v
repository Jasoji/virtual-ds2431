`timescale 1ns/1ns


module VirtualDS2431_MEM_ReadMemory_tb();
    
    reg rst;
    reg clk = 1;
    
    reg ioDone;
    
    
    
    reg [7:0]TA1;
    reg [7:0]TA2;
    
    wire [7:0]sentDat_readMemory;
    wire ioTrig_readMemory;
    wire nRxTx_readMemory;
    wire funDone_readMemory;
    reg funTrig_readMemory; // to start readMemory command
    // VirtualDS2431_MEM_ReadMemory readMemory(
    // .nRst(rst),
    // .clk(clk),
    // .memoryDat(dat[1023:0]),
    // .optionBytes(dat[1151:1024]),
    // .TA1(TA1),
    // .TA2(TA2),
    // .cmdRunTrig(funTrig_readMemory),
    // .sentDat(sentDat_readMemory),
    // .transTrig(ioTrig_readMemory),
    // .nRxTx(nRxTx_readMemory),
    // .ByteTransDone(ioDone),
    // .cmdDone(funDone_readMemory)
    // );
    
    VirtualDS2431_MEM_ReadMemory_forTB readMemory(
    .nRst(rst),
    .clk(clk),
    .TA1(TA1),
    .TA2(TA2),
    .cmdRunTrig(funTrig_readMemory),
    .sentDat(sentDat_readMemory),
    .transTrig(ioTrig_readMemory),
    .nRxTx(nRxTx_readMemory),
    .ByteTransDone(ioDone),
    .cmdDone(funDone_readMemory));
    
    integer i;
    task getByte;
        input[7:0] count;
        begin
            for(i = 0;i<count;i = i+1)begin
                #100;
                ioDone = 1;
                #20;
                ioDone = 0;
                #200;
            end
        end
        
    endtask
    
    
    always@(*) begin
        #10;
        clk <= ~clk;
    end
    
    initial begin
        rst                = 0;
        funTrig_readMemory = 0;
        TA1                = 8'd0;
        TA2                = 8'd0;
        ioDone             = 1;
        #200;
        rst = 1;
        
        
        TA1                = 8'd0;
        TA2                = 8'd0;
        funTrig_readMemory = 1;
        #40;
        funTrig_readMemory = 0;
        getByte(40);
        
        
        // #100;
        // rst = 0;
        // #40;
        // rst = 1;
        // #60;
        
        
        #1000;
        TA1                = 8'd32;
        TA2                = 8'd00;
        funTrig_readMemory = 1;
        #40;
        funTrig_readMemory = 0;
        getByte(140);
        
        
        #100;
        rst = 0;
        #40;
        rst = 1;
        #60;
        
        
        #1000;
        TA1                = 8'd32;
        TA2                = 8'd10;
        funTrig_readMemory = 1;
        #40;
        funTrig_readMemory = 0;
        getByte(2);
        
        $stop;
        
    end
    
    
endmodule
