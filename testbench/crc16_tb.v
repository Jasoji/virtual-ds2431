`timescale 1ns/1ns


module crc16_tb();
    
    
    
    
    reg clk = 1'd0;
    always begin
        #10;
        clk <= ~clk;
    end
    
    reg rst;
    reg trig;
    wire done;
    reg[7:0] dat;
    wire[15:0] res;
    
    task cal;
        input[7:0] d;
        begin
            trig = 1'd0;
            dat  = d;
            #10;
            trig = 1'd1;
            #20;
            trig = 1'd0;
            #200;
        end
    endtask
    
    
    initial begin
        
        
        rst = 1'd0;
        trig = 1'd0;
        #33;
        rst = 1'd1;
        #10;

        cal(8'h0f);
        #300;
        
        ////////////////////
        
        rst = 1'd0;
        trig = 1'd0;
        #33;
        rst = 1'd1;
        #10;

        cal(8'h0f);
        #300;
        cal(8'h00);
        #300;
        
        ////////////////////
        
        rst = 1'd0;
        trig = 1'd0;
        #33;
        rst = 1'd1;
        #10;
        
        cal(8'h0f);
        #300;
        cal(8'h20);
        #300;
        cal(8'h00);
        #300;
        cal(8'h56);
        #300;
        cal(8'he7);
        #300;
        cal(8'haa);
        #300;
        cal(8'ha6);
        #300;
        cal(8'h0b);
        #300;
        cal(8'h16);
        #300;
        cal(8'h05);
        #300;
        cal(8'ha0);
        #300;
        
        $stop;
    end
    
    
    
    crc16 u1(
    .clk(clk),
    .nRst(rst),
    .trig(trig),
    .done(done),
    .inDat(dat),
    .result(res)
    );
    
    
endmodule
