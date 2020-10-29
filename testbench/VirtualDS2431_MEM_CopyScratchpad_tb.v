`timescale 1ns/1ns


module VirtualDS2431_MEM_CopyScratchpad_tb();
    
    reg rst;
    reg clk = 1;
    
    reg ioDone;
    
    reg [7:0]ES;
    reg [7:0]TA1;
    reg [7:0]TA2;
    
    reg [7:0]receiveDat_copyScratchpad;
    wire ioTrig_copyScratchpad;
    wire nRxTx_copyScratchpad;
    wire funDone_copyScratchpad;
    wire funFailed_copyScratchpad;
    reg funTrig_copyScratchpad;
    
    VirtualDS2431_MEM_CopyScratchpad copyScratchpad(
    .nRst(rst),
    .clk(clk),
    .TA1(TA1),
    .TA2(TA2),
    .ES(ES),
    .cmdRunTrig(funTrig_copyScratchpad),
    .receiveDat(receiveDat_copyScratchpad),
    .nRxTx(nRxTx_copyScratchpad),
    .transTrig(ioTrig_copyScratchpad),
    .ByteTransDone(ioDone),
    .cmdDone(funDone_copyScratchpad),
    .cmdFailed(funFailed_copyScratchpad)
    );
    
    always@(*) begin
        #10;
        clk <= ~clk;
    end
    
    integer i;
    task xxx;
        input [23:0] write;
        begin
            for(i = 0;i<3;i = i+1)begin
                ioDone = 0;
                #1500;
                receiveDat_copyScratchpad = write>>(i<<3);
                #20;
                ioDone = 1;
                #60;
            end
            #300;
            ioDone = 0;
            #1500;
            ioDone = 1;
            #340;
            ioDone = 0;
            #1500;
            ioDone = 1;
        end
    endtask
    
    
    initial begin
        rst                       = 0;
        receiveDat_copyScratchpad = 8'hff;
        funTrig_copyScratchpad    = 0;
        TA1                       = 8'd0;
        TA2                       = 8'd0;
        ES                        = 8'd0;
        ioDone                    = 1;
        #200;
        rst = 1;

        #10000;
        
        //test 1
        TA1                    = 8'h20;
        TA2                    = 8'd0;
        ES                     = 8'd7;
        funTrig_copyScratchpad = 1;
        #40;
        funTrig_copyScratchpad = 0;
        
        xxx(24'h070020);
        
        
        #10000;
        
        //test 2
        TA1                    = 8'h20;
        TA2                    = 8'd0;
        ES                     = 8'd7;
        funTrig_copyScratchpad = 1;
        #40;
        funTrig_copyScratchpad = 0;
        
        xxx(24'h080020);
        
        
        #10000;
        
        
        #10000;
        
        //test 3
        TA1                    = 8'h20;
        TA2                    = 8'h20;
        ES                     = 8'd7;
        funTrig_copyScratchpad = 1;
        #40;
        funTrig_copyScratchpad = 0;
        
        xxx(24'h072020);
        
        
        #10000;

        $stop;
    end
    
endmodule
