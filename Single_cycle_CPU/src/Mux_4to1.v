module Mux_4to1 #(
	parameter mux_size = 32
)(
	input [mux_size - 1 : 0] data_0_i,
	input [mux_size - 1 : 0] data_1_i,
	input [mux_size - 1 : 0] data_2_i,
	input [mux_size - 1 : 0] data_3_i,
	input [1:0] sel,
	output [mux_size - 1 : 0] data_o
);

assign data_o = sel == 0 ? data_0_i 
			        : sel == 1 ? data_1_i
			        : sel == 2 ? data_2_i
			        : sel == 3 ? data_3_i : data_3_i; 

endmodule