module ram_2R2W(
    clk, rst,
    w_addr_1, w_din_1, w_enb_1,
    w_addr_2, w_din_2, w_enb_2,
    r_addr_1, r_dout_1,
    r_addr_2, r_dout_2
    );

parameter BLOCKSIZE =  10;

/////////INOUT/////////
input clk;
input rst;

input [BLOCKSIZE : 0] w_addr_1, w_addr_2;
input [31:0] w_din_1,w_din_2;

input w_enb_1, w_enb_2;
input [BLOCKSIZE : 0] r_addr_1, r_addr_2;
output reg [31:0] r_dout_1, r_dout_2;

//////////////////////////////////////
reg [0:0] lvt_table [0: ( 2 << BLOCKSIZE) - 1];
reg [0:0] lvt_r1_choose, lvt_r2_choose;
//////BLOCK INOUT///////
reg b1_enb, b2_enb;
reg [BLOCKSIZE : 0] b1_addrw, b2_addrw;
reg [31 : 0] b1_dinw, b2_dinw;
reg [BLOCKSIZE : 0] b1_addr1, b1_addr2, b2_addr1, b2_addr2;
wire [31 : 0] b1_dout1, b1_dout2, b2_dout1, b2_dout2;

/////////BLOCKS/////////
ram_2R1W block1(
	.clk(clk),
	.rst(rst),
	.w_enb(b1_enb),
	.w_addr_1(b1_addrw), .w_din_1(b1_dinw),
	.r_addr_1(b1_addr1), .r_dout_1(b1_dout1),
	.r_addr_2(b1_addr2), .r_dout_2(b1_dout2)
        );

ram_2R1W block2(
	.clk(clk),
	.rst(rst),
	.w_enb(b2_enb),
	.w_addr_1(b2_addrw), .w_din_1(b2_dinw),
	.r_addr_1(b2_addr1), .r_dout_1(b2_dout1),
	.r_addr_2(b2_addr2), .r_dout_2(b2_dout2)
        );

always@(*)
    begin
	////Read////
	b1_addr1 = r_addr_1;
	b2_addr1 = r_addr_1;
	b1_addr2 = r_addr_2;
	b2_addr2 = r_addr_2;

	r_dout_1 = (lvt_r1_choose == 0)? b1_dout1 : b2_dout1;
	r_dout_2 = (lvt_r2_choose == 0)? b1_dout2 : b2_dout2;
	////Write////
	b1_addrw = w_addr_1;
	b2_addrw = w_addr_2;

	b1_enb = w_enb_1;
	b2_enb = w_enb_2;

	b1_dinw = w_din_1;
	b2_dinw = w_din_2;
    end

always@(negedge clk)
    begin
	////Read////
	lvt_r1_choose <= lvt_table[r_addr_1];
	lvt_r2_choose <= lvt_table[r_addr_2];

	////Write////
	if( w_enb_1 == 1)begin
		lvt_table[w_addr_1] = 0;
	    end

	if( w_enb_2 == 1)begin
		lvt_table[w_addr_2] = 1;
	    end
end

always@(posedge clk or negedge rst)
    begin
	if(!rst)
	    begin
	    end
	else
	    begin
	    end
    end

endmodule

