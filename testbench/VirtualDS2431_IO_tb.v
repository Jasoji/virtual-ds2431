`timescale 1ns/1ns


module VirtualDS2431_IO_tb();
    
    reg clk = 1'd0;
    always begin
        #10;
        clk <= ~clk;
    end
    
    reg nRst;
    reg io;
    wire io_o;
    wire io_bus;
    wire nBusRst;
    wire nODBusRst;
    reg odMode;
    reg nRxTx;
    reg trig;
    // reg [7:0]sentDat;
    wire [7:0]receDat;
    wire done;
    
    
    task dsSentByte;
        begin
            #1000;
            
            io = 0;
            #6250;
            io = 1;
            #50750;
            
            io = 0;
            #6250;
            io = 1;
            #50750;
            
            io = 0;
            #6250;
            io = 1;
            #50750;
            
            io = 0;
            #6250;
            io = 1;
            #50750;
            
            io = 0;
            #6250;
            io = 1;
            #50750;
            
            io = 0;
            #6250;
            io = 1;
            #50750;
            
            io = 0;
            #6250;
            io = 1;
            #50750;
            
            io = 0;
            #6250;
            io = 1;
            #50750;
            //9th bit
            io = 0;
            #6250;
            io = 1;
            #50750;
            
        end
    endtask
    
    //0x33
    task dsReadByte;
        begin
            #1000;
            
            io = 0;
            #2208;
            io = 1;
            #61830;
            
            io = 0;
            #2167;
            io = 1;
            #76179;
            
            io = 0;
            #57420;
            io = 1;
            #6500;
            
            io = 0;
            #57420;
            io = 1;
            #6500;
            
            io = 0;
            #2167;
            io = 1;
            #61790;
            
            io = 0;
            #2167;
            io = 1;
            #61750;
            
            io = 0;
            #57420;
            io = 1;
            #6542;
            
            io = 0;
            #57420;
            io = 1;
            #14170;
        end
    endtask
    
    task ODdsSentByte;
        begin
            #1000;
            
            io = 0;
            #1000;
            io = 1;
            #8000;
            
            io = 0;
            #1208;
            io = 1;
            #7792;
            
            io = 0;
            #1000;
            io = 1;
            #8000;
            
            io = 0;
            #800;
            io = 1;
            #8200;
            
            io = 0;
            #1000;
            io = 1;
            #8000;
            
            io = 0;
            #1000;
            io = 1;
            #8000;
            
            io = 0;
            #1000;
            io = 1;
            #8000;
            
            io = 0;
            #1000;
            io = 1;
            #8000;
            //9th bit
            io = 0;
            #1000;
            io = 1;
            #8000;
        end
    endtask
    
    //0xcc
    task ODdsReadByte;
        begin
            #1000;
            
            io = 0;
            #7458;
            io = 1;
            #2500;
            
            io = 0;
            #7333;
            io = 1;
            #2500;
            
            io = 0;
            #1208;
            io = 1;
            #8708;
            
            io = 0;
            #1208;
            io = 1;
            #8625;
            
            io = 0;
            #7458;
            io = 1;
            #2500;
            
            io = 0;
            #7333;
            io = 1;
            #3708;
            
            io = 0;
            #1208;
            io = 1;
            #8708;
            
            io = 0;
            #1208;
            io = 1;
            #10000;
            
        end
    endtask
    
    task reset;
        begin
            #1000;
            io = 0;
            #480000;
            io = 1;
            #280000;
        end
    endtask
    
    task ODreset;
        begin
            #1000;
            io = 0;
            #48200;
            io = 1;
            #39940;
        end
    endtask
    
    initial begin
        io     = 1;
        odMode = 0;
        nRxTx  = 0;
        trig   = 0;
        nRst   = 0;
        #100000;
        nRst = 1;
        #5000;
        //ds sent byte 0xa5
        nRxTx  = 1;
        trig   = 1;
        odMode = 0;
        dsSentByte();
        trig = 0;
        // nRst = 0;
        // #100000;
        // nRst = 1;
        #5000;
        //ds sent byte - OD 0xa5
        nRxTx  = 1;
        trig   = 1;
        odMode = 1;
        ODdsSentByte();
        trig = 0;
        // nRst = 0;
        // #100000;
        // nRst = 1;
        #5000;
        //OD reset - no od mode
        nRxTx  = 1;
        odMode = 0;
        trig   = 1;
        ODreset();
        trig = 0;
        // nRst = 0;
        // #100000;
        // nRst = 1;
        #5000;
        //OD reset - od mode
        nRxTx  = 1;
        odMode = 1;
        trig   = 1;
        ODreset();
        trig = 0;
        // nRst = 0;
        // #100000;
        // nRst = 1;
        #5000;
        //reset - no od mode
        nRxTx  = 1;
        odMode = 0;
        trig   = 1;
        reset();
        trig = 0;
        // nRst = 0;
        // #100000;
        // nRst = 1;
        #5000;
        //reset - od mode
        nRxTx  = 1;
        odMode = 1;
        trig   = 1;
        reset();
        trig = 0;
        // nRst = 0;
        // #100000;
        // nRst = 1;
        #5000;
        //ds read - OD 0xcc
        nRxTx  = 0;
        odMode = 1;
        trig   = 1;
        ODdsReadByte();
        trig = 0;
        // nRst = 0;
        // #100000;
        // nRst = 1;
        #5000;
        //ds read byte 0x33
        nRxTx  = 0;
        odMode = 0;
        trig   = 1;
        dsReadByte();
        trig = 0;
        // nRst = 0;
        // #100000;
        // nRst = 1;
        #5000;
        ////// Abort transmission rx od
        nRxTx  = 0;
        odMode = 1;
        trig   = 1;
        #1000;
        
        io = 0;
        #7458;
        io = 1;
        #2500;
        
        io = 0;
        #7333;
        io = 1;
        #2500;
        
        io = 0;
        #1208;
        io = 1;
        #8708;
        
        ODreset();
        #10000;
        
        trig = 0;
        // nRst = 0;
        // #100000;
        // nRst = 1;
        #5000;
        ////// Abort transmission 2 tx no od
        nRxTx  = 1;
        odMode = 0;
        trig   = 1;
        #1000;
        
        io = 0;
        #6250;
        io = 1;
        #50750;
        
        io = 0;
        #6250;
        io = 1;
        #50750;
        
        io = 0;
        #6250;
        io = 1;
        #50750;
        
        reset();
        #10000;
        
        trig = 0;
        
        $stop;
        
    end
    
    
    assign io_bus = io&io_o;
    
    VirtualDS2431_IO u1(
    .nRst(nRst),
    .clk(clk),
    .IO_i(io_bus),
    .IO_o(io_o),
    
    .nBusRst(nBusRst),
    .nODBusRst(nODBusRst),
    
    .odMode(odMode),
    .nRxTx(nRxTx),
    .trig(trig),
    
    .sentDat(8'ha5),
    .receiveDat(receDat),
    .done(done)
    );
    
endmodule
