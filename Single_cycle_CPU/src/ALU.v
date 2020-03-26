// ALU

module ALU ( ALUOp,
			 src1,
			 src2,
			 shamt,
			 ALU_result,
			 Zero
			 );
	
	parameter bit_size = 32;
	
	input [3:0] ALUOp;         // ALU_Ctrl connects this port
	input [bit_size-1:0] src1;
	input [bit_size-1:0] src2;
	input [4:0] shamt;
	
	output reg [bit_size-1:0] ALU_result;
	output Zero;
	
	
	// write your code in here		
	/*
		ALU_Ctrl = 0;  // No operation v sll do shamt
		ALU_Ctrl = 1;  // add do add
		ALU_Ctrl = 2;  // sub do sub
		ALU_Ctrl = 3;  // and do and
		ALU_Ctrl = 4;  // or  do or
		ALU_Ctrl = 5;  // xor do xor
		ALU_Ctrl = 6;  // nor do nor
		
		ALU_Ctrl = 7;  // slt do sub        // extra ctrl
		ALU_Ctrl = 8;  // srl do shamt      // extra ctrl
	*/
	
	//wire [31:0]slt_result;	
	always @(*) begin
		ALU_result = 0;
		case(ALUOp)
			4'd0 : ALU_result =   src2 << shamt;
			4'd1 : ALU_result =   src1 + src2;
			4'd2 : ALU_result =   src1 - src2;
			4'd3 : ALU_result =   src1 & src2;
			4'd4 : ALU_result =   src1 | src2;
			4'd5 : ALU_result =   src1 ^ src2;
			4'd6 : ALU_result = ~(src1 | src2);
			
			4'd7 : ALU_result = (src2 > src1) ? 1 : 0;
			
			4'd8 : ALU_result =   src2 >> shamt;
			
			//4'd9 : ALU_result = (src2 > src1) ? 1 : 0;
		endcase
	end
	
	assign Zero = (ALU_result == 0);
		
	/*		
			// add by myself
			4'b0011 : ALU_result = src1 ^ src2;
			
			
			
			
			4'b0010 : begin 
						{Cout, ALU_result} = src1 + src2; 						
						//if positive + positive is negative then overflow; if negative + negative is positive then overflow
						overflow = (src1[31] && src2[31] && (!ALU_result[31])) || (!src1[31] && !src2[31] && ALU_result[31]);
					  end					  
			4'b0110 : begin 
						{Cout, ALU_result} = src1 + ~src2 + 1;
						//if positive - negative is negative  then overflow ; if negative - positive is positive then overflow  
						overflow = (!src1[31] && src2[31] && !result[31]) || (!src1[31] && src2[31] && result[31]);
					  end					  
			4'b0111 : begin
						overflow = 0;
						{Cout, slt_result} = src1 + ~src2 + 1;
						if(slt_result[31])
							ALU_result = {31'b0, ~Cout};
						else
							ALU_result = {31'b0, Cout};						   					
					  end											
			4'b1100 : ALU_result = ~(src1 | src2);
		endcase
	end
	*/
	
endmodule





