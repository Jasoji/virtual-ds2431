library verilog;
use verilog.vl_types.all;
entity VirtualDS2431 is
    port(
        nRst            : in     vl_logic;
        clk             : in     vl_logic;
        IO_i            : in     vl_logic;
        IO_o            : out    vl_logic;
        uartTx          : out    vl_logic
    );
end VirtualDS2431;
