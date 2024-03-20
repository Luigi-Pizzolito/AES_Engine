// define testbench module for input interface + engine_key_generator
module aes_engine(
    // -- input interface
    input clk, input rst_,
    input[7:0] din,
    input[1:0] cmd,
    output interface_ready,

    // -- output interface
	output[127:0] round0_key_o, // pre-round key
	output[127:0] round1_key_o,
	output[127:0] round2_key_o,
	output[127:0] round3_key_o,
	output[127:0] round4_key_o,
	output[127:0] round5_key_o,
	output[127:0] round6_key_o,
	output[127:0] round7_key_o,
	output[127:0] round8_key_o,
	output[127:0] round9_key_o,
	output[127:0] round10_key_o,

    output engine_done
);

`define TOPMODULE
// the "macro" to dump signals
initial begin
$dumpfile ("simulation/aes_engine.vcd");
$dumpvars(0, aes_engine);
end

wire engine_start;
//wire engine_done; // set low when start, then high when transformer_start goes high
// assign done = engineD;

wire [127:0] plain, key;

input_interface input_module (
    .clk            (clk),
    .rst_           (rst_),

    .din            (din),
    .cmd            (cmd),
    .ready          (interface_ready),
    .engine_done    (engine_done),

    .engine_start   (engine_start),
    .plain_out      (plain),
    .key_out        (key)
);

engine_key_generator key_gen_module (
    .rst_               (rst_),

    .key_in             (key),
    .engine_start       (engine_start),
    .transformer_start  (engine_done),
	.transformer_done	(1'b0),

    .round0_key		(round0_key_o),
	.round1_key		(round1_key_o),
	.round2_key		(round2_key_o),
	.round3_key		(round3_key_o),
	.round4_key		(round4_key_o),
	.round5_key		(round5_key_o),
	.round6_key		(round6_key_o),
	.round7_key		(round7_key_o),
	.round8_key		(round8_key_o),
	.round9_key		(round9_key_o),
	.round10_key	(round10_key_o)
);

endmodule