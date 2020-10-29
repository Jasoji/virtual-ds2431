module VirtualDS2431_IO(nRst,
                        clk,
                        IO_i,
                        IO_o,
                        odMode,     // run im od mode?
                        nRxTx,      // 0:receive mode; 1:sent mode;
                        trig,       // sent or get a byte
                        sentDat,
                        receiveDat,
                        nBusRst,    // get a reset signal
                        nODBusRst,  // get a od reset signal
                        done);      // job finish
    
    
    input nRst;
    input clk;
    input IO_i;
    output reg IO_o;
    input odMode;               // run im od mode?
    input nRxTx;                // 0:receive mode; 1:sent mode;
    input trig;                 // sent or get a byte
    input [7:0]sentDat;
    output reg [7:0]receiveDat;
    output reg nBusRst;         // get a reset signal
    output reg nODBusRst;       // get a od reset signal
    output reg done;           // job finish
    
    // rx mode :
    // 1: 2.25us    0: 57.5us
    // OD 1: 1.2us     0: 7.4us
    
    // tx mode:
    // 1: 6.25us    0: 33.25us
    // OD 1: 1.2us     0: 3.2us
    
    // reset:
    // OD: 48.2us   480us
    
    
    //
    // clock div, 50MHz -> 1us cycle
    //
    reg[4:0] usClockDivCnt;
    reg usClk;
    always@(posedge clk or negedge nRst) begin
        if (!nRst) begin
            usClockDivCnt <= 5'd0;
            usClk         <= 1'd0;
        end
        else begin
            if (usClockDivCnt < 5'd24) begin
                usClockDivCnt <= usClockDivCnt + 5'd1;
            end
            else begin
                usClockDivCnt <= 5'd0;
                usClk         <= ~usClk;
            end
        end
    end
    
    //
    // bus low or high timer
    //
    reg[9:0] pullDownTime;
    reg[9:0] pullUpTime;
    wire IOPos;
    wire IONeg;
    posPulse io1(.i(IO_i&&IO_o), .q(IOPos), .clk(clk));
    negPulse io2(.i(IO_i&&IO_o), .q(IONeg), .clk(clk));
    always@(negedge nRst or posedge IONeg or posedge IOPos or posedge usClk) begin
        if (!nRst) begin
            pullDownTime <= 10'd0;
            pullUpTime   <= 10'd0;
        end
        else if (IONeg) begin
            pullDownTime <= 10'd0;
            pullUpTime   <= pullUpTime;
        end
            else if (IOPos) begin
            pullUpTime   <= 10'd0;
            pullDownTime <= pullDownTime;
            end
        else begin
            if (!IO_i || !IO_o) begin
                if (pullDownTime < 10'd1023) begin
                    pullDownTime <= pullDownTime +10'd1;
                end
                else begin
                    pullDownTime <= pullDownTime;
                end
            end
            else begin
                if (pullUpTime < 10'd1023) begin
                    pullUpTime <= pullUpTime +10'd1;
                end
                else begin
                    pullUpTime <= pullUpTime;
                end
            end
        end
    end
    
    //
    // bus reset signal monitor
    //
    wire trigPos;
    posPulse trig1(.i(trig), .q(trigPos), .clk(clk));
    always@(negedge nRst or posedge trigPos or posedge IOPos/*posedge clk*/) begin
        if (!nRst) begin
            nBusRst   <= 1'd1;
            nODBusRst <= 1'd1;
        end
        else if (trigPos) begin
            nBusRst   <= 1'd1;
            nODBusRst <= 1'd1;
        end
        else begin
            if (odMode) begin
                if (10'd40 < pullDownTime && pullDownTime < 10'd90) begin
                    nODBusRst <= 1'd0;
                    nBusRst   <= 1'd1;
                end
                else if (10'd400 < pullDownTime) begin
                    nODBusRst <= 1'd1;
                    nBusRst   <= 1'd0;
                end
                else begin
                    nODBusRst <= nODBusRst;
                    nBusRst   <= nBusRst;
                end
            end
            else begin
                if (10'd400 < pullDownTime) begin
                    nBusRst   <= 1'd0;
                    nODBusRst <= 1'd1;
                end
                else begin
                    nODBusRst <= nODBusRst;
                    nBusRst   <= nBusRst;
                end
            end
        end
    end
    
    
    //
    // begin or stop to trans or recevice a byte
    //
    reg[3:0] byteState;
    reg ioRun;
    reg resetAckDone;
    always@(negedge nRst or posedge clk) begin
        if (!nRst) begin
            done  <= 1'd0;
            ioRun <= 1'd0;
        end
        else begin
            if (trigPos) begin // begin to sent or receive
                ioRun <= 1'd1;
                done  <= 1'd0;
            end
            else if (resetAckDone || byteState > 4'd7) begin // sent or receive done, or bus reset
                ioRun <= 1'd0;
                done  <= 1'd1;
            end
            else begin
                ioRun <= ioRun;
                done  <= done;
            end
        end
    end
    
    
    
    //
    // io control
    //
    reg[3:0] bitState;
    wire nODBusRstNeg;
    wire nBusRstNeg;
    negPulse nODBusRst1(.i(nODBusRst), .q(nODBusRstNeg), .clk(clk));
    negPulse nBusRst1(.i(nBusRst), .q(nBusRstNeg), .clk(clk));
    always@(negedge nRst or posedge clk) begin
        if (!nRst) begin
            byteState    <= 4'hf;
            bitState     <= 4'd0;
            IO_o         <= 1'd1;
            receiveDat   <= 8'd0;
            resetAckDone <= 1'd0;
        end
        else if (trigPos || nODBusRstNeg || nBusRstNeg) begin
            byteState    <= 4'd0;
            bitState     <= 4'b0001;
            IO_o         <= 1'd1;
            receiveDat   <= 8'd0;
            resetAckDone <= 1'd0;
        end
        else begin
            if (!nODBusRst && !resetAckDone) begin
                //sent od reset ack
                case (bitState)
                    4'b0001: begin
                        resetAckDone <= 1'd0;
                        if (pullUpTime>3) begin
                            bitState <= 4'b0010;
                            IO_o     <= 1'd0;
                        end
                        else begin
                            bitState <= bitState;
                            IO_o     <= 1'd1;
                        end
                    end
                    4'b0010: begin
                        bitState <= 4'b0100;
                    end
                    4'b0100: begin
                        resetAckDone <= 1'd0;
                        if (pullDownTime>11) begin
                            IO_o     <= 1'd1;
                            bitState <= 4'b1000;
                        end
                        else begin
                            IO_o     <= 1'd0;
                            bitState <= bitState;
                        end
                    end
                    4'b1000: begin
                        bitState     <= 4'b0001;
                        resetAckDone <= 1'd1;
                    end
                    default: begin
                        bitState     <= 4'b0001;
                        resetAckDone <= 1'd1;
                    end
                endcase
            end
            else if (!nBusRst && !resetAckDone) begin
                //sent reset ack
                case (bitState)
                    4'b0001: begin
                        resetAckDone <= 1'd0;
                        if (pullUpTime>27) begin
                            bitState <= 4'b0010;
                            IO_o     <= 1'd0;
                        end
                        else begin
                            bitState <= bitState;
                            IO_o     <= 1'd1;
                        end
                    end
                    4'b0010: begin
                        bitState <= 4'b0100;
                    end
                    4'b0100: begin
                        resetAckDone <= 1'd0;
                        if (pullDownTime>108) begin
                            IO_o     <= 1'd1;
                            bitState <= 4'b1000;
                        end
                        else begin
                            IO_o     <= 1'd0;
                            bitState <= bitState;
                        end
                    end
                    4'b1000: begin
                        bitState     <= 4'b0001;
                        resetAckDone <= 1'd1;
                    end
                    default: begin
                        bitState     <= 4'b0001;
                        resetAckDone <= 1'd1;
                    end
                endcase
            end
            else begin
                if (ioRun) begin
                    if (byteState<4'd8)begin
                        case (bitState)
                            4'b0001: begin //wait for master pull down bus
                                // if (nRxTx) begin
                                    if (IONeg) bitState <= 4'b0010;
                                // end
                            end
                            4'b0010: begin //rxMode: wait for bus release;  txMode: DS pull down bus
                                if (nRxTx)begin
                                    IO_o     <= 1'd0;
                                    bitState <= 4'b0100;
                                end
                                else if (!nRxTx) begin
                                    if (IOPos) bitState <= 4'b1000;
                                end
                            end
                            4'b0100: begin //txMode only, DS continue pull down bus
                                if (nRxTx)begin
                                    if (odMode) begin //OD speed
                                        if (sentDat[byteState] && pullDownTime>0) begin
                                            IO_o     <= 1'd1;
                                            bitState <= 4'b1000;
                                        end
                                        else if (!sentDat[byteState] && pullDownTime>3) begin
                                            IO_o     <= 1'd1;
                                            bitState <= 4'b1000;
                                        end
                                        else begin
                                            IO_o     <= 1'd0;
                                            bitState <= bitState;
                                        end
                                    end
                                    else begin //normal speed
                                        if (sentDat[byteState] && pullDownTime>4) begin
                                            IO_o     <= 1'd1;
                                            bitState <= 4'b1000;
                                        end
                                        else if (!sentDat[byteState] && pullDownTime>33) begin
                                            IO_o     <= 1'd1;
                                            bitState <= 4'b1000;
                                        end
                                        else begin
                                            IO_o     <= 1'd0;
                                            bitState <= bitState;
                                        end
                                    end
                                end
                            end
                            4'b1000: begin //prepare for next bit
                                if (odMode) begin //OD speed
                                    if (pullDownTime < 10'd4) receiveDat[byteState] <= 1'd1;
                                    else receiveDat[byteState]                      <= 1'd0;
                                end
                                else begin //normal speed
                                    if (pullDownTime < 10'd20) receiveDat[byteState] <= 1'd1;
                                    else receiveDat[byteState]                       <= 1'd0;
                                end
                                
                                // if (nRxTx) begin
                                    bitState  <= 4'b0001;
                                    byteState <= byteState+4'd1;
                                // end
                            end
                            default: begin
                                IO_o         <= 1'd1;
                                receiveDat   <= receiveDat;
                                bitState     <= 4'b0001;
                                byteState    <= 4'hf;
                                resetAckDone <= resetAckDone;
                                // byteState <= byteState + 4'd1;
                                // bitState  <= 4'b0001;
                            end
                        endcase
                    end
                end
            end
        end
        
    end
    
    
endmodule
    
    
