// Define module IO
module engine_round_transformer (
    input rst_,
    // input from engine_key_generator
    input transformer_start,

	input[127:0] round0_key, // pre-round key
	input[127:0] round1_key,
	input[127:0] round2_key,
	input[127:0] round3_key,
	input[127:0] round4_key,
	input[127:0] round5_key,
	input[127:0] round6_key,
	input[127:0] round7_key,
	input[127:0] round8_key,
	input[127:0] round9_key,
	input[127:0] round10_key,
    // output to output_interface
    output[127:0] ciphertext
    // control signal output to engine_key_generator, input_interface, output_interface
    output transformer_done,
);

endmodule