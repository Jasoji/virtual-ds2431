module VirtualDS2431_MEM_ReadMemory(nRst,
                                    clk,
                                    memoryDat,
                                    optionBytes,
                                    TA1,
                                    TA2,
                                    cmdRunTrig,
                                    sentDat,
                                    nRxTx,
                                    transTrig,
                                    ByteTransDone,
                                    cmdDone);
    
    
    input nRst;
    input clk;
    input [1023:0]memoryDat;
    input [63:0]optionBytes;
    input [7:0]TA1;
    input [7:0]TA2;
    input cmdRunTrig;
    output reg [7:0]sentDat;
    output nRxTx;
    output transTrig;
    input ByteTransDone;
    output reg cmdDone;
    
    assign nRxTx = 1'd1;
    
    wire[1151:0] memory;
    assign memory = {64'h5500_0000_0000_0000, optionBytes, memoryDat};
    
    wire cmdRunTrigPos;
    posPulse cmdRunTrig1(.i(cmdRunTrig), .q(cmdRunTrigPos), .clk(clk));
    
    reg ioTrig;
    posPulse ioTrig1(.i(ioTrig), .q(transTrig), .clk(clk));
    
    wire ByteTransDonePos;
    posPulse ByteTransDone1(.i(ByteTransDone), .q(ByteTransDonePos), .clk(clk));
    
    reg cmdRun;
    reg [10:0]memoryPoint;
    
    always@(negedge nRst or posedge clk) begin
        if (!nRst) begin
            sentDat     <= 8'hff;
            cmdDone     <= 1'd0;
            cmdRun      <= 1'd0;
            memoryPoint <= 11'd0;
            ioTrig      <= 1'd0;
        end
        else if (cmdRunTrigPos) begin
            if ({TA2, TA1}<16'h0090) begin
                sentDat     <= 8'hff;
                cmdDone     <= 1'd0;
                cmdRun      <= 1'd1;
                memoryPoint <= TA1<<3;
                ioTrig      <= 1'd0;
            end
            else begin
                cmdDone <= 1'd1;
            end
        end
        else begin
            if (cmdRun) begin
                if (memoryPoint<11'd1152) begin
                    if (!ByteTransDonePos) begin //wait for byte sent done
                        memoryPoint <= memoryPoint;
                        sentDat     <= memory>>memoryPoint;
                        ioTrig      <= 1'd1;
                    end
                    else begin //prepare to sent next byte
                        memoryPoint <= memoryPoint+11'd8;
                        ioTrig      <= 1'd0;
                    end
                end
                else begin
                    sentDat <= 8'hff;
                    cmdDone <= 1'd1;
                    cmdRun  <= 1'd0;
                    ioTrig  <= 1'd0;
                end
            end
            else begin //idle
                sentDat    <= 8'hff;
                // cmdDone <= 1'd1;
                ioTrig     <= 1'd0;
            end
        end
    end
    
endmodule
