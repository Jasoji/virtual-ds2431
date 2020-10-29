module VirtualDS2431_MEM_WriteScratchpad(nRst,
                                         endCmd,
                                         clk,
                                         memoryDat,
                                         optionBytes,
                                         rowDat,
                                         TA1,
                                         TA2,
                                         cmdRunTrig,
                                         receiveDat,
                                         sentDat,
                                         nRxTx,
                                         transTrig,
                                         ByteTransDone,
                                         ES,
                                         Scratchpad,
                                         cmdDone,
                                         cmdFailed);
    
    input nRst;
    input endCmd;
    input clk;
    input [1023:0]memoryDat;
    input [63:0]optionBytes;
    input [63:0]rowDat;
    input [7:0]TA1;
    input [7:0]TA2;
    input cmdRunTrig;
    input [7:0]receiveDat;
    output reg [7:0]sentDat;
    output reg nRxTx;
    output transTrig;
    input ByteTransDone;
    output reg [2:0]ES;
    output reg [63:0]Scratchpad;
    output reg cmdDone;
    output reg cmdFailed;
    
    
    
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
    
    wire endCmdPos;
    posPulse endCmd1(.i(endCmd), .q(endCmdPos), .clk(clk));
    
    reg [3:0]cmdState;
    reg cmdRun;
    reg [7:0]protectOption;
    always@(negedge nRst or posedge clk) begin
        if (!nRst) begin
            sentDat    <= 8'hff;
            nRxTx      <= 1'd0;
            ES         <= 3'd0;
            Scratchpad <= 64'd0;
            cmdDone    <= 1'd1;
            crcnRst    <= 1'd0;
            crcTrig    <= 1'd0;
            crcDat     <= 8'd0;
            ioTrig     <= 1'd0;
            cmdState   <= 4'd0;
            cmdRun     <= 1'd0;
            cmdFailed  <= 1'd0;
        end
        else if (cmdRunTrigPos) begin
            sentDat    <= 8'hff;
            nRxTx      <= 1'd0;
            ES         <= TA1[2:0];
            Scratchpad <= 64'd0;
            cmdDone    <= 1'd0;
            crcnRst    <= 1'd1;
            crcTrig    <= 1'd0;
            crcDat     <= 8'd0;
            ioTrig     <= 1'd0;
            cmdState   <= 4'd0;
            cmdRun     <= 1'd1;
            cmdFailed  <= 1'd0;
        end
            else if (endCmdPos) begin
            sentDat  <= 8'hff;
            nRxTx    <= 1'd0;
            crcnRst  <= 1'd0;
            ioTrig   <= 1'd0;
            cmdState <= 4'd0;
            cmdRun   <= 1'd0;
            end
        else begin
            
            if (cmdRun) begin
                case (cmdState)
                    4'd0: begin //cal 0x0f crc
                        if (!crcDonePos) begin
                            crcDat   <= 8'h0f;
                            crcTrig  <= 1'd1;
                            cmdState <= cmdState;
                        end
                        else begin
                            crcTrig  <= 1'd0;
                            cmdState <= 4'd1;
                        end
                    end
                    4'd1: begin //cal TA1 crc
                        if (!crcDonePos) begin
                            crcDat   <= TA1;
                            crcTrig  <= 1'd1;
                            cmdState <= cmdState;
                        end
                        else begin
                            crcTrig  <= 1'd0;
                            cmdState <= 4'd2;
                        end
                    end
                    4'd2: begin //cal TA2 crc
                        if (!crcDonePos) begin
                            crcDat   <= TA2;
                            crcTrig  <= 1'd1;
                            cmdState <= cmdState;
                        end
                        else begin
                            crcTrig  <= 1'd0;
                            cmdState <= 4'd3;
                            nRxTx    <= 1'd0;
                            ioTrig   <= 1'd0;
                        end
                    end
                    4'd3: begin
                        if (!ByteTransDonePos) begin
                            cmdState          <= cmdState;
                            nRxTx             <= 1'd0;
                            ioTrig            <= 1'd1;
                            crcTrig           <= 1'd0;
                            Scratchpad[63:56] <= receiveDat;
                        end
                        else begin
                            nRxTx   <= 1'd0;
                            ioTrig  <= 1'd0;
                            crcDat  <= receiveDat;
                            crcTrig <= 1'd1;
                            if (ES == 3'd7) begin
                                cmdState <= 4'd11;
                            end
                            else begin
                                ES         <= ES+3'd1;
                                Scratchpad <= Scratchpad>>64'd8;
                            end
                        end
                    end
                    4'd11: begin //wait for crc result
                        if (!crcDonePos) begin
                            crcTrig  <= 1'd1;
                            cmdState <= cmdState;
                        end
                        else begin
                            crcTrig  <= 1'd0;
                            cmdState <= 4'd12;
                            nRxTx    <= 1'd1;
                            sentDat  <= crcResult[7:0];
                            ioTrig   <= 1'd0;
                        end
                    end
                    4'd12: begin //sent crc result low
                        if (!ByteTransDonePos) begin
                            cmdState <= cmdState;
                            nRxTx    <= 1'd1;
                            ioTrig   <= 1'd1;
                        end
                        else begin
                            cmdState <= 4'd13;
                            nRxTx    <= 1'd1;
                            sentDat  <= crcResult[15:8];
                            ioTrig   <= 1'd0;
                        end
                    end
                    4'd13: begin //sent crc result high
                        if (!ByteTransDonePos) begin
                            cmdState <= cmdState;
                            nRxTx    <= 1'd1;
                            ioTrig   <= 1'd1;
                        end
                        else begin
                            cmdState <= 4'd14;
                            nRxTx    <= 1'd0;
                            sentDat  <= 8'hff;
                            ioTrig   <= 1'd0;
                        end
                    end
                    4'd14: begin //cmd done
                        sentDat  <= 8'hff;
                        nRxTx    <= 1'd0;
                        crcnRst  <= 1'd0;
                        ioTrig   <= 1'd0;
                        cmdState <= 4'd0;
                        cmdRun   <= 1'd0;
                        if (TA2 == 8'd0) begin
                            
                            if (TA1 == 8'h80) begin //option bytes
                                
                                if (optionBytes[7:0] == 8'h55 || optionBytes[7:0] == 8'haa)
                                    Scratchpad[7:0] <= optionBytes[7:0];
                                
                                if (optionBytes[15:8] == 8'h55 || optionBytes[15:8] == 8'haa)
                                    Scratchpad[15:8] <= optionBytes[15:8];
                                
                                if (optionBytes[23:16] == 8'h55 || optionBytes[23:16] == 8'haa)
                                    Scratchpad[23:16] <= optionBytes[23:16];
                                
                                if (optionBytes[39:32] == 8'h55 || optionBytes[39:32] == 8'haa)
                                    Scratchpad[39:32] <= optionBytes[39:32];
                                
                                Scratchpad[47:40] <= optionBytes[47:40];
                                if (optionBytes[47:40] == 8'haa)
                                    Scratchpad[63:48] <= optionBytes[63:48];
                                
                            end
                            else  begin
                                protectOption = optionBytes<<{3'b0,TA1[6:5],3'b000};
                                case (protectOption)
                                    8'h55: Scratchpad   <= rowDat; //write protected
                                    8'haa: Scratchpad   <= Scratchpad&rowDat; //EPROM
                                    default: Scratchpad <= Scratchpad;
                                endcase
                            end
                            
                        end
                        else begin
                            Scratchpad <= Scratchpad;
                        end
                        
                        if (TA1[2:0] == 3'd0) begin
                            cmdDone   <= 1'd1;
                            cmdFailed <= 1'd0;
                        end
                        else begin
                            cmdDone   <= 1'd0;
                            cmdFailed <= 1'd1;
                        end
                    end
                    default:begin
                        sentDat  <= 8'hff;
                        nRxTx    <= 1'd0;
                        cmdDone  <= 1'd1;
                        crcnRst  <= 1'd0;
                        ioTrig   <= 1'd0;
                        cmdState <= 4'd0;
                        cmdRun   <= 1'd0;
                    end
                endcase
            end
            else begin //idle
                sentDat  <= 8'hff;
                nRxTx    <= 1'd0;
                crcnRst  <= 1'd0;
                ioTrig   <= 1'd0;
                cmdState <= 4'd0;
                cmdRun   <= 1'd0;
                
            end
        end
    end
    
    
endmodule
