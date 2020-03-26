module Mux_2to1 #(
	parameter mux_size = 32
)(
	input [mux_size - 1 : 0] data_0_i,
	input [mux_size - 1 : 0] data_1_i,
	input sel,
	output [mux_size - 1 : 0] data_o
);

assign data_o = sel ? data_1_i : data_0_i;

endmodule