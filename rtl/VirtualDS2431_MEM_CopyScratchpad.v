module VirtualDS2431_MEM_CopyScratchpad(nRst,
                                        clk,
                                        TA1,
                                        TA2,
                                        ES,
                                        cmdRunTrig,
                                        receiveDat,
                                        nRxTx,
                                        transTrig,
                                        ByteTransDone,
                                        cmdDone,
                                        cmdFailed);
    
    
    input nRst;
    input clk;
    input [7:0]TA1;
    input [7:0]TA2;
    input [7:0]ES;
    input cmdRunTrig;
    input [7:0]receiveDat;
    output nRxTx;
    output reg transTrig;
    input ByteTransDone;
    output reg cmdDone;
    output reg cmdFailed;
    
    
    assign nRxTx = 1'd0;
    
    wire PF;
    assign PF = ES[5];
    
    wire cmdRunTrigPos;
    posPulse cmdRunTrig1(.i(cmdRunTrig), .q(cmdRunTrigPos), .clk(clk));
    
    wire ByteTransDonePos;
    posPulse ByteTransDone1(.i(ByteTransDone), .q(ByteTransDonePos), .clk(clk));
    
    reg [7:0]fromMaster_TA1;
    reg [7:0]fromMaster_TA2;
    reg [7:0]fromMaster_ES;
    
    reg [2:0]cmdState;
    reg cmdRun;
    
    task nomatch;
        begin
            cmdDone   <= 1'd0;
            cmdFailed <= 1'd1;
            cmdState  <= 4'd0;
            cmdRun    <= 1'd0;
        end
    endtask
    
    always@(negedge nRst or posedge clk) begin
        if (!nRst) begin
            transTrig      <= 1'd0;
            fromMaster_TA1 <= 8'd0;
            fromMaster_TA2 <= 8'd0;
            fromMaster_ES  <= 8'd0;
            cmdState       <= 4'd0;
            cmdRun         <= 1'd0;
            cmdDone        <= 1'd0;
            cmdFailed      <= 1'd0;
        end
        else if (cmdRunTrigPos) begin
            transTrig      <= 1'd0;
            fromMaster_TA1 <= 8'd0;
            fromMaster_TA2 <= 8'd0;
            fromMaster_ES  <= 8'd0;
            cmdState       <= 4'd0;
            cmdRun         <= 1'd1;
            cmdDone        <= 1'd0;
            cmdFailed      <= 1'd0;
        end
        else begin
            if (cmdRun) begin
                case (cmdState)
                    4'd0: begin //get TA1
                        if (!ByteTransDonePos) begin
                            cmdState  <= cmdState;
                            transTrig <= 1'd1;
                        end
                        else begin
                            cmdState       <= 4'd1;
                            transTrig      <= 1'd0;
                            fromMaster_TA1 <= receiveDat;
                        end
                    end
                    4'd1: begin //get TA2
                        if (!ByteTransDonePos) begin
                            cmdState  <= cmdState;
                            transTrig <= 1'd1;
                        end
                        else begin
                            cmdState       <= 4'd2;
                            transTrig      <= 1'd0;
                            fromMaster_TA2 <= receiveDat;
                        end
                    end
                    4'd2: begin //get ES
                        if (!ByteTransDonePos) begin
                            cmdState  <= cmdState;
                            transTrig <= 1'd1;
                        end
                        else begin
                            cmdState      <= 4'd3;
                            transTrig     <= 1'd0;
                            fromMaster_ES <= receiveDat;
                        end
                    end
                    4'd3: begin //match ta1
                        if ({fromMaster_TA1,fromMaster_TA2,fromMaster_ES} == {TA1,TA2,ES}) begin
                            cmdState <= 4'd4;
                        end
                        else begin
                            nomatch();
                        end
                    end
                    4'd4: begin
                        if ({TA2,TA1}<16'h0090) begin
                            cmdState <= 4'd5;
                        end
                        else begin
                            nomatch();
                        end
                    end
                    4'd5: begin
                        if (!PF) begin
                            cmdDone   <= 1'd1;
                            cmdFailed <= 1'd0;
                            cmdState  <= 4'd0;
                            cmdRun    <= 1'd0;
                        end
                        else begin
                            nomatch();
                        end
                    end
                    default: begin
                        fromMaster_TA1 <= 8'd0;
                        fromMaster_TA2 <= 8'd0;
                        fromMaster_ES  <= 8'd0;
                        cmdState       <= 4'd0;
                        cmdRun         <= 1'd0;
                    end
                endcase
            end
            else begin //idle
                transTrig      <= 1'd0;
                fromMaster_TA1 <= 8'd0;
                fromMaster_TA2 <= 8'd0;
                fromMaster_ES  <= 8'd0;
                cmdState       <= 4'd0;
                cmdRun         <= 1'd0;
            end
        end
    end
    
endmodule
