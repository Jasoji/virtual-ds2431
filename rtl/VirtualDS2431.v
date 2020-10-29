module VirtualDS2431(nRst,
                     clk,
                     IO_i,
                     IO_o,
                     uartTx,
                     nIdle);
    
    input nRst;
    input clk;
    input IO_i;
    output IO_o;
    output uartTx;
    output nIdle;
    
    
    
    wire ioTrig_matchRom;
    wire ioTrig_readMemory;
    wire ioTrig_writeScratchpad;
    wire ioTrig_readRom;
    wire ioTrig_readScratchpad;
    wire ioTrig_copyScratchpad;
    
    wire funTrig_readRom;
    wire funTrig_matchRom;
    wire funTrig_readMemory;
    wire funTrig_writeScratchpad;
    wire funTrig_readScratchpad;
    wire funTrig_copyScratchpad;
    
    wire funDone_readRom;
    wire funDone_matchRom;
    wire funDone_readMemory;
    wire funDone_writeScratchpad;
    wire funDone_readScratchpad;
    wire funDone_copyScratchpad;
    
    wire nRxTx_readRom;
    wire nRxTx_matchRom;
    wire nRxTx_readMemory;
    wire nRxTx_writeScratchpad;
    wire nRxTx_readScratchpad;
    wire nRxTx_copyScratchpad;
    
    wire [7:0]sentDat_readRom;
    wire [7:0]sentDat_writeScratchpad;
    wire [7:0]sentDat_readMemory;
    wire [7:0]sentDat_readScratchpad;
    
    wire funFailed_matchRom;
    wire funFailed_writeScratchpad;
    wire funFailed_copyScratchpad;
    
    wire endCmd;
    wire idle;
	 wire memoryUpdated;
    
    
    wire nBusRst;
    wire nODBusRst;
    wire nRxTx;
    wire [7:0]sentDat;
    wire [7:0]receiveDat;
    wire odMode;
    wire ioTrig;
    wire ioDone;
    
    
    wire [1023:0]memoryDat;
    wire [63:0]optionBytes;
    wire [63:0]romID;
    wire [63:0]rowDat;
    wire [63:0]Scratchpad;
    
    wire [7:0]TA1;
    wire [7:0]TA2;
    wire AA;
    wire PF;
    wire writeToMemory;
    
    assign nIdle = ~idle;
    //
    // IO controler
    //
    VirtualDS2431_IO dsio(
    .nRst(nRst),
    .clk(clk),
    .IO_i(IO_i),
    .IO_o(IO_o),
    .odMode(odMode),
    .nRxTx(nRxTx),
    .trig(ioTrig),
    .sentDat(sentDat),
    .receiveDat(receiveDat),
    .nBusRst(nBusRst),
    .nODBusRst(nODBusRst),
    .done(ioDone)
    );
    
    
    //
    // memory
    //
    VirtualDS2431_memory memory(
    .nRst(nRst),
    .clk(clk),
    .TA1(TA1),
    .Scratchpad(Scratchpad),
    .writeToMemory(writeToMemory),
    .memory(memoryDat),
    .optionBytes(optionBytes),
    .romID(romID),
    .rowDat(rowDat)
    );
    
    
    // to reset or stop the function module.
    wire cmdRst;
    assign cmdRst = nRst & (~endCmd);
    
    //
    // read rom cmd
    //
    
    VirtualDS2431_ROM_ReadRom readRom(
    .nRst(cmdRst),
    .clk(clk),
    .romID(romID),
    .cmdRunTrig(funTrig_readRom),
    .sentDat(sentDat_readRom),
    .nRxTx(nRxTx_readRom),
    .transTrig(ioTrig_readRom),
    .ByteTransDone(ioDone),
    .cmdDone(funDone_readRom)
    );
    
    //
    // match rom cmd
    //
    
    virtualDS2431_ROM_MatchRom mathcRom(
    .nRst(cmdRst),
    .clk(clk),
    .romID(romID),
    .cmdRunTrig(funTrig_matchRom),
    .receiveDat(receiveDat),
    .nRxTx(nRxTx_matchRom),
    .transTrig(ioTrig_matchRom),
    .ByteTransDone(ioDone),
    .cmdDone(funDone_matchRom),
    .cmdFailed(funFailed_matchRom)
    );
    
    //
    // read memory cmd
    //
    
    VirtualDS2431_MEM_ReadMemory readMemory(
    .nRst(cmdRst),
    .clk(clk),
    .memoryDat(memoryDat),
    .optionBytes(optionBytes),
    .TA1(TA1),
    .TA2(TA2),
    .cmdRunTrig(funTrig_readMemory),
    .sentDat(sentDat_readMemory),
    .transTrig(ioTrig_readMemory),
    .nRxTx(nRxTx_readMemory),
    .ByteTransDone(ioDone),
    .cmdDone(funDone_readMemory)
    );
    
    //
    // write scratchpad
    //
    wire [2:0]ES210;
    VirtualDS2431_MEM_WriteScratchpad writeScratchpad(
    .nRst(nRst),
    .endCmd(endCmd),
    .clk(clk),
    .memoryDat(memoryDat),
    .optionBytes(optionBytes),
    .rowDat(rowDat),
    .TA1(TA1),
    .TA2(TA2),
    .cmdRunTrig(funTrig_writeScratchpad),
    .receiveDat(receiveDat),
    .sentDat(sentDat_writeScratchpad),
    .nRxTx(nRxTx_writeScratchpad),
    .transTrig(ioTrig_writeScratchpad),
    .ByteTransDone(ioDone),
    .ES(ES210),
    .Scratchpad(Scratchpad),
    .cmdDone(funDone_writeScratchpad),
    .cmdFailed(funFailed_writeScratchpad)
    );
    
    //
    // read scratchpad
    //
    
    VirtualDS2431_MEM_ReadScratchpad readScratchpad(
    .nRst(cmdRst),
    .clk(clk),
    .Scratchpad(Scratchpad),
    .TA1(TA1),
    .TA2(TA2),
    .ES({AA,1'b0,PF,2'b0,ES210}),
    .cmdRunTrig(funTrig_readScratchpad),
    .sentDat(sentDat_readScratchpad),
    .nRxTx(nRxTx_readScratchpad),
    .transTrig(ioTrig_readScratchpad),
    .ByteTransDone(ioDone),
    .cmdDone(funDone_readScratchpad)
    );
    
    //
    // copy scratchpad
    //
    
    VirtualDS2431_MEM_CopyScratchpad copyScratchpad(
    .nRst(cmdRst),
    .clk(clk),
    .TA1(TA1),
    .TA2(TA2),
    .ES({AA,1'b0,PF,2'b0,ES210}),
    .cmdRunTrig(funTrig_copyScratchpad),
    .receiveDat(receiveDat),
    .nRxTx(nRxTx_copyScratchpad),
    .transTrig(ioTrig_copyScratchpad),
    .ByteTransDone(ioDone),
    .cmdDone(funDone_copyScratchpad),
    .cmdFailed(funFailed_copyScratchpad)
    );
    
    
    VirtualDS2431_main main (
    .nRst(nRst),
    .clk(clk),
    .TA1(TA1),
    .TA2(TA2),
    .AA(AA),
    .PF(PF),
    .odMode(odMode),
    .optionBytes(optionBytes),
    .writeToMemory(writeToMemory),
    .receiveDat(receiveDat),
    .nBusRst(nBusRst),
    .nODBusRst(nODBusRst),
    .ioDone(ioDone),
    .ioTrig(ioTrig),
    .ioTrig_matchRom(ioTrig_matchRom),
    .ioTrig_readMemory(ioTrig_readMemory),
    .ioTrig_writeScratchpad(ioTrig_writeScratchpad),
    .ioTrig_readRom(ioTrig_readRom),
    .ioTrig_readScratchpad(ioTrig_readScratchpad),
    .ioTrig_copyScratchpad(ioTrig_copyScratchpad),
    .funTrig_readRom(funTrig_readRom),
    .funTrig_matchRom(funTrig_matchRom),
    .funTrig_readMemory(funTrig_readMemory),
    .funTrig_writeScratchpad(funTrig_writeScratchpad),
    .funTrig_readScratchpad(funTrig_readScratchpad),
    .funTrig_copyScratchpad(funTrig_copyScratchpad),
    .funDone_readRom(funDone_readRom),
    .funDone_matchRom(funDone_matchRom),
    .funDone_readMemory(funDone_readMemory),
    .funDone_writeScratchpad(funDone_writeScratchpad),
    .funDone_readScratchpad(funDone_readScratchpad),
    .funDone_copyScratchpad(funDone_copyScratchpad),
    .nRxTx(nRxTx),
    .nRxTx_readRom(nRxTx_readRom),
    .nRxTx_matchRom(nRxTx_matchRom),
    .nRxTx_readMemory(nRxTx_readMemory),
    .nRxTx_writeScratchpad(nRxTx_writeScratchpad),
    .nRxTx_readScratchpad(nRxTx_readScratchpad),
    .nRxTx_copyScratchpad(nRxTx_copyScratchpad),
    .sentDat(sentDat),
    .sentDat_readRom(sentDat_readRom),
    .sentDat_writeScratchpad(sentDat_writeScratchpad),
    .sentDat_readMemory(sentDat_readMemory),
    .sentDat_readScratchpad(sentDat_readScratchpad),
    .funFailed_matchRom(funFailed_matchRom),
    .funFailed_writeScratchpad(funFailed_writeScratchpad),
    .funFailed_copyScratchpad(funFailed_copyScratchpad),
    .endCmd(endCmd),
    .idle(idle),
	 .memoryUpdated(memoryUpdated)
    );
    
    
    //
    // debug, sent all memory dat by uart
    //
    assign memoryUpdated = (flowState == FLOW_AFTER_PROGRAMED)?1'd1:1'd0;
    debug memoryMonitor(
    .nRst(nRst),
    .clk(clk),
    .memoryDat(memoryDat),
    .optionBytes(optionBytes),
    .memoryUpdated(memoryUpdated),
    .tx(uartTx)
    );
endmodule
