module VirtualDS2431_MEM_ReadMemory_forTB(input nRst,
                                          input clk,
                                          input [7:0]TA1,
                                          input [7:0]TA2,
                                          input cmdRunTrig,
                                          output [7:0]sentDat,
                                          output transTrig,
                                          output nRxTx,
                                          input ByteTransDone,
                                          output cmdDone);
    
    wire [1151:0]dat;
    assign dat = {
    8'h00, 8'h00, 8'h55, 8'h00, 8'h00, 8'haa, 8'h00, 8'haa,
    8'h78, 8'h14, 8'h48, 8'hcd, 8'h9f, 8'h4c, 8'h6d, 8'h39,
    8'h04, 8'hef, 8'h35, 8'hf9, 8'h18, 8'he0, 8'h63, 8'h41,
    8'he4, 8'hd6, 8'h0a, 8'ha3, 8'h50, 8'h9b, 8'h9a, 8'h4a,
    8'h69, 8'hb8, 8'hfc, 8'h51, 8'h1d, 8'h5f, 8'h1e, 8'hed,
    8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff,
    8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff,
    8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff,
    8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff,
    8'h78, 8'h14, 8'h48, 8'hcd, 8'h9f, 8'h4c, 8'h6d, 8'h39,
    8'h04, 8'hef, 8'h35, 8'hf9, 8'h18, 8'he0, 8'h63, 8'h41,
    8'he4, 8'hd6, 8'h0a, 8'ha3, 8'h50, 8'h9b, 8'h9a, 8'h4a,
    8'h69, 8'hb8, 8'hfc, 8'h51, 8'h1d, 8'h5f, 8'h1e, 8'hed,
    8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff,
    8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff,
    8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff,
    8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hf0, 8'h00};
    
    VirtualDS2431_MEM_ReadMemory readMemory(
    .nRst(nRst),
    .clk(clk),
    .memoryDat(dat[1023:0]),
    .optionBytes(dat[1151:1024]),
    .TA1(TA1),
    .TA2(TA2),
    .cmdRunTrig(cmdRunTrig),
    .sentDat(sentDat),
    .transTrig(transTrig),
    .nRxTx(nRxTx),
    .ByteTransDone(ByteTransDone),
    .cmdDone(cmdDone)
    );
    
endmodule
