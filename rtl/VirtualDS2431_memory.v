module VirtualDS2431_memory(nRst,
                            clk,
                            TA1,
                            Scratchpad,
                            writeToMemory,
                            memory,
                            optionBytes,
                            romID,
                            rowDat);
    
    
    input nRst;
    input clk;
    input [7:0]TA1;
    input [63:0]Scratchpad;
    input writeToMemory;
    output reg [1023:0]memory;
    output reg [63:0]optionBytes;
    output [63:0]romID;
    output reg [63:0]rowDat;
    
    
    
    assign romID = 64'hc500_002c_40e4_d42d;
    
    always@(negedge nRst or posedge writeToMemory) begin
        if (!nRst) begin
            memory <= {
            64'h78_14_48_cd_9f_4c_6d_39,  // 78
            64'h04_ef_35_f9_18_e0_63_41,  // 70
            64'he4_d6_0a_a3_50_9b_9a_4a,  // 68
            64'h69_b8_fc_51_1d_5f_1e_ed,  // 60
            64'hff_ff_ff_ff_ff_ff_ff_ff,  // 58
            64'hff_ff_ff_ff_ff_ff_ff_ff,  // 50
            64'hff_ff_ff_ff_ff_ff_ff_ff,  // 48
            64'hff_ff_ff_ff_ff_ff_ff_ff,  // 40
            64'h78_14_48_cd_9f_4c_6d_39,  // 38
            64'h04_ef_35_f9_18_e0_63_41,  // 30
            64'he4_d6_0a_a3_50_9b_9a_4a,  // 28
            64'h69_b8_fc_51_1d_5f_1e_ed,  // 20
            64'hff_ff_ff_ff_ff_ff_ff_ff,  // 18
            64'hff_ff_ff_ff_ff_ff_ff_ff,  // 10
            64'hff_ff_ff_ff_ff_ff_ff_ff,  // 08
            64'hff_ff_ff_ff_ff_ff_f0_00}; // 00
            optionBytes <= {
            64'h00_00_55_00_00_aa_00_aa}; // 80
        end
        else begin
            case (TA1)
                8'h00: memory[63:0]     <= Scratchpad;
                8'h08: memory[127:64]   <= Scratchpad;
                8'h10: memory[191:128]  <= Scratchpad;
                8'h18: memory[255:192]  <= Scratchpad;
                8'h20: memory[319:256]  <= Scratchpad;
                8'h28: memory[383:320]  <= Scratchpad;
                8'h30: memory[447:384]  <= Scratchpad;
                8'h38: memory[511:448]  <= Scratchpad;
                8'h40: memory[575:512]  <= Scratchpad;
                8'h48: memory[639:576]  <= Scratchpad;
                8'h50: memory[703:640]  <= Scratchpad;
                8'h58: memory[767:704]  <= Scratchpad;
                8'h60: memory[831:768]  <= Scratchpad;
                8'h68: memory[895:832]  <= Scratchpad;
                8'h70: memory[959:896]  <= Scratchpad;
                8'h78: memory[1023:960] <= Scratchpad;
                8'h80: optionBytes      <= Scratchpad;
                default: begin
                    memory      <= memory;
                    optionBytes <= optionBytes;
                end
            endcase
        end
    end
    
    
    always@(*) begin
        case (TA1[7:3])
            5'd0:rowDat     <= memory[63:0];
            5'd1:rowDat     <= memory[127:64];
            5'd2:rowDat     <= memory[191:128];
            5'd3:rowDat     <= memory[255:192];
            5'd4:rowDat     <= memory[319:256];
            5'd5:rowDat     <= memory[383:320];
            5'd6:rowDat     <= memory[447:384];
            5'd7:rowDat     <= memory[511:448];
            5'd8:rowDat     <= memory[575:512];
            5'd9:rowDat     <= memory[639:576];
            5'd10:rowDat    <= memory[703:640] ;
            5'd11:rowDat    <= memory[767:704];
            5'd12:rowDat    <= memory[831:768];
            5'd13:rowDat    <= memory[895:832];
            5'd14:rowDat    <= memory[959:896];
            5'd15:rowDat    <= memory[1023:960];
            5'd16:rowDat    <= optionBytes;
            5'd17:rowDat    <= 64'h5500_0000_0000_0000;
            default: rowDat <= 64'd0;
        endcase
    end
    
endmodule
