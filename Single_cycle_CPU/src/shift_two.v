module shift_two #(
	parameter width = 16
	)(
	input [width - 1 : 0] data_i,
	output [2*width - 1  : 0] data_o
	);
	
	assign data_o = {16'd0, data_i} ;
endmodule