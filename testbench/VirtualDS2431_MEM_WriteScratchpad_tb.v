`timescale 1ns/1ns

module VirtualDS2431_MEM_WriteScratchpad_tb();
    
    reg rst;
    reg clk = 1;
    
    reg ioDone;
    reg endCmd;
    
    wire [2:0]ES;
    reg [7:0]TA1;
    reg [7:0]TA2;
    wire [63:0]Scratchpad;
    
    reg [7:0]receiveDat_writeScratchpad;
    wire [7:0]sentDat_writeScratchpad;
    wire ioTrig_writeScratchpad;
    wire nRxTx_writeScratchpad;
    wire funDone_writeScratchpad;
    wire funFailed_writeScratchpad;
    reg funTrig_writeScratchpad;
    
    
    VirtualDS2431_MEM_WriteScratchpad_forTB aa(
    .nRst(rst),
    .endCmd(endCmd),
    .clk(clk),
    .TA1(TA1),
    .TA2(TA2),
    .cmdRunTrig(funTrig_writeScratchpad),
    .receiveDat(receiveDat_writeScratchpad),
    .sentDat(sentDat_writeScratchpad),
    .transTrig(ioTrig_writeScratchpad),
    .nRxTx(nRxTx_writeScratchpad),
    .ByteTransDone(ioDone),
    .ES(ES),
    .Scratchpad(Scratchpad),
    .cmdDone(funDone_writeScratchpad),
    .cmdFailed(funFailed_writeScratchpad)
    );
    
    
    always@(*) begin
        #10;
        clk <= ~clk;
    end
    
    integer i;
    task xxx;
        input [63:0] write;
        begin
            for(i = 0;i<8;i = i+1)begin
                ioDone = 0;
                #1500;
                receiveDat_writeScratchpad = write>>(i<<3);
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
        rst                        = 0;
        endCmd                     = 0;
        receiveDat_writeScratchpad = 8'hff;
        funTrig_writeScratchpad    = 0;
        TA1                        = 8'd0;
        TA2                        = 8'd0;
        ioDone                     = 1;
        #200;
        rst = 1;
        
        //test 1
        TA1                     = 8'h20;
        TA2                     = 8'd0;
        funTrig_writeScratchpad = 1;
        #40;
        funTrig_writeScratchpad = 0;
        
        xxx(64'ha005160ba6aae756);
        
        
        #10000;
        
        //test 2
        TA1                     = 8'h28;
        TA2                     = 8'd0;
        funTrig_writeScratchpad = 1;
        #40;
        funTrig_writeScratchpad = 0;
        
        xxx(64'h2174083a9497987b);
        
        
        #10000;
        
        //eprom test
        TA1                     = 8'h0;
        TA2                     = 8'd0;
        funTrig_writeScratchpad = 1;
        #40;
        funTrig_writeScratchpad = 0;
        
        xxx(64'h555555555555afff);
        
        
        #10000;
        
        //read only test
        TA1                     = 8'h40;
        TA2                     = 8'd0;
        funTrig_writeScratchpad = 1;
        #40;
        funTrig_writeScratchpad = 0;
        
        xxx(64'h000000000000afff);
        
        
        #10000;
        
        //t2:t0 not 0 test
        TA1                     = 8'h1;
        TA2                     = 8'd0;
        funTrig_writeScratchpad = 1;
        #40;
        funTrig_writeScratchpad = 0;
        
        xxx(64'h0000_0000_0000_afff);
        
        
        #10000;
        
        //end cmd test
        TA1                     = 8'h0;
        TA2                     = 8'd0;
        funTrig_writeScratchpad = 1;
        #40;
        funTrig_writeScratchpad = 0;
        
        for(i = 0;i<4;i = i+1)begin
            ioDone = 0;
            #1500;
            receiveDat_writeScratchpad = 8'haa;
            #20;
            ioDone = 1;
            #60;
        end
        endCmd = 1;
        #40;
        endCmd = 0;
        for(i = 0;i<4;i = i+1)begin
            ioDone = 0;
            #1500;
            receiveDat_writeScratchpad = 8'haa;
            #20;
            ioDone = 1;
            #60;
        end
        
        
        #10000;
        
        
        $stop;
    end
    
endmodule
