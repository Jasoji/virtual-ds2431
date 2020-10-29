module VirtualDS2431_main (nRst,
                           clk,
                           TA1,
                           TA2,
                           AA,
                           PF,
                           odMode,
                           optionBytes,
                           writeToMemory,
                           receiveDat,
                           nBusRst,
                           nODBusRst,
                           ioDone,
                           ioTrig,
                           ioTrig_matchRom,
                           ioTrig_readMemory,
                           ioTrig_writeScratchpad,
                           ioTrig_readRom,
                           ioTrig_readScratchpad,
                           ioTrig_copyScratchpad,
                           funTrig_readRom,
                           funTrig_matchRom,
                           funTrig_readMemory,
                           funTrig_writeScratchpad,
                           funTrig_readScratchpad,
                           funTrig_copyScratchpad,
                           funDone_readRom,
                           funDone_matchRom,
                           funDone_readMemory,
                           funDone_writeScratchpad,
                           funDone_readScratchpad,
                           funDone_copyScratchpad,
                           nRxTx,
                           nRxTx_readRom,
                           nRxTx_matchRom,
                           nRxTx_readMemory,
                           nRxTx_writeScratchpad,
                           nRxTx_readScratchpad,
                           nRxTx_copyScratchpad,
                           sentDat,
                           sentDat_readRom,
                           sentDat_writeScratchpad,
                           sentDat_readMemory,
                           sentDat_readScratchpad,
                           funFailed_matchRom,
                           funFailed_writeScratchpad,
                           funFailed_copyScratchpad,
                           endCmd,
                           idle,
                           memoryUpdated);
    
    input nRst;
    input clk;
    
    output reg [7:0]TA1;
    output reg [7:0]TA2;
    output reg AA;
    output reg PF;
    output reg odMode;
    input [63:0]optionBytes;
    output reg writeToMemory;
    
    input [7:0]receiveDat;
    input nBusRst;
    input nODBusRst;
    input ioDone;
    
    output reg ioTrig;
    input ioTrig_matchRom;
    input ioTrig_readMemory;
    input ioTrig_writeScratchpad;
    input ioTrig_readRom;
    input ioTrig_readScratchpad;
    input ioTrig_copyScratchpad;
    
    output reg funTrig_readRom;
    output reg funTrig_matchRom;
    output reg funTrig_readMemory;
    output reg funTrig_writeScratchpad;
    output reg funTrig_readScratchpad;
    output reg funTrig_copyScratchpad;
    
    input funDone_readRom;
    input funDone_matchRom;
    input funDone_readMemory;
    input funDone_writeScratchpad;
    input funDone_readScratchpad;
    input funDone_copyScratchpad;
    
    output reg nRxTx;
    input nRxTx_readRom;
    input nRxTx_matchRom;
    input nRxTx_readMemory;
    input nRxTx_writeScratchpad;
    input nRxTx_readScratchpad;
    input nRxTx_copyScratchpad;
    
    output reg [7:0]sentDat;
    input [7:0]sentDat_readRom;
    input [7:0]sentDat_writeScratchpad;
    input [7:0]sentDat_readMemory;
    input [7:0]sentDat_readScratchpad;
    
    input funFailed_matchRom;
    input funFailed_writeScratchpad;
    input funFailed_copyScratchpad;
    
    output reg endCmd;
    output idle;
    output memoryUpdated;
    
    wire ioDonePos;
    wire funDone_readRomPos;
    wire funDone_matchRomPos;
    wire funFailed_matchRomPos;
    wire funDone_readMemoryPos;
    wire funDone_writeScratchpadPos;
    wire funFailed_writeScratchpadPos;
    wire funDone_readScratchpadPos;
    wire funDone_copyScratchpadPos;
    wire funFailed_copyScratchpadPos;
    posPulse done1(.i(ioDone), .q(ioDonePos), .clk(clk));
    posPulse done2(.i(funDone_readRom), .q(funDone_readRomPos), .clk(clk));
    posPulse done3(.i(funDone_matchRom), .q(funDone_matchRomPos), .clk(clk));
    posPulse done4(.i(funFailed_matchRom), .q(funFailed_matchRomPos), .clk(clk));
    posPulse done5(.i(funDone_readMemory), .q(funDone_readMemoryPos), .clk(clk));
    posPulse done6(.i(funDone_writeScratchpad), .q(funDone_writeScratchpadPos), .clk(clk));
    posPulse done7(.i(funFailed_writeScratchpad), .q(funFailed_writeScratchpadPos), .clk(clk));
    posPulse done8(.i(funDone_readScratchpad), .q(funDone_readScratchpadPos),.clk(clk));
    posPulse done9(.i(funDone_copyScratchpad), .q(funDone_copyScratchpadPos),.clk(clk));
    posPulse done10(.i(funFailed_copyScratchpad), .q(funFailed_copyScratchpadPos),.clk(clk));
    
    ////////////////////////////////////////////////////////////////////////////////////////
    reg[3:0] flowState;
    parameter FLOW_IDLE            = 4'b0001;
    parameter FLOW_AFTER_PROGRAMED = 4'b0010;
    parameter FLOW_ROM_FUNCTION    = 4'b0100;
    parameter FLOW_MEM_FUNCTION    = 4'b1000;
    
    reg[2:0] funState;
    parameter FUN_GET_CMD           = 3'b001;
    parameter FUN_GET_TA1           = 3'b011;
    parameter FUN_GET_TA2           = 3'b111;
    parameter FUN_WAIT_FOR_CMD_DONE = 3'b010;
    parameter FUN_HANDLE_RESULT     = 3'b100;
    
    reg RC;
    
    
    assign idle          = (flowState == FLOW_IDLE || flowState == FLOW_AFTER_PROGRAMED)?1'b1:1'b0;
    assign memoryUpdated = (flowState == FLOW_AFTER_PROGRAMED)?1'b1:1'b0;
    
    
    ////////////////////////////////////////////////////////////////////////////////////////
    
    
    reg [7:0]sentDat_this;
    reg ioTrig_this;
    reg nRxTx_this;
    reg[7:0] funCmd;
    
    /////////////////////////////////////////////////////////////
    
    
    
    
    task toIDLE;
        begin
            funState     <= FUN_GET_CMD;
            flowState    <= FLOW_IDLE;
            funCmd       <= 8'd0;
            nRxTx_this   <= 1'd1;
            // odMode    <= 1'd0;
            sentDat_this <= 8'hff;
            ioTrig_this  <= 1'd1;
            endCmd       <= 1'd1;
        end
    endtask
    
    task toMemFunctionFlow;
        begin
            funState     <= FUN_GET_CMD;
            flowState    <= FLOW_MEM_FUNCTION;
            funCmd       <= 8'd0;
            nRxTx_this   <= 1'd0;
            sentDat_this <= 8'hff;
            ioTrig_this  <= 1'd1;
        end
    endtask
    
    task resetAllFuntionTrig;
        begin
            funTrig_readRom         <= 1'd0;
            funTrig_matchRom        <= 1'd0;
            funTrig_readMemory      <= 1'd0;
            funTrig_writeScratchpad <= 1'd0;
            funTrig_readScratchpad  <= 1'd0;
            funTrig_copyScratchpad  <= 1'd0;
        end
    endtask
    
    //////////////////////////////////////////////
    always@(negedge nRst or posedge clk) begin
        if (!nRst) begin
            flowState    <= FLOW_IDLE;
            funState     <= FUN_GET_CMD;
            odMode       <= 1'd0;
            nRxTx_this   <= 1'd0;
            ioTrig_this  <= 1'd0;
            sentDat_this <= 8'hff;
            endCmd       <= 1'd0;
            funCmd       <= 8'd0;
            RC           <= 1'd0;
            TA1          <= 8'd0;
            TA2          <= 8'd0;
            resetAllFuntionTrig();
            AA            <= 1'd0;
            PF            <= 1'd1;
            writeToMemory <= 1'd0;
        end
        else begin
            //reset ioTrig
            if (ioTrig_this && !ioDone) begin
                ioTrig_this   <= 1'd0;
                endCmd        <= 1'd0;
                writeToMemory <= 1'd0;
            end
            else begin
                if (!nODBusRst && ioDone) begin //bus reset
                    flowState    <= FLOW_ROM_FUNCTION;
                    funState     <= FUN_GET_CMD;
                    endCmd       <= 1'd1;
                    nRxTx_this   <= 1'd0;
                    sentDat_this <= 8'hff;
                    ioTrig_this  <= 1'd1;
                    resetAllFuntionTrig();
                end
                else if (!nBusRst && ioDone) begin //od bus reset
                    odMode       <= 1'd0;
                    flowState    <= FLOW_ROM_FUNCTION;
                    funState     <= FUN_GET_CMD;
                    endCmd       <= 1'd1;
                    nRxTx_this   <= 1'd0;
                    sentDat_this <= 8'hff;
                    ioTrig_this  <= 1'd1;
                    resetAllFuntionTrig();
                end
                else begin
                    case (flowState)
                        FLOW_IDLE: begin //always return 0xff
                            if (ioDone) begin
                                nRxTx_this   <= 1'd1;
                                sentDat_this <= 8'hff;
                                ioTrig_this  <= 1'd1;
                            end
                        end
                        FLOW_AFTER_PROGRAMED: begin //always return 0xaa
                            if (ioDone) begin
                                nRxTx_this   <= 1'd1;
                                sentDat_this <= 8'haa;
                                ioTrig_this  <= 1'd1;
                            end
                        end
                        FLOW_ROM_FUNCTION: begin //rom function
                            case (funState)
                                FUN_GET_CMD: begin
                                    if (ioDonePos) begin
                                        case (receiveDat)
                                            8'h33: begin //Read ROM
                                                funCmd          <= receiveDat;
                                                RC              <= 1'd0;
                                                funTrig_readRom <= 1'd1;
                                                funState        <= FUN_WAIT_FOR_CMD_DONE;
                                            end
                                            8'h55: begin //Match ROM
                                                funCmd           <= receiveDat;
                                                RC               <= 1'd0;
                                                funTrig_matchRom <= 1'd1;
                                                funState         <= FUN_WAIT_FOR_CMD_DONE;
                                            end
                                            // 8'hf0: begin //Search ROM
                                                //
                                                // NOT SUPPORT YET,
                                                // ╮(￣▽￣)╭ because i don't need this
                                                //
                                            // end
                                            8'hcc: begin //Skip ROM
                                                funCmd   <= receiveDat;
                                                RC       <= 1'd0;
                                                funState <= FUN_HANDLE_RESULT;
                                            end
                                            8'ha5: begin //Resume
                                                funCmd   <= receiveDat;
                                                funState <= FUN_HANDLE_RESULT;
                                            end
                                            8'h3c: begin //OD Skip ROM
                                                funCmd   <= receiveDat;
                                                RC       <= 1'd0;
                                                odMode   <= 1'd1;
                                                funState <= FUN_HANDLE_RESULT;
                                            end
                                            8'h69: begin //OD Match ROM
                                                funCmd           <= receiveDat;
                                                RC               <= 1'd0;
                                                odMode           <= 1'd1;
                                                funTrig_matchRom <= 1'd1;
                                                funState         <= FUN_WAIT_FOR_CMD_DONE;
                                            end
                                            default: begin
                                                resetAllFuntionTrig();
                                                toIDLE();
                                            end
                                        endcase
                                    end
                                end
                                FUN_WAIT_FOR_CMD_DONE: begin
                                    case (funCmd)
                                        8'h33: begin //Read ROM
                                            if (funDone_readRomPos) begin
                                                funTrig_readRom <= 1'd0;
                                                funState        <= FUN_HANDLE_RESULT;
                                            end
                                        end
                                        8'h55: begin //Match ROM
                                            if (funDone_matchRomPos || funFailed_matchRomPos) begin
                                                funTrig_matchRom <= 1'd0;
                                                funState         <= FUN_HANDLE_RESULT;
                                            end
                                        end
                                        // 8'hf0: begin //Search ROM
                                        // end
                                        // 8'hcc: begin //Skip ROM
                                        // end
                                        // 8'ha5: begin //Resume
                                        // end
                                        // 8'h3c: begin //OD Skip ROM
                                        // end
                                        8'h69: begin //OD Match ROM
                                            if (funDone_matchRomPos || funFailed_matchRomPos) begin
                                                funTrig_matchRom <= 1'd0;
                                                funState         <= FUN_HANDLE_RESULT;
                                            end
                                        end
                                        default: begin
                                            //reset all function trig
                                            resetAllFuntionTrig();
                                            toIDLE();
                                        end
                                    endcase
                                end
                                FUN_HANDLE_RESULT: begin
                                    resetAllFuntionTrig();
                                    case (funCmd)
                                        8'h33: begin //Read ROM
                                            toMemFunctionFlow();
                                        end
                                        8'h55: begin //Match ROM
                                            if (funDone_matchRom) begin
                                                toMemFunctionFlow();
                                                RC <= 1'd1;
                                            end
                                            else if (funFailed_matchRom) begin
                                                toIDLE();
                                            end
                                        end
                                        // 8'hf0: begin //Search ROM
                                        // end
                                        8'hcc: begin //Skip ROM
                                            toMemFunctionFlow();
                                        end
                                        8'ha5: begin //Resume
                                            if (RC) begin
                                                toMemFunctionFlow();
                                            end
                                            else begin
                                                toIDLE();
                                            end
                                        end
                                        8'h3c: begin //OD Skip ROM
                                            odMode <= 1'd1;
                                            toMemFunctionFlow();
                                        end
                                        8'h69: begin //OD Match ROM
                                            if (funDone_matchRom) begin
                                                toMemFunctionFlow();
                                                RC <= 1'd1;
                                            end
                                            else if (funFailed_matchRom) begin
                                                toIDLE();
                                                odMode <= 1'd0;
                                            end
                                        end
                                        default: begin
                                            //reset all function trig
                                            //resetAllFuntionTrig();
                                            toIDLE();
                                        end
                                    endcase
                                end
                                default: begin
                                    resetAllFuntionTrig();
                                    toIDLE();
                                end
                            endcase
                        end
                        FLOW_MEM_FUNCTION: begin //mem function
                            case (funState)
                                FUN_GET_CMD: begin
                                    if (ioDonePos) begin
                                        case (receiveDat)
                                            8'h0f: begin //write scratchpad
                                                funCmd      <= receiveDat;
                                                funState    <= FUN_GET_TA1;
                                                ioTrig_this <= 1'd1;
                                            end
                                            8'haa: begin //read scratchpad
                                                funCmd                 <= receiveDat;
                                                funState               <= FUN_WAIT_FOR_CMD_DONE;
                                                funTrig_readScratchpad <= 1'd1;
                                            end
                                            8'h55: begin //copy scratchpad
                                                writeToMemory          <= 1'd0;
                                                funCmd                 <= receiveDat;
                                                funState               <= FUN_WAIT_FOR_CMD_DONE;
                                                funTrig_copyScratchpad <= 1'd1;
                                            end
                                            8'hf0: begin //read memory
                                                funCmd      <= receiveDat;
                                                funState    <= FUN_GET_TA1;
                                                ioTrig_this <= 1'd1;
                                            end
                                            default: begin
                                                resetAllFuntionTrig();
                                                toIDLE();
                                            end
                                        endcase
                                    end
                                end
                                FUN_GET_TA1: begin //for read, write memory use
                                    if (ioDonePos) begin
                                        funState    <= FUN_GET_TA2;
                                        TA1         <= receiveDat;
                                        ioTrig_this <= 1'd1;
                                    end
                                end
                                FUN_GET_TA2: begin //for read, write memory use
                                    if (ioDonePos) begin
                                        funState <= FUN_WAIT_FOR_CMD_DONE;
                                        TA2      <= receiveDat;
                                        case (funCmd)
                                            8'h0f: funTrig_writeScratchpad <= 1'd1; //write scratchpad
                                            8'hf0: funTrig_readMemory      <= 1'd1; //read memory
                                            default:begin
                                                resetAllFuntionTrig();
                                                toIDLE();
                                            end
                                        endcase
                                    end
                                end
                                FUN_WAIT_FOR_CMD_DONE: begin
                                    case (funCmd)
                                        8'h0f: begin //write scratchpad
                                            if (funDone_writeScratchpadPos || funFailed_writeScratchpadPos) begin
                                                funTrig_writeScratchpad <= 1'd0;
                                                funState                <= FUN_HANDLE_RESULT;
                                            end
                                            else begin
                                                PF <= 1'd1;
                                                AA <= 1'd0;
                                            end
                                        end
                                        8'haa: begin //read scratchpad
                                            if (funDone_readScratchpadPos) begin
                                                funTrig_readScratchpad <= 1'd0;
                                                funState               <= FUN_HANDLE_RESULT;
                                            end
                                        end
                                        8'h55: begin //copy scratchpad
                                            if (funDone_copyScratchpadPos || funFailed_copyScratchpadPos) begin
                                                funTrig_copyScratchpad <= 1'd0;
                                                funState               <= FUN_HANDLE_RESULT;
                                            end
                                        end
                                        8'hf0: begin //read memory
                                            if (funDone_readMemoryPos) begin
                                                funTrig_readMemory <= 1'd0;
                                                funState           <= FUN_HANDLE_RESULT;
                                            end
                                        end
                                        default: begin
                                            resetAllFuntionTrig();
                                            toIDLE();
                                        end
                                    endcase
                                end
                                FUN_HANDLE_RESULT: begin
                                    resetAllFuntionTrig();
                                    case (funCmd)
                                        8'h0f: begin //write scratchpad
                                            if (funDone_writeScratchpad) begin
                                                PF <= 1'd0;
                                            end
                                            else begin
                                                PF <= 1'd1;
                                            end
                                            toIDLE();
                                        end
                                        8'haa: begin //read scratchpad
                                            toIDLE();
                                        end
                                        8'h55: begin //copy scratchpad
                                            if (funDone_copyScratchpad) begin
                                                if (optionBytes[39:32] == 8'haa || optionBytes[39:32] == 8'h55) begin
                                                    writeToMemory <= 1'd0;
                                                    toIDLE();
                                                end
                                                else begin
                                                    writeToMemory <= 1'd1;
                                                    funState      <= FUN_GET_CMD;
                                                    flowState     <= FLOW_AFTER_PROGRAMED;
                                                    funCmd        <= 8'd0;
                                                    nRxTx_this    <= 1'd1;
                                                    // odMode     <= 1'd0;
                                                    sentDat_this  <= 8'haa;
                                                    ioTrig_this   <= 1'd1;
                                                    endCmd        <= 1'd1;
                                                    AA            <= 1'd1;
                                                end
                                            end
                                            else begin
                                                toIDLE();
                                            end
                                        end
                                        8'hf0: begin //read memory
                                            toIDLE();
                                        end
                                        default: begin
                                            // resetAllFuntionTrig();
                                            toIDLE();
                                        end
                                    endcase
                                end
                                default: begin
                                    resetAllFuntionTrig();
                                    toIDLE();
                                end
                            endcase
                        end
                        default: begin
                            resetAllFuntionTrig();
                            toIDLE();
                        end
                    endcase
                    
                end
            end
        end
    end
    
    
    
    /////////////////////io module control signal MUX///////////////////////////
    always@(*) begin
        if (flowState == FLOW_ROM_FUNCTION && funState == FUN_WAIT_FOR_CMD_DONE) begin
            case (funCmd)
                8'h33: begin //Read ROM
                    sentDat <= sentDat_readRom;
                    nRxTx   <= nRxTx_readRom;
                    ioTrig  <= ioTrig_readRom;
                end
                8'h55: begin //Match ROM
                    sentDat <= 8'hff;
                    nRxTx   <= nRxTx_matchRom;
                    ioTrig  <= ioTrig_matchRom;
                end
                // 8'hf0: begin //Search ROM
                // end
                // 8'hcc: begin //Skip ROM
                // end
                // 8'ha5: begin //Resume
                // end
                // 8'h3c: begin //OD Skip ROM
                // end
                8'h69: begin //OD Match ROM
                    sentDat <= 8'hff;
                    nRxTx   <= nRxTx_matchRom;
                    ioTrig  <= ioTrig_matchRom;
                end
                default: begin
                    sentDat <= sentDat_this;
                    ioTrig  <= ioTrig_this;
                    nRxTx   <= nRxTx_this;
                end
            endcase
        end
        else if (flowState == FLOW_MEM_FUNCTION && funState == FUN_WAIT_FOR_CMD_DONE) begin
            case (funCmd)
                8'h0f: begin //write scratchpad
                    sentDat <= sentDat_writeScratchpad;
                    ioTrig  <= ioTrig_writeScratchpad;
                    nRxTx   <= nRxTx_writeScratchpad;
                end
                8'haa: begin //read scratchpad
                    sentDat <= sentDat_readScratchpad;
                    ioTrig  <= ioTrig_readScratchpad;
                    nRxTx   <= nRxTx_readScratchpad;
                end
                8'h55: begin //copy scratchpad
                    sentDat <= 8'hff;
                    ioTrig  <= ioTrig_copyScratchpad;
                    nRxTx   <= nRxTx_copyScratchpad;
                end
                8'hf0: begin //read memory
                    sentDat <= sentDat_readMemory;
                    ioTrig  <= ioTrig_readMemory;
                    nRxTx   <= nRxTx_readMemory;
                end
                default: begin
                    sentDat <= sentDat_this;
                    ioTrig  <= ioTrig_this;
                    nRxTx   <= nRxTx_this;
                end
            endcase
        end
        else begin
            sentDat <= sentDat_this;
            ioTrig  <= ioTrig_this;
            nRxTx   <= nRxTx_this;
        end
    end
    
    
endmodule
    
