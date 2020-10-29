module VirtualDS2431_ROM_ReadRom(nRst,
                                 clk,
                                 romID,
                                 cmdRunTrig,
                                 sentDat,
                                 transTrig,
                                 nRxTx,
                                 ByteTransDone,
                                 cmdDone);
    
    
    input nRst;
    input clk;
    input [63:0]romID;
    input cmdRunTrig;
    output reg [7:0]sentDat;
    output transTrig;
    output nRxTx;
    input ByteTransDone;
    output reg cmdDone;
    
    wire cmdRunTrigPos;
    posPulse cmdRunTrig1(.i(cmdRunTrig), .q(cmdRunTrigPos), .clk(clk));
    
    reg ioTrig;
    posPulse ioTrig1(.i(ioTrig), .q(transTrig), .clk(clk));
    
    wire ByteTransDonePos;
    posPulse ByteTransDone1(.i(ByteTransDone), .q(ByteTransDonePos), .clk(clk));
    
    assign nRxTx = 1'd1;
    
    reg [3:0]cmdState;
    reg cmdRun;
    reg [6:0]i;
    always@(negedge nRst or posedge clk) begin
        if (!nRst) begin
            cmdState <= 4'd0;
            sentDat  <= 8'hff;
            cmdRun   <= 1'd0;
            cmdDone  <= 1'd0;
            i        <= 7'd0;
            ioTrig   <= 1'd0;
        end
        else if (cmdRunTrigPos) begin
            cmdState <= 4'd0;
            sentDat  <= 8'hff;
            cmdRun   <= 1'd1;
            cmdDone  <= 1'd0;
            i        <= 7'd0;
            ioTrig   <= 1'd0;
        end
        else begin
            if (cmdRun) begin
                if (cmdState < 4'd8) begin
                    
                    if (!ByteTransDonePos) begin //wait for byte sent done
                        cmdState <= cmdState;
                        sentDat  <= romID>>i;
                        ioTrig   <= 1'd1;
                    end
                    else begin //prepare to sent next byte
                        cmdState <= cmdState+4'd1;
                        i        <= i+7'd8;
                        ioTrig   <= 1'd0;
                    end
                end
                else begin //cmd end
                    sentDat <= 8'hff;
                    cmdDone <= 1'd1;
                    cmdRun  <= 1'd0;
                    ioTrig  <= 1'd0;
                end
            end
            else begin //idle
                sentDat    <= 8'hff;
                ioTrig     <= 1'd0;
            end
        end
    end
    
endmodule
