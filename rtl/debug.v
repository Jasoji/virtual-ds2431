module debug(nRst,
             clk,
             memoryDat,
             optionBytes,
             memoryUpdated,
             tx);
    
    
    
    input nRst;
    input clk;
    input [1023:0]memoryDat;
    input [63:0]optionBytes;
    input memoryUpdated;
    output tx;
    
    // input [1023:0]memoryDat,
    // wire [1151:0]dat;
    wire [1087:0]dat;
    // assign dat = {
    // 8'h55, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00,
    // 8'h00, 8'h00, 8'h55, 8'h00, 8'h00, 8'haa, 8'h00, 8'haa,
    // 8'h78, 8'h14, 8'h48, 8'hcd, 8'h9f, 8'h4c, 8'h6d, 8'h39,
    // 8'h04, 8'hef, 8'h35, 8'hf9, 8'h18, 8'he0, 8'h63, 8'h41,
    // 8'he4, 8'hd6, 8'h0a, 8'ha3, 8'h50, 8'h9b, 8'h9a, 8'h4a,
    // 8'h69, 8'hb8, 8'hfc, 8'h51, 8'h1d, 8'h5f, 8'h1e, 8'hed,
    // 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff,
    // 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff,
    // 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff,
    // 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff,
    // 8'h78, 8'h14, 8'h48, 8'hcd, 8'h9f, 8'h4c, 8'h6d, 8'h39,
    // 8'h04, 8'hef, 8'h35, 8'hf9, 8'h18, 8'he0, 8'h63, 8'h41,
    // 8'he4, 8'hd6, 8'h0a, 8'ha3, 8'h50, 8'h9b, 8'h9a, 8'h4a,
    // 8'h69, 8'hb8, 8'hfc, 8'h51, 8'h1d, 8'h5f, 8'h1e, 8'hed,
    // 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff,
    // 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff,
    // 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff,
    // 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hf0, 8'h00};
    assign dat = {optionBytes, memoryDat};
    
    
    // reg [7:0]datToStore;
    reg writeTrig;
    // wire empty;
    reg [3:0]temp;
    reg [7:0]datIn;
    wire FiFoIsEmpty;
    wire [7:0]datOut;
    
    
    reg readTrig;
    // wire readTrigPos;
    // posPulse memoryUpdated1
    
    fifo a(
    .clock(clk),
    .data(datIn),
    .rdreq(readTrig),
    .sclr(~nRst),
    .wrreq(writeTrig),
    .empty(FiFoIsEmpty),
    // .full(isFull),
    .q(datOut)
    // .usedw(memUsed)
    );
    
    wire memoryUpdatedPos; // set after io module sent or get a byte.
    posPulse memoryUpdated1(.i(memoryUpdated), .q(memoryUpdatedPos), .clk(clk));
    
    wire [16*8:1]hexToChar = { //0123456789ABCDEF
    8'h46,8'h45,8'h44,8'h43,8'h42,8'h41,8'h39,8'h38,
    8'h37,8'h36,8'h35,8'h34,8'h33,8'h32,8'h31,8'h30
    };
    
    
    //
    // write fifo
    //
    reg [1:0]printState;
    reg [4:0]column;
    reg [10:0]index;
    reg pritnRun;
    reg ml;
    always@(negedge nRst or posedge clk)begin
        if (!nRst) begin
            index      <= 11'd0;
            printState <= 2'd0;
            pritnRun   <= 1'd0;
            column     <= 5'd0;
            writeTrig  <= 1'd0;
            ml         <= 1'd0;
        end
        else if (memoryUpdatedPos) begin
            index      <= 11'd4;
            printState <= 2'd0;
            pritnRun   <= 1'd1;
            column     <= 5'd0;
            writeTrig  <= 1'd0;
            ml         <= 1'd0;
        end
        else begin
            if (pritnRun) begin
                if (writeTrig) begin
                    writeTrig <= 1'd0;
                    
                    if (column == 5'd2 || column == 5'd5 || column == 5'd8 || column == 5'd11 || column == 5'd14 || column == 5'd17 || column == 5'd20) begin
                        printState <= 2'd1;
                    end
                    else if (column == 5'd23) begin
                        printState <= 2'd2;
                    end
                    else begin
                        if (index == 11'd1080) begin
                            printState <= 2'd3;
                        end
                        else begin
                            ml <= ~ml;
                            if (!ml) begin
                                index <= index-11'd4;
                            end
                            else begin
                                index <= index+11'd12;
                            end
                            // index   <= index+11'd4;
                            printState <= 2'd0;
                        end
                    end
                end
                else begin
                    if (column<5'd23) begin
                        column <= column+5'd1;
                    end
                    else begin
                        column <= 5'd0;
                    end
                    case (printState)
                        2'd0:begin //print char
                            temp = dat>>index;
                            datIn     <= hexToChar>>{temp,3'd0};
                            writeTrig <= 1'd1;
                        end
                        2'd1:begin //print _
                            datIn     <= 8'h5f;
                            writeTrig <= 1'd1;
                        end
                        2'd2:begin //print enter
                            datIn     <= 8'h0a;
                            writeTrig <= 1'd1;
                        end
                        3'd3:begin //end
                            datIn     <= 8'h0a;
                            writeTrig <= 1'd1;
                            pritnRun  <= 1'd0;
                        end
                    endcase
                end
            end
            else begin
                datIn     <= 8'd10;
                writeTrig <= 1'd0;
            end
        end
    end
    
    
    
    // tx fifo by uart
    reg uartTxTrig;
    wire uartDone;
    uart u(
    .nRst(nRst),
    .clk(clk),
    .baudRate(3'd4),
    .txByte(datOut),
    .txTrig(uartTxTrig),
    .txDone(uartDone),
    .io_tx(tx)
    );
    
    wire uartDonePos;
    posPulse uartDone1(.i(uartDone), .q(uartDonePos), .clk(clk));
    
    reg uartRun;
    always@(negedge nRst or posedge clk) begin
        if (!nRst) begin
            uartTxTrig <= 1'd0;
            uartRun    <= 1'd0;
            readTrig   <= 1'd0;
        end
        else if (!FiFoIsEmpty && !uartRun) begin
            uartRun    <= 1'd1;
            uartTxTrig <= 1'd0;
            readTrig   <= 1'd1;
        end
        else begin
            if (uartRun) begin
                
                if (readTrig) begin
                    readTrig <= 1'd0;
                end
                else begin
                    if (!uartDonePos) begin
                        uartTxTrig <= 1'd1;
                    end
                    else begin
                        readTrig                 <= 1'd1;
                        uartTxTrig               <= 1'd0;
                        if (FiFoIsEmpty) uartRun <= 1'd0;
                        else uartRun             <= 1'd1;
                    end
                end
            end
            else begin //fifo empty
                uartTxTrig <= 1'd0;
                uartRun    <= 1'd0;
                readTrig   <= 1'd0;
            end
        end
    end
    
    
endmodule
    
    //0         1         2
    //012345678901234567890123
    //00 f0 ff ff ff ff ff ff
    //ff ff ff ff ff ff ff ff
    //ff ff ff ff ff ff ff ff
    //ff ff ff ff ff ff ff ff
    //ed 1e 5f 1d 51 fc b8 69
    //4a 9a 9b 50 a3 0a d6 e4
    //41 63 e0 18 f9 35 ef 04
    //39 6d 4c 9f cd 48 14 78
    //ff ff ff ff ff ff ff ff
    //ff ff ff ff ff ff ff ff
    //ff ff ff ff ff ff ff ff
    //ff ff ff ff ff ff ff ff
    //ed 1e 5f 1d 51 fc b8 69
    //4a 9a 9b 50 a3 0a d6 e4
    //41 63 e0 18 f9 35 ef 04
    //39 6d 4c 9f cd 48 14 78
    //aa 00 aa 00 00 55 00 00
