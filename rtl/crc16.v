// CRC-16/MAXIM
// X16+X15+X2+1
module crc16(clk,
             nRst,
             trig,
             done,
             inDat,
             result);
    
    
    
    input clk;
    input nRst;
    input trig;
    output reg done;
    input [7:0]inDat;
    output reg [15:0]result;

    
    wire trigPos;
    posPulse trig1(.i(trig), .q(trigPos), .clk(clk));
    
    reg [15:0]resultTemp;
    reg [3:0]runStep;
    always@(negedge nRst or posedge clk) begin
        if (!nRst) begin
            done       <= 1'd1;
            runStep    <= 4'hf;
            resultTemp <= 16'd0;
            result     <= 16'd0;
        end
        else if (trigPos && runStep>4'd8)begin
            done       <= 1'd0;
            runStep    <= 4'd0;
            resultTemp <= resultTemp;
            result     <= result;
        end
        else begin
            if (runStep < 4'd8) begin
                done             <= 1'd0;
                runStep          <= runStep+4'd1;
                resultTemp[15]   <= resultTemp[14]^(resultTemp[15]^inDat[runStep]);
                resultTemp[14:3] <= resultTemp[13:2];
                resultTemp[2]    <= resultTemp[1]^(resultTemp[15]^inDat[runStep]);
                resultTemp[1]    <= resultTemp[0];
                resultTemp[0]    <= resultTemp[15]^inDat[runStep];
            end
            else if (runStep == 4'd8) begin //cmd done
                result <= ~{
                resultTemp[0],resultTemp[1],resultTemp[2],resultTemp[3],
                resultTemp[4],resultTemp[5],resultTemp[6],resultTemp[7],
                resultTemp[8],resultTemp[9],resultTemp[10],resultTemp[11],
                resultTemp[12],resultTemp[13],resultTemp[14],resultTemp[15]
                };
                done       <= 1'd0;
                resultTemp <= resultTemp;
                runStep    <= runStep+4'd1;
            end
            else begin //idle
                done       <= 1'd1;
                result     <= result;
                resultTemp <= resultTemp;
                runStep    <= runStep;
            end
            
        end
    end
endmodule
