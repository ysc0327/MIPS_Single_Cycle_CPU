// Jump_Ctrl

module Jump_Ctrl( Zero,
                  JumpOP,
				  // write your code in here
				  opcode_i,
				  ins
				  );

    input Zero;
	 input [31:0] ins;
	output reg [1:0] JumpOP;
	// write your code in here
	
	input [5:0] opcode_i; // use to determine which instruction can change PC
	
	always @(*) begin
		JumpOP = 3;
		if(ins == 32'd0)
			JumpOP = 3;
		else 
		case(opcode_i)
			6'b000100 : if(Zero)  JumpOP = 2; // beq 
			6'b000100 : if(!Zero) JumpOP = 2; // bne
			6'b000000 : begin
								if( (ins[5:0] == 6'b001000) || (ins[5:0] == 6'b001001))
									JumpOP = 1; // jr jalr
								else 
									JumpOP = 3;
							end
			6'b000010 :           JumpOP = 0; // j
			6'b000011 :           JumpOP = 0; // jal
		endcase
	end

endmodule





