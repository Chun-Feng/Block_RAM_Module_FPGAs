module ram_2R1W(
    clk, rst,
    w_addr_1, w_din_1, w_enb,
    r_addr_1, r_dout_1,
    r_addr_2, r_dout_2
    );

parameter BLOCLSIZE = 10;

input clk;
input rst;
input [BLOCLSIZE : 0] w_addr_1;
input [31 : 0] w_din_1;
input w_enb;

input [BLOCLSIZE : 0] r_addr_1, r_addr_2;
output [31:0] r_dout_1, r_dout_2;
//////////////////////////////

ram_1R1W block1(
    .clk(clk), .rst(rst),
    .w_addr(w_addr_1), .w_din(w_din_1), .w_enb(w_enb),
    .r_addr(r_addr_1), .r_dout(r_dout_1)
    );

ram_1R1W block2(
    .clk(clk), .rst(rst),
    .w_addr(w_addr_1), .w_din(w_din_1), .w_enb(w_enb),
    .r_addr(r_addr_2), .r_dout(r_dout_2)
    );

endmodule

