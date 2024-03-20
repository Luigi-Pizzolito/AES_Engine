// define testbench module for input interface + engine_key_generator
module aes_engine(
    // -- input interface
    input clk, input rst_,
    input[7:0] din,
    input[1:0] cmd,
    output interface_ready,

    // -- output interface
	output[127:0] ciphertext_o,

    output engine_done
);

// control signals
wire key_start, transformer_start_w, engine_done_w;
assign engine_done = engine_done_w;

wire [127:0] plain, key;

wire[127:0] round0_key_w; // pre-round key
wire[127:0] round1_key_w;
wire[127:0] round2_key_w;
wire[127:0] round3_key_w;
wire[127:0] round4_key_w;
wire[127:0] round5_key_w;
wire[127:0] round6_key_w;
wire[127:0] round7_key_w;
wire[127:0] round8_key_w;
wire[127:0] round9_key_w;
wire[127:0] round10_key_w;

input_interface input_module (
    .clk            (clk),
    .rst_           (rst_),

	// inputs
    .din            (din),
    .cmd            (cmd),
    .engine_done    (engine_done_w),

	// outputs
    .engine_start   (key_start),
    .plain_out      (plain),
    .key_out        (key),
	.ready          (interface_ready)
);

engine_key_generator key_gen_module (
    .rst_               (rst_),

	// inputs
    .key_in             (key),
    .engine_start       (key_start), //rename input wire to key_gen_start
    
	.transformer_done	(engine_done_w),

	// outputs
	.transformer_start  (transformer_start_w),
	// -- keys
    .round0_key			(round0_key_w),
	.round1_key			(round1_key_w),
	.round2_key			(round2_key_w),
	.round3_key			(round3_key_w),
	.round4_key			(round4_key_w),
	.round5_key			(round5_key_w),
	.round6_key			(round6_key_w),
	.round7_key			(round7_key_w),
	.round8_key			(round8_key_w),
	.round9_key			(round9_key_w),
	.round10_key		(round10_key_w)
);

engine_round_transformer transformer_module (
	.rst_				(rst_),

	// inputs
	.plaintext			(plain),
	.transformer_start	(transformer_start_w),
	// -- keys
	.round0_key			(round0_key_w),
	.round1_key			(round1_key_w),
	.round2_key			(round2_key_w),
	.round3_key			(round3_key_w),
	.round4_key			(round4_key_w),
	.round5_key			(round5_key_w),
	.round6_key			(round6_key_w),
	.round7_key			(round7_key_w),
	.round8_key			(round8_key_w),
	.round9_key			(round9_key_w),
	.round10_key		(round10_key_w),

	// output
	.ciphertext			(ciphertext_o),
	.transformer_done	(engine_done_w)
);

`define TOPMODULE
// the "macro" to dump signals
initial begin
$dumpfile ("simulation/aes_engine.vcd");
$dumpvars(0, aes_engine);
end

endmodule