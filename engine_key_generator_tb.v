`timescale 1ns/1ns // define simulation timescale

// define testbench module for engine_key_generator
module engine_key_generator_tb();

// define tb registers and wires
reg clk_tb = 0;
reg rst_tb = 0;

reg[127:0] key_in_r = 0;
reg start = 0;

wire transformer_start_w;
wire[127:0] rk0; // pre-round key
wire[127:0] rk1;
wire[127:0] rk2;
wire[127:0] rk3;
wire[127:0] rk4;
wire[127:0] rk5;
wire[127:0] rk6;
wire[127:0] rk7;
wire[127:0] rk8;
wire[127:0] rk9;
wire[127:0] rk10;

// define tb->engine_key_generator connections
engine_key_generator i_uut (
	.rst_			(rst_tb),
	.clk			(clk_tb),
	.key_in			(key_in_r),
	.key_start		(start),
	.transformer_start	(transformer_start_w),
	.round0_key		(rk0),
	.round1_key		(rk1),
	.round2_key		(rk2),
	.round3_key		(rk3),
	.round4_key		(rk4),
	.round5_key		(rk5),
	.round6_key		(rk6),
	.round7_key		(rk7),
	.round8_key		(rk8),
	.round9_key		(rk9),
	.round10_key	(rk10)
);

// set periodic clock pulse every 1ns
always clk_tb = #1 ~clk_tb;

// set testing sequence signals
initial begin
	start = 0;

	// reset module
	rst_tb = 0;
	#2;
	rst_tb = 1;
	#2;

	// set key
	key_in_r = 128'h2475A2B33475568831E2120013AA5487;
	#2;
	//start
	start = 1;
	#500;
	$finish;
end

endmodule