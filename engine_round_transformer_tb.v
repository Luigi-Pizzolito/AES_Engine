`timescale 1ns/1ns // define simulation timescale

// define testbench module for aes_engine
module engine_round_transformer_tb();

// define tb registers and wires
reg clk_tb = 0;
reg rst_tb = 0;
// -- inputs
reg [127:0] plain_tb = 128'h00041214120412000C00131108231919;
reg transformer_start_tb;
initial transformer_start_tb = 0;
reg output_read_tb;
initial output_read_tb = 0;
// -- input keys
reg[127:0] round0_key_tb  = 128'h2475A2B33475568831E2120013AA5487; // pre-round key
reg[127:0] round1_key_tb  = 128'h8955B5CEBD20E3468CC2F1469F68A5C1;
reg[127:0] round2_key_tb  = 128'hCE53CD1573732E53FFB1DF1560D97AD4;
reg[127:0] round3_key_tb  = 128'hFF8985C58CFAAB96734B748313920E57;
reg[127:0] round4_key_tb  = 128'hB822DEB834D8752E479301AD54010FFA;
reg[127:0] round5_key_tb  = 128'hD454F398E08C86B6A71F871BF31E88E1;
reg[127:0] round6_key_tb  = 128'h86900B95661C8D23C1030A38321D82D9;
reg[127:0] round7_key_tb  = 128'h62833EB6049FB395C59CB9ADF7813B74;
reg[127:0] round8_key_tb  = 128'hEE61ACDEEAFE1F4B2F62A6E6D8E39D92;
reg[127:0] round9_key_tb  = 128'hE43FE3BF0EC1FCF421A35A12F940C780;
reg[127:0] round10_key_tb = 128'hDBF92E26D538D2D2F49B88C00DDB4F40;
// -- outputs
wire [127:0] ciphertext_tb;
wire transformer_done_tb;

// define tb->engine_round_transformer connections
engine_round_transformer i_uut
(
	.clk(clk_tb),
	.rst_(rst_tb),

	// inputs
	.plaintext          (plain_tb),
	.transformer_start  (transformer_start_tb),
	.output_read        (output_read_tb),
	// -- keys
	.round0_key         (round0_key_tb),
	.round1_key         (round1_key_tb),
	.round2_key         (round2_key_tb),
	.round3_key         (round3_key_tb),
	.round4_key         (round4_key_tb),
	.round5_key         (round5_key_tb),
	.round6_key         (round6_key_tb),
	.round7_key         (round7_key_tb),
	.round8_key         (round8_key_tb),
	.round9_key         (round9_key_tb),
	.round10_key        (round10_key_tb),

	// outputs
	.ciphertext          (ciphertext_tb),
	.transformer_done    (transformer_done_tb)
);

// set periodic clock pulse every 1ns
always clk_tb = #1 ~clk_tb;

// set testing sequence signals
initial begin
	// reset round transformer
	rst_tb = 0;
	#2;
	rst_tb = 1;
	#2;

	// inputs set at the beggining of program

	// start encryption rounds
	transformer_start_tb = 1;

	// wait for finish
	// wait for transofrmer done to go high
	@(posedge transformer_done_tb)
	begin
		// Idle
		#20;
		// Signal that ouput has been read
		// (simulating output_interface input signal)
		transformer_start_tb = 0;
		output_read_tb = 1;
		#10;
		output_read_tb = 0;
		#10;
		$finish;
	end

end

endmodule