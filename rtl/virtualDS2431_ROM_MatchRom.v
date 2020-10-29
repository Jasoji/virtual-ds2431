module virtualDS2431_ROM_MatchRom(nRst,
                                  clk,
                                  romID,
                                  cmdRunTrig,
                                  receiveDat,
                                  nRxTx,
                                  transTrig,
                                  ByteTransDone,
                                  cmdDone,
                                  cmdFailed);
    
    input nRst;
    input clk;
    input [63:0]romID;
    input cmdRunTrig;
    input [7:0]receiveDat;
    output nRxTx;
    output transTrig;
    input ByteTransDone;
    output reg cmdDone;
    output reg cmdFailed;
    
    
    
    wire cmdRunTrigPos;
    posPulse cmdRunTrig1(.i(cmdRunTrig), .q(cmdRunTrigPos), .clk(clk));
    
    reg ioTrig;
    posPulse ioTrig1(.i(ioTrig), .q(transTrig), .clk(clk));
    
    wire ByteTransDonePos;
    posPulse ByteTransDone1(.i(ByteTransDone), .q(ByteTransDonePos), .clk(clk));
    
    assign nRxTx = 1'd0;
    
    
    reg [3:0]cmdState;
    reg cmdRun;
    reg [6:0]i;
    
    reg [7:0]compareTemp;
    
    always@(negedge nRst or posedge clk) begin
        if (!nRst) begin
            cmdState    <= 4'd0;
            cmdDone     <= 1'd0;
            cmdFailed   <= 1'd0;
            cmdRun      <= 1'd0;
            i           <= 7'd0;
            ioTrig      <= 1'd0;
            compareTemp <= 8'd0;
        end
        else if (cmdRunTrigPos) begin
            cmdRun      <= 1'd1;
            i           <= 7'd0;
            cmdState    <= 4'd0;
            ioTrig      <= 1'd0;
            cmdDone     <= 1'd0;
            cmdFailed   <= 1'd0;
            compareTemp <= romID>>i;
        end
        else begin
            if (cmdRun) begin
                if (cmdState < 4'd8) begin
                    if (!ByteTransDonePos) begin //wait for byte sent done
                        cmdState    <= cmdState;
                        ioTrig      <= 1'd1;
                        compareTemp <= romID>>i;
                    end
                    else begin //prepare to match next byte
                        ioTrig <= 1'd0;
                        if (receiveDat == compareTemp) begin //equal
                            cmdState <= cmdState+4'd1;
                            i        <= i+7'd8;
                        end
                        else begin //not equel
                            cmdDone   <= 1'd0;
                            cmdFailed <= 1'd1;
                            cmdRun    <= 1'd0;
                        end
                    end
                end
                else begin //cmd end
                    cmdDone   <= 1'd1;
                    cmdFailed <= 1'd0;
                    cmdRun    <= 1'd0;
                    ioTrig    <= 1'd0;
                end
            end
            else begin //idle
                ioTrig   <= 1'd0;
                i        <= 7'd0;
                cmdState <= 4'd0;
                ioTrig   <= 1'd0;
                cmdRun   <= 1'd0;
            end
        end
        
    end
    
    
endmodule
