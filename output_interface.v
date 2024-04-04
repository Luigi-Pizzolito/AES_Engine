// Define module IO
module output_interface(
	input rst_, clk,
	// input from engine_round_transformer
	input transformer_done,
	input[127:0] ciphertext,
	// outputs
	output[7:0] data_out,
	output data_ok,
	output output_read
);

// Define registers
// -- ciphertext hold register
reg [127:0] output_hold;
initial output_hold = 128'h00000000000000000000000000000000;
// -- output register
reg [7:0] output_port;
initial output_port = 8'h00;
assign data_out = output_port;
// -- output control signals
reg data_ok_r;
initial data_ok_r = 0;
assign data_ok = data_ok_r;
reg output_read_r;
initial output_read_r = 0;
assign output_read = output_read_r;
// -- internal control signals
reg[4:0] i;
initial i = 5'b00000;

// Main Logic
// -- Asynchronous reset logic
always @(negedge rst_) begin
	output_hold = 128'h00000000000000000000000000000000;
	output_port = 8'h00;
	i = 5'b00000;
end
// -- Output latch logic
always @(posedge transformer_done) begin
	// ? add check here to see if output_read is finished
	// ? not needed; it takes 8 clock cycles to output the ciphertext
	// ? and 8 clock cycles to input the new plaintext
	// ? therefore these two tasks may be done independently and simultaneously
	// ? without any conflicts
	// copy ciphertext
	output_hold = ciphertext;
	// set in to begin
	i = 1;
end
always @(posedge clk) begin
	if (i == 0) begin
		// idling
		output_read_r = 0;
	end
	if (i == 1) begin
		// read first byte and set output data ok
		output_port = output_hold[127:120];
		data_ok_r = 1;
	end
	else if (i <= 16) begin
		// sequentially shift and output bytes 2-16
		output_hold = output_hold << 8;
		output_port = output_hold[127:120];
	end
	else if (i == 17) begin
		// finished outputing reset
		data_ok_r = 0;
		output_hold = 128'h00000000000000000000000000000000;
		output_port = 8'h00;
		i = 5'b00000;
		output_read_r = 1;
	end
	// increment i counter to next byte
	if (i >= 1) begin
		i = i + 1;
	end
end

// `define TOPMODULE
// // the "macro" to dump signals
// initial begin
// $dumpfile ("simulation/output_interface.vcd");
// $dumpvars(0, output_interface);
// end

endmodule