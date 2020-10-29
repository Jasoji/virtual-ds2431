module VirtualDS2431_MEM_ReadScratchpad_tb();
    
    reg rst;
    reg clk = 1;
    
    
    
    
    reg [7:0]TA1;
    reg [7:0]TA2;
    reg [63:0]Scratchpad;
    reg [7:0]ES;
    
    wire [7:0]sentDat_readScratchpad;
    wire ioTrig_readScratchpad;
    reg ioDone;
    wire nRxTx_readScratchpad;
    wire funDone_readScratchpad;
    reg funTrig_readScratchpad; // to start readScratchpad command
    
    VirtualDS2431_MEM_ReadScratchpad readScratchpad(
    .nRst(rst),
    .clk(clk),
    .Scratchpad(Scratchpad),
    .TA1(TA1),
    .TA2(TA2),
    .ES(ES),
    .cmdRunTrig(funTrig_readScratchpad),
    .sentDat(sentDat_readScratchpad),
    .nRxTx(nRxTx_readScratchpad),
    .transTrig(ioTrig_readScratchpad),
    .ByteTransDone(ioDone),
    .cmdDone(funDone_readScratchpad)
    );
    
    integer i;
    task getByte;
        input[7:0] count;
        begin
            for(i = 0;i<count;i = i+1)begin
                // #100;
                // ioDone = 1;
                #20;
                ioDone = 0;
                #1000;
                ioDone = 1;
            end
        end
    endtask
    
    
    always@(*) begin
        #10;
        clk <= ~clk;
    end
    
    initial begin
        rst                    = 0;
        funTrig_readScratchpad = 0;
        TA1                    = 8'h00;
        TA2                    = 8'h00;
        ES                     = 8'h07;
        ioDone                 = 1;
        Scratchpad             = 64'd0;
        #200;
        rst = 1;
        
        
        TA1                    = 8'h20;
        TA2                    = 8'h00;
        Scratchpad             = 64'ha005_160b_a6aa_e756;
        ES                     = 8'h07;
        funTrig_readScratchpad = 1;
        #40;
        funTrig_readScratchpad = 0;
        getByte(13);
        
        #1000;
        TA1                    = 8'h28;
        TA2                    = 8'd00;
        Scratchpad             = 64'h2174_083a_9497_987b;
        ES                     = 8'h07;
        funTrig_readScratchpad = 1;
        #40;
        funTrig_readScratchpad = 0;
        getByte(13);
        
        
        #1000;
        rst = 0;
        #1000;
        rst = 1;
        #60;
        
        
        #1000;
        TA1                    = 8'h23;
        TA2                    = 8'd10;
        funTrig_readScratchpad = 1;
        #40;
        funTrig_readScratchpad = 0;
        getByte(14);
        
        $stop;
        
    end
    
endmodule
