`timescale 1ns/1ns

module virtualDS2431_ROM_MatchRom_tb();
    
    reg rst;
    reg clk = 1;
    reg cmdTrig;
    reg [7:0]receiveDat;
    wire ioTrig;
    wire rx;
    reg ioDone;
    
    wire cmdDone;
    wire cmdFailed;
    
    virtualDS2431_ROM_MatchRom u1(
    .nRst(rst),
    .clk(clk),
    .romID(64'hc5_00_00_2c_40_e4_d4_2d),
    .cmdRunTrig(cmdTrig),
    .receiveDat(receiveDat),
    .transTrig(ioTrig),
    .nRxTx(rx),
    .ByteTransDone(ioDone),
    .cmdDone(cmdDone),
    .cmdFailed(cmdFailed)
    );
    
    always@(*) begin
        #10;
        clk <= ~clk;
    end
    
    task receiveByte;
        input [7:0]d;
        begin
            ioDone = 0;
            #40;
            receiveDat = d;
            #200;
            ioDone = 1;
            #40;
        end
    endtask
    
    initial begin
        rst        = 0;
        cmdTrig    = 0;
        ioDone     = 1;
        receiveDat = 8'hff;
        #200;
        rst = 1;
        
        cmdTrig = 1;
        #40;
        
        receiveByte(8'h2d);
        receiveByte(8'hd4);
        receiveByte(8'he4);
        receiveByte(8'h40);
        receiveByte(8'h2c);
        receiveByte(8'h00);
        receiveByte(8'h00);
        receiveByte(8'hc5);
        receiveByte(8'hc6); //9th
        receiveByte(8'hc7); //10th
        
        
        #1000;
        
        
        cmdTrig = 0;
        #200;
        cmdTrig = 1;
        
        receiveByte(8'h2d);
        receiveByte(8'hd4);
        receiveByte(8'he4);
        receiveByte(8'h40);
        receiveByte(8'h00); //different
        receiveByte(8'h00);
        receiveByte(8'h00);
        receiveByte(8'hc5);
        receiveByte(8'hc5); //9th
        receiveByte(8'hc5); //10th
        #500;
        
        $stop;
        
    end
    
endmodule
