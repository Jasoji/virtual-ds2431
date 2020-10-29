`timescale 1ns/1ns

module top_tb();
    
    reg clk = 1'd0;
    always begin
        #10;
        clk <= ~clk;
    end
    
    wire io_bus;
    reg io;
    wire ioo;
    
    // pullup(io_bus);
    assign io_bus = ~ioo&io;
    
    reg rst;
    wire idle;
    
    top t(
    .nRst(rst),
    .clk(clk),
    .IO_i(io_bus),
    .IO_o(ioo),
    .uartTx(),
    .vds1_idle(),
    .sentM()
    );
    
    integer i;
    integer ii;
    
    task reset;
        begin
            #1000;
            io = 0;
            #480000;
            io = 1;
            #30000;
            #100000;
            #280000;
        end
    endtask
    
    task ODreset;
        begin
            #1000;
            io = 0;
            #48200;
            io = 1;
            #3300;
            #12000;
            #39940;
        end
    endtask
    
    reg [7:0]rxByte;
    reg rxDone;
    task dsGetByte;
        input [7:0]dat;
        begin
            #40000;
            rxByte = dat;
            rxDone = 0;
            for(i = 0;i<8;i = i+1) begin
                if (dat[i]) begin
                    io = 0;
                    #2208;
                    io = 1;
                    #61750;
                end
                else begin
                    io = 0;
                    #57420;
                    io = 1;
                    #6500;
                end
            end
            rxDone = 1;
        end
    endtask
    
    task dsGetByte_OD;
        input [7:0]dat;
        begin
            #10000;
            rxByte = dat;
            rxDone = 0;
            for(i = 0;i<8;i = i+1) begin
                if (dat[i]) begin
                    io = 0;
                    #1208;
                    io = 1;
                    #8708;
                end
                else begin
                    io = 0;
                    #7333;
                    io = 1;
                    #2500;
                end
            end
            rxDone = 1;
        end
    endtask
    
    reg [7:0]temp;
    reg [7:0]txByte;
    reg txDone;
    
    task dsSentBytes;
        input [7:0]count;
        begin
            for(ii = 0;ii<count;ii = ii+1) begin
                txDone = 0;
                #25000;
                for(i = 0;i<8;i = i+1) begin
                    temp  = temp>>1;
                    io    = 0;
                    #6250;
                    io           = 1;
                    #20;
                    if (io_bus == 1'b0)  temp[7]   = 0;
                    else temp[7] = 1;
                    #30000;
                    #20750;
                end
                txByte = temp;
                txDone = 1;
                #20;
            end
        end
    endtask
    
    task dsSentBytes_OD;
        input [7:0]count;
        begin
            for(ii = 0;ii<count;ii = ii+1) begin
                txDone = 0;
                #10000;
                for(i = 0;i<8;i = i+1) begin
                    temp  = temp>>1;
                    io    = 0;
                    #1100;
                    io           = 1;
                    #20;
                    if (io_bus == 1'b0)  temp[7]   = 0;
                    else temp[7] = 1;
                    #4000;
                    #4000;
                end
                txByte = temp;
                txDone = 1;
                #20;
            end
        end
    endtask
    
    
    
    initial begin
        rst   = 0;
        #2000;
        rst = 1;
        #20000;
        
        ODreset();
        reset();
        dsGetByte(8'h33);
        dsSentBytes(8);
        
        #100000;
        
        reset();
        dsGetByte(8'h3c);
        dsGetByte_OD(8'hf0);
        dsGetByte_OD(8'h20);
        dsGetByte_OD(8'h00);
        dsSentBytes_OD(32);
        
        #100000;
        
        ODreset();
        dsGetByte_OD(8'hcc);
        dsGetByte_OD(8'hf0);
        dsGetByte_OD(8'h80);
        dsGetByte_OD(8'h00);
        dsSentBytes_OD(8);
        
        #100000;
        
        ODreset();
        dsGetByte_OD(8'hcc);
        dsGetByte_OD(8'hf0);
        dsGetByte_OD(8'h00);
        dsGetByte_OD(8'h00);
        dsSentBytes_OD(32);
        
        #100000;
        
        ODreset();
        dsGetByte_OD(8'hcc);
        dsGetByte_OD(8'hf0);
        dsGetByte_OD(8'h40);
        dsGetByte_OD(8'h00);
        dsSentBytes_OD(32);
        ///////////////////////////////////
        
        #100000;
        
        ODreset();
        dsGetByte_OD(8'hcc);
        dsGetByte_OD(8'h0f);
        dsGetByte_OD(8'h60);
        dsGetByte_OD(8'h00);
        dsGetByte_OD(8'h00);
        dsGetByte_OD(8'h00);
        dsGetByte_OD(8'h00);
        dsGetByte_OD(8'h00);
        dsGetByte_OD(8'h00);
        dsGetByte_OD(8'h00);
        dsGetByte_OD(8'h00);
        dsGetByte_OD(8'h00);
        dsSentBytes_OD(2);
        
        #100000;
        
        ODreset();
        dsGetByte_OD(8'hcc);
        dsGetByte_OD(8'haa);
        dsSentBytes_OD(13);
        
        #100000;
        
        ODreset();
        dsGetByte_OD(8'hcc);
        dsGetByte_OD(8'h55);
        dsGetByte_OD(8'h60);
        dsGetByte_OD(8'h00);
        dsGetByte_OD(8'h07);
        dsSentBytes_OD(4);
        ///////////////////////////////////
        
        #100000;
        
        ODreset();
        dsGetByte_OD(8'hcc);
        dsGetByte_OD(8'h0f);
        dsGetByte_OD(8'h20);
        dsGetByte_OD(8'h00);
        dsGetByte_OD(8'h56);
        dsGetByte_OD(8'he7);
        dsGetByte_OD(8'haa);
        dsGetByte_OD(8'ha6);
        dsGetByte_OD(8'h0b);
        dsGetByte_OD(8'h16);
        dsGetByte_OD(8'h05);
        dsGetByte_OD(8'ha0);
        dsSentBytes_OD(2);
        
        #100000;
        
        ODreset();
        dsGetByte_OD(8'hcc);
        dsGetByte_OD(8'haa);
        dsSentBytes_OD(13);
        
        #100000;
        
        ODreset();
        dsGetByte_OD(8'hcc);
        dsGetByte_OD(8'h55);
        dsGetByte_OD(8'h20);
        dsGetByte_OD(8'h00);
        dsGetByte_OD(8'h07);
        dsSentBytes_OD(4);
        ///////////////////////////////////
        
        #100000;
        
        ODreset();
        dsGetByte_OD(8'hcc);
        dsGetByte_OD(8'h0f);
        dsGetByte_OD(8'h28);
        dsGetByte_OD(8'h00);
        dsGetByte_OD(8'h7b);
        dsGetByte_OD(8'h98);
        dsGetByte_OD(8'h97);
        dsGetByte_OD(8'h94);
        dsGetByte_OD(8'h3a);
        dsGetByte_OD(8'h08);
        dsGetByte_OD(8'h74);
        dsGetByte_OD(8'h21);
        dsSentBytes_OD(2);
        
        #100000;
        
        ODreset();
        dsGetByte_OD(8'hcc);
        dsGetByte_OD(8'haa);
        dsSentBytes_OD(13);
        
        #100000;
        
        ODreset();
        dsGetByte_OD(8'hcc);
        dsGetByte_OD(8'h55);
        dsGetByte_OD(8'h28);
        dsGetByte_OD(8'h00);
        dsGetByte_OD(8'h07);
        dsSentBytes_OD(4);
        
        #100000;
        ///////////////////////////////////
        
        #100000;
        
        ODreset();
        dsGetByte_OD(8'hcc);
        dsGetByte_OD(8'h0f);
        dsGetByte_OD(8'h30);
        dsGetByte_OD(8'h00);
        dsGetByte_OD(8'h41);
        dsGetByte_OD(8'h63);
        dsGetByte_OD(8'he0);
        dsGetByte_OD(8'h18);
        dsGetByte_OD(8'hf9);
        dsGetByte_OD(8'h35);
        dsGetByte_OD(8'hef);
        dsGetByte_OD(8'h04);
        dsSentBytes_OD(2);
        
        #100000;
        
        ODreset();
        dsGetByte_OD(8'hcc);
        dsGetByte_OD(8'haa);
        dsSentBytes_OD(13);
        
        #100000;
        
        ODreset();
        dsGetByte_OD(8'hcc);
        dsGetByte_OD(8'h55);
        dsGetByte_OD(8'h30);
        dsGetByte_OD(8'h00);
        dsGetByte_OD(8'h07);
        dsSentBytes_OD(4);
        
        #100000;
        ///////////////////////////////////
        
        #100000;
        
        ODreset();
        dsGetByte_OD(8'hcc);
        dsGetByte_OD(8'h0f);
        dsGetByte_OD(8'h38);
        dsGetByte_OD(8'h00);
        dsGetByte_OD(8'h39);
        dsGetByte_OD(8'h6d);
        dsGetByte_OD(8'h4c);
        dsGetByte_OD(8'h9f);
        dsGetByte_OD(8'hcd);
        dsGetByte_OD(8'h48);
        dsGetByte_OD(8'h14);
        dsGetByte_OD(8'h78);
        dsSentBytes_OD(2);
        
        #100000;
        
        ODreset();
        dsGetByte_OD(8'hcc);
        dsGetByte_OD(8'haa);
        dsSentBytes_OD(13);
        
        #100000;
        
        ODreset();
        dsGetByte_OD(8'hcc);
        dsGetByte_OD(8'h55);
        dsGetByte_OD(8'h38);
        dsGetByte_OD(8'h00);
        dsGetByte_OD(8'h07);
        dsSentBytes_OD(4);
        
        #100000;
        $stop;
    end
    
endmodule
