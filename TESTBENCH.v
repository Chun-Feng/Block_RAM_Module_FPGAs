`include "PATTERN.v"
`include "ram_1R1W.v"

module TESTBENCH();
initial begin

//          $fsdbDumpfile("core.fsdb");
//          $fsdbDumpvars;

//////// MEMORY_DESIGN_gtkwave_TOOLS //////
//	    $dumpfile("core.vcd");
//	    $dumpvars;
    end

parameter BLOCKSIZE = 10;

wire        clk;
wire        rst;
wire        en_w1;

wire [BLOCKSIZE:0] r1_addr, w1_addr;

wire [31:0] w1, d1;

//////////////////////////////////////
PATTERN u_pattern(
        .clk(clk), .rst(rst),
        .w1_addr(w1_addr), .w1_din(w1), 
        .en_w1(en_w1),
        .r1_addr(r1_addr), .d1(d1)
        );

ram_1R1W ram(
        .clk(clk), .rst(rst),
        .w_addr(w1_addr), .w_din(w1), 
        .w_enb(en_w1),
        .r_addr(r1_addr), .r_dout(d1)
        );

endmodule

