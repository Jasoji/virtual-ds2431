module uart(nRst,
            clk,
            baudRate,
            txByte,
            txTrig,
            txDone,
            io_tx);
    
    input nRst;
    input clk;
    input[2:0] baudRate;
    input[7:0] txByte;
    input txTrig;
    output reg txDone;
    output reg io_tx;
    
    
    // baudRate = ?
    // 0:9600
    // 1:19200
    // 2:38400
    // 3:57600
    // 4:115200
    reg[12:0] clkCount;
    reg[12:0] clkCountTo;
    reg baudClk;
    always@(*) begin
        case(baudRate)
            3'd0: clkCountTo    <= 13'd5207; //9600
            3'd1: clkCountTo    <= 13'd2603; //19200
            3'd2: clkCountTo    <= 13'd1301; //38400
            3'd3: clkCountTo    <= 13'd867;  //57600
            3'd4: clkCountTo    <= 13'd433;  //115200
            default: clkCountTo <= 13'd5207;  //default 9600
        endcase
    end
    
    always@(negedge nRst or posedge clk) begin
        if (!nRst) begin
            baudClk  <= 1'd0;
            clkCount <= 13'd0;
        end
        else begin
            if (clkCount < clkCountTo) begin
                clkCount <= clkCount+13'd1;
                baudClk  <= 1'd0;
            end
            else begin
                clkCount <= 13'd0;
                baudClk  <= 1'd1;
            end
        end
    end
    
    
    //begin to trans a bytes
    
    wire txTrigPos;
    posPulse txTrig1(.i(txTrig), .q(txTrigPos), .clk(clk));
    
    reg txEn;
    
    reg[3:0] txState;
    reg[7:0] txByteLock;
    always@(negedge nRst or posedge clk) begin
        if (!nRst) begin
            txState    <= 4'd0;
            io_tx      <= 1'd1;
            txDone     <= 1'd1;
            txByteLock <= 8'd0;
        end
        else if (txTrigPos) begin
            txEn   <= 1'd1;
            txDone <= 1'd0;
        end
        else begin
            if (txEn) begin
                if (baudClk) begin
                    case(txState)
                        4'd0: begin //pull down
                            io_tx      <= 1'd0;
                            txByteLock <= txByte;
                            txState    <= 4'd1;
                        end
                        4'd1: begin //sent 8 bits
                            io_tx   <= txByteLock[0];
                            txState <= 4'd2;
                        end
                        4'd2: begin
                            io_tx   <= txByteLock[1];
                            txState <= 4'd3;
                        end
                        4'd3: begin
                            io_tx   <= txByteLock[2];
                            txState <= 4'd4;
                        end
                        4'd4: begin
                            io_tx   <= txByteLock[3];
                            txState <= 4'd5;
                        end
                        4'd5: begin
                            io_tx   <= txByteLock[4];
                            txState <= 4'd6;
                        end
                        4'd6: begin
                            io_tx   <= txByteLock[5];
                            txState <= 4'd7;
                        end
                        4'd7: begin
                            io_tx   <= txByteLock[6];
                            txState <= 4'd8;
                        end
                        4'd8: begin
                            io_tx   <= txByteLock[7];
                            txState <= 4'd9;
                        end
                        4'd9: begin //sent stop bits
                            io_tx   <= 1'd1;
                            txState <= 4'd10;
                        end
                        default: begin
                            io_tx   <= 1'd1;
                            txDone  <= 1'd1;
                            txState <= 4'd0;
                            txEn    <= 1'd0;
                        end
                    endcase
                end
            end
            else begin
                txState <= 4'd0;
                txDone  <= 1'd1;
                io_tx   <= 1'd1;
                txEn    <= 1'd0;
            end
        end
    end
    
endmodule
