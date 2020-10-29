module VirtualDS2431_MEM_ReadScratchpad(nRst,
                                        clk,
                                        Scratchpad,
                                        TA1,
                                        TA2,
                                        ES,
                                        cmdRunTrig,
                                        sentDat,
                                        nRxTx,
                                        transTrig,
                                        ByteTransDone,
                                        cmdDone);
    
    
    input nRst;
    input clk;
    input [63:0]Scratchpad;
    input [7:0]TA1;
    input [7:0]TA2;
    input [7:0]ES;
    input cmdRunTrig;
    output reg [7:0]sentDat;
    output nRxTx;
    output transTrig;
    input ByteTransDone;
    output reg cmdDone;
    
    
    assign nRxTx = 1'd1;
    
    reg crcnRst;
    reg crcTrig;
    wire crcDone;
    reg [7:0]crcDat;
    wire [15:0]crcResult;
    wire crcDonePos;
    posPulse crcDone1(.i(crcDone), .q(crcDonePos), .clk(clk));
    crc16 u1(
    .clk(clk),
    .nRst(nRst&&crcnRst),
    .trig(crcTrig),
    .done(crcDone),
    .inDat(crcDat),
    .result(crcResult)
    );
    
    
    wire cmdRunTrigPos;
    posPulse cmdRunTrig1(.i(cmdRunTrig), .q(cmdRunTrigPos), .clk(clk));
    
    reg ioTrig;
    posPulse ioTrig1(.i(ioTrig), .q(transTrig), .clk(clk));
    
    wire ByteTransDonePos;
    posPulse ByteTransDone1(.i(ByteTransDone), .q(ByteTransDonePos), .clk(clk));
    
    reg [3:0]cmdState;
    reg cmdRun;
    
    reg [6:0]i;
    reg [2:0]byteCounter;
    
    always@(negedge nRst or posedge clk) begin
        if (!nRst) begin
            sentDat     <= 8'hff;
            cmdDone     <= 1'd0;
            crcnRst     <= 1'd0;
            crcTrig     <= 1'd0;
            crcDat      <= 8'd0;
            ioTrig      <= 1'd0;
            cmdRun      <= 1'd0;
            i           <= 7'd0;
            byteCounter <= 3'd0;
        end
        else if (cmdRunTrigPos) begin
            sentDat     <= 8'hff;
            cmdDone     <= 1'd0;
            crcnRst     <= 1'd1;
            crcTrig     <= 1'd0;
            crcDat      <= 8'd0;
            ioTrig      <= 1'd0;
            cmdRun      <= 1'd1;
            i           <= 7'd0;
            byteCounter <= TA1[2:0];
        end
        else begin
            if (cmdRun) begin
                case (cmdState)
                    4'd0: begin //cal 0xaa crc
                        if (!crcDonePos) begin
                            crcDat   <= 8'haa;
                            crcTrig  <= 1'd1;
                            ioTrig   <= 1'd0;
                            cmdState <= cmdState;
                        end
                        else begin
                            sentDat  <= TA1;
                            crcDat   <= TA1;
                            crcTrig  <= 1'd0;
                            ioTrig   <= 1'd0;
                            cmdState <= 4'd1;
                        end
                    end
                    4'd1: begin //sent ta1
                        if (!ByteTransDonePos) begin
                            sentDat  <= TA1;
                            crcDat   <= TA1;
                            ioTrig   <= 1'd1;
                            crcTrig  <= 1'd1;
                            cmdState <= cmdState;
                        end
                        else begin
                            sentDat  <= TA2;
                            crcDat   <= TA2;
                            ioTrig   <= 1'd0;
                            crcTrig  <= 1'd0;
                            cmdState <= 4'd2;
                        end
                    end
                    4'd2: begin //sent ta2
                        if (!ByteTransDonePos) begin
                            sentDat  <= TA2;
                            crcDat   <= TA2;
                            ioTrig   <= 1'd1;
                            crcTrig  <= 1'd1;
                            cmdState <= cmdState;
                        end
                        else begin
                            sentDat  <= ES;
                            crcDat   <= ES;
                            ioTrig   <= 1'd0;
                            crcTrig  <= 1'd0;
                            cmdState <= 4'd3;
                        end
                    end
                    4'd3: begin //sent ES
                        if (!ByteTransDonePos) begin
                            sentDat  <= ES;
                            crcDat   <= ES;
                            ioTrig   <= 1'd1;
                            crcTrig  <= 1'd1;
                            cmdState <= cmdState;
                        end
                        else begin
                            sentDat  <= Scratchpad[7:0];
                            crcDat   <= Scratchpad[7:0];
                            ioTrig   <= 1'd0;
                            crcTrig  <= 1'd0;
                            cmdState <= 4'd4;
                        end
                    end
                    4'd4: begin //sent 1->n bytes
                        if (!ByteTransDonePos) begin
                            sentDat  <= Scratchpad>>i;
                            crcDat   <= Scratchpad>>i;
                            ioTrig   <= 1'd1;
                            crcTrig  <= 1'd1;
                            cmdState <= cmdState;
                        end
                        else begin
                            ioTrig  <= 1'd0;
                            crcTrig <= 1'd0;
                            if (byteCounter == ES[2:0]) begin
                                cmdState <= 4'd5;
                            end
                            else begin
                                cmdState    <= cmdState;
                                byteCounter <= byteCounter+3'd1;
                                i           <= i+7'd8;
                            end
                        end
                    end
                    4'd5: begin
                        sentDat  <= crcResult[7:0];
                        crcDat   <= 8'd0;
                        ioTrig   <= 1'd0;
                        crcTrig  <= 1'd0;
                        cmdState <= 4'd6;
                    end
                    4'd6: begin //sent crc low
                        if (!ByteTransDonePos) begin
                            sentDat  <= crcResult[7:0];
                            ioTrig   <= 1'd1;
                            cmdState <= cmdState;
                        end
                        else begin
                            sentDat  <= crcResult[15:8];
                            ioTrig   <= 1'd0;
                            cmdState <= 4'd7;
                        end
                    end
                    4'd7: begin //sent crc high
                        if (!ByteTransDonePos) begin
                            sentDat  <= crcResult[15:8];
                            ioTrig   <= 1'd1;
                            cmdState <= cmdState;
                        end
                        else begin
                            cmdState <= 4'd8;
                        end
                    end
                    4'd8: begin //cmd done
                        sentDat  <= 8'hff;
                        crcDat   <= 8'd0;
                        ioTrig   <= 1'd0;
                        crcTrig  <= 1'd0;
                        cmdRun   <= 1'd0;
                        cmdState <= 4'd0;
                        crcnRst  <= 1'd0;
                        cmdDone  <= 1'd1;
                    end
                    default: begin
                        sentDat  <= 8'hff;
                        crcDat   <= 8'd0;
                        ioTrig   <= 1'd0;
                        crcTrig  <= 1'd0;
                        cmdRun   <= 1'd0;
                        cmdState <= 4'd0;
                        crcnRst  <= 1'd0;
                        cmdDone  <= 1'd1;
                    end
                endcase
            end
            else begin //idle
                sentDat  <= 8'hff;
                crcDat   <= 8'd0;
                ioTrig   <= 1'd0;
                crcTrig  <= 1'd0;
                cmdRun   <= 1'd0;
                cmdState <= 4'd0;
                crcnRst  <= 1'd0;
            end
        end
        
    end
    
endmodule
