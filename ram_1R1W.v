module ram_1R1W(
        clk, rst,
        w_addr, w_din, w_enb,
        r_addr, r_dout
        );

parameter BLOCLSIZE = 10;
parameter BASICSIZE = 9;

input clk;
input rst;
input [BLOCLSIZE:0] w_addr;
input [31:0] w_din;
input w_enb;

input [BLOCLSIZE:0] r_addr;
output [31:0] r_dout;
//////// INOUT_PORTS ///////
//////////////////////////////
wire [0:0] w_enb_b [0:(1 << (BLOCLSIZE - BASICSIZE)) - 1];
////// WRITES_PORT ///////
wire [BASICSIZE:0] w_addr_b [0:(1 << (BLOCLSIZE - BASICSIZE)) - 1];
wire [31:0] w_din_b [0:(1 << (BLOCLSIZE - BASICSIZE)) - 1];
////// READS_PORT ////////
wire [BASICSIZE:0] r_addr_b [0:(1 << (BLOCLSIZE - BASICSIZE)) - 1];
wire [31:0] r_dout_b [0:(1 << (BLOCLSIZE - BASICSIZE)) - 1];

reg [BLOCLSIZE:0] r_addr_tmp;
///////// GENERAL_BANKS_DESIGN /////////
generate
genvar j;
	for (j = 0; j < (1 << (BLOCLSIZE - BASICSIZE)) ; j = j + 1)
	    begin : wirecon
		assign w_enb_b[j] = (w_addr[BLOCLSIZE:BASICSIZE + 1] == j)? w_enb : 1'b0;
		assign w_addr_b[j] = w_addr[BASICSIZE:0];
		assign w_din_b[j] = w_din ;
		
                assign r_addr_b[j] = r_addr[BASICSIZE:0];
	end
endgenerate

	assign r_dout = r_dout_b[(r_addr_tmp[BLOCLSIZE:BASICSIZE + 1])];

//////// INCLUDE_Block_RAM_PORTS //////////
generate
genvar i;
	for (i = 0 ; i < (1 << (BLOCLSIZE - BASICSIZE)) ; i = i + 1)
	    begin : memblock
		blk_mem_gen_v7_2 blkmem(
			.clka(clk),
			.wea(w_enb_b[i]),
			.addra(w_addr_b[i]),
			.dina(w_din_b[i]),
			.douta(),
			.clkb(clk),
			.web(1'b0),
			.addrb(r_addr_b[i]),
			.dinb(),
			.doutb(r_dout_b[i])
		        );
	end
endgenerate

always@(posedge clk or negedge rst) begin
	if(!rst)
	    begin

	    end
	else
	    begin
		r_addr_tmp <= r_addr;
	    end
end

endmodule

