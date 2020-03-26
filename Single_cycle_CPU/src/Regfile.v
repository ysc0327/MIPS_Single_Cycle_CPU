// Regfile

module Regfile ( clk, 
				 rst,
				 Read_addr_1,
				 Read_addr_2,
				 Read_data_1,
                 Read_data_2,
				 RegWrite,
				 Write_addr,
				 Write_data);
	
	parameter bit_size = 32;
	
	input  clk, rst;
	input  [4:0] Read_addr_1;
	input  [4:0] Read_addr_2;
	
	output [bit_size-1:0] Read_data_1;
	output [bit_size-1:0] Read_data_2;
	
	input  RegWrite;
	input  [4:0] Write_addr;
	input  [bit_size-1:0] Write_data;
	
    // write your code in here
	
	
	// regfile memory
	reg [bit_size - 1 : 0] reg_mem [0 : 31];

	// reg_mem write
	//always @(*) begin
	//	reg_mem[0] = 0;
	//end

	genvar i;
	generate
	for(i = 0; i < 32; i = i + 1)
	begin : reg_mem_module
	always @(posedge clk, posedge rst)
		if(rst) begin
			reg_mem[i] <= 0;
		end
		else if(RegWrite & |Write_addr)
			reg_mem[Write_addr] <= Write_data ;
	end
	endgenerate	
	
	// reg_mem read
	assign Read_data_1 = reg_mem[Read_addr_1];
	assign Read_data_2 = reg_mem[Read_addr_2];
				
endmodule






