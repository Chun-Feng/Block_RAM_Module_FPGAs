`define CLK_PERIOD  10.0

module PATTERN(
        clk, rst,
        w1_addr, w1_din, en_w1,
        r1_addr, d1
        );

parameter BLOCKSIZE = 10;

output reg clk;
output reg rst;
output reg en_w1;

output reg [BLOCKSIZE:0] r1_addr, w1_addr;

output reg [31:0] w1_din;

input [31:0] d1;
//////// INOUT_PORTS ///////
////////////////////////////
integer mem[0: (2 << BLOCKSIZE) - 1];

integer i, ccc, times;
integer seed;
////////// CREATE_CLOCK_CYCLE_DESIGN ////////
always #(`CLK_PERIOD/2.0) 
        clk = ~clk;

initial begin
        clk = 0;
        rst = 1;

        en_w1 = 0;

        r1_addr = 0;
        w1_addr = 0;

        w1_din = 0;

        seed = 0;
        ccc = 0;
        times = 0;

for(i = 0 ; i < (2 << BLOCKSIZE); i = i + 1)
            mem[i] = 0;

@(negedge clk);
    rst = 0;
@(negedge clk);
    rst = 1;
@(negedge clk);

while(times < 1000000) begin
    while(ccc == 0) 
        begin
            r1_addr = $random(seed);
            w1_addr = $random(seed);

            en_w1 = $random(seed);

	    ccc = 1;
    end

        ccc = 0;
        w1_din[31:8] = 0;
        w1_din[7:0] = $random;

@(negedge clk);

	if((times % 10000) == 0 ) begin
		$display("Execute : %d times Correct!!", times);
	    end

    if(d1 !== mem[r1_addr]) begin
     
        $display("ERROR:R1 address = %d, golden answer is %d, your is %d", r1_addr, mem[r1_addr], d1);

        @(negedge clk);
        @(negedge clk);
        $finish;
    end

    if(en_w1)
        mem[w1_addr] = w1_din;
	
    times = times + 1;

end

    $display("************ PASS ALL *************");
    $finish;

end

endmodule

