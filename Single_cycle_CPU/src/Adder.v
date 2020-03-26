//Subject:     CA - Adder
//--------------------------------------------------------------------------------

module Adder
	#(
		parameter width = 32
	)
	(
    src1_i,
	src2_i,
	sum_o
	);
     
	
//I/O ports
input  [width-1:0]  src1_i;
input  [width-1:0]	 src2_i;
output [width-1:0]	 sum_o;

//Internal Signals
wire   [width-1:0]	 sum_o;

//Parameter

//Main function

assign sum_o = src1_i + src2_i;

endmodule





                    
                    