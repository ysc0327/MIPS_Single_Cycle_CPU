// Program Counter

module PC #(
	parameter bit_size = 18
	)( 
	input  clk,
	input  rst,
	input  [bit_size-1:0] PCin,
	output reg [bit_size-1:0] PCout	
	);
		
	   

	// write your code in here
	always @(posedge clk, posedge rst) begin
		if(rst)
			PCout <= 0;
		else
			PCout <= PCin;
	end
	

endmodule

