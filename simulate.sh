# simulate input_interface
clear && iverilog -o build/input_interface_tb.out input_interface.v input_interface_tb.v && vvp build/input_interface_tb.out && gtkwave simulation/input_interface.vcd
# simulate engine_key_generator
clear && iverilog -o build/engine_key_generator_tb.out engine_key_generator.v engine_key_generator_tb.v && vvp build/engine_key_generator_tb.out && gtkwave simulation/engine_key_generator.vcd
# simulate engine_round_transformer
clear && iverilog -o build/engine_round_transformer_tb.out engine_round_transformer.v engine_round_transformer_tb.v && vvp build/engine_round_transformer_tb.out && gtkwave simulation/engine_round_transformer.vcd
# simulate output_interface
clear && iverilog -o build/output_interface_tb.out output_interface.v output_interface_tb.v && vvp build/output_interface_tb.out && gtkwave simulation/output_interface.vcd

# simulate aes_engine
clear && iverilog -o build/aes_engine_tb.out input_interface.v engine_key_generator.v engine_round_transformer.v output_interface.v aes_engine.v aes_engine_tb.v && vvp build/aes_engine_tb.out && gtkwave gtkwave/aes_engine_testbench.gtkw