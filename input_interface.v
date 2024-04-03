// Define module IO
module input_interface (
	// -- input interface
	input clk, input rst_,
	input[7:0] din,
	input[1:0] cmd,
	output ready,
	input transformer_done,
	// -- to engine
	output engine_start,
	output[127:0] plain_out,
	output[127:0] key_out
);

// Define FSM states
localparam S_ID = 2'b00;  // Idle state
localparam S_SP = 2'b01;  // Set plaintext state
localparam S_SK = 2'b10;  // Set key state
localparam S_ST = 2'b11;  // Start encryption

// Define registers
// -- FSM state registers
reg[1:0] state, next_state;
initial state=S_ID;
// -- plaintext and key registers
reg[127:0] plain, key;
initial plain = 128'hF00DBABEF00DBABEF00DBABEF00DBABE;
initial key = 128'hF00DBABEF00DBABEF00DBABEF00DBABE;
assign plain_out = plain;
assign key_out = key;
// -- serial input counter registers
reg[3:0] p_i, k_i;
initial p_i=0;
initial k_i=0;
// output engine_start if plain and key ready and start cmd
assign engine_start = (p_i == 4'hF) && (k_i == 4'hF) && (state == S_ST);
// input interface ready if state is idle
assign ready = (state == S_ID);

// Reset functions
task resetkey;
	begin
		key = 128'h00000000000000000000000000000000;
		k_i = 4'h0;
	end
endtask
task resetplain;
	begin
		plain = 128'h00000000000000000000000000000000;
		p_i = 4'h0;
	end
endtask

// Next state combinational logic
always @(negedge clk) state <= next_state;
always @(posedge clk)
begin:next_state_decode
	// reset logic
	if (!rst_) begin
		resetplain();
		resetkey();		
		next_state = S_ID;	
	end
	// command parse
	else case (cmd)
		// Set plaintext state
		S_SP: begin
			// reset if first input
			if (state != S_SP) resetplain();
			else p_i <= p_i+1;
			// return to idle or keep state
			if (p_i == 4'hF) next_state = S_ID; // recieved 16 bytes, return to idle
			else
			begin
				// still reciving bytes
				// read plain from din
				plain = {plain[119:0], din}; // Left shift and insert
				next_state = S_SP;
			end
		end

		// Set key state
		S_SK: begin
			// reset if first input
			if (state != S_SK) resetkey();
			else k_i <= k_i+1;

			// return to idle or keep state
			if (k_i == 4'hF) next_state = S_ID; // recieved 16 bytes, return to idle
			else
			begin
				// still recieving bytes
				// read key from din
				key = {key[119:0], din}; // Left shift and insert
				next_state = S_SK;
			end
		end

		// Start encryption state
		S_ST: begin
			// start engine
			if ((p_i == 4'hF) && (k_i == 4'hF)) next_state = S_ST;
			// return to idle
			//? this is a synchronous reset of plain text after encryption is complete
			//! reset only the plain text, in case we want to encrypt more plaintext with the same key
			if (transformer_done) begin
				// encyrption engine is done, we can reset
				resetplain();
				// resetkey();
				next_state = S_ID;
			end
			// otherwise wait in this state
			else next_state = S_ST;
		end

		// stay idle
		default: next_state = S_ID;
	endcase
end

// `ifndef TOPMODULE
// 	// the "macro" to dump signals
// 	initial begin
// 	$dumpfile ("simulation/input_interface.vcd");
// 	$dumpvars(0, input_interface);
// 	end
// `endif

endmodule