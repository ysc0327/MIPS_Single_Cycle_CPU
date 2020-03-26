// Controller

module Controller ( //opcode,
					//funct,
					// write your code in here (output)
					
	input  [5:0] opcode,
    input  [5:0] funct,

	// write your code in here
	output reg Mux_RF_WriteData_sel,
	output reg Mux_RtRd_sel,
	output reg Mux_WriteReg_sel,
	output reg Mux_ALUsrc_sel,
	output reg Mux_DM_WriteData_sel,
	output reg Mux_DM_output_sel,
	output reg Mux_ALU_DM_Data_sel,
	output reg [3:0] ALU_Ctrl,
	
	output reg RegWrite_en,
	output reg DM_Ctrl
);
	
	// ALU_Ctrl
	always @(*) begin
		ALU_Ctrl = 0;
		case(opcode)
			6'b000000 : begin
				case(funct) 
					6'b000000 : ALU_Ctrl = 0;  // No operation v sll do shamt
					6'b100000 : ALU_Ctrl = 1;  // add do add
					6'b100010 : ALU_Ctrl = 2;  // sub do sub
					6'b100100 : ALU_Ctrl = 3;  // and do and
					6'b100101 : ALU_Ctrl = 4;  // or  do or
					6'b100110 : ALU_Ctrl = 5;  // xor do xor
					6'b100111 : ALU_Ctrl = 6;  // nor do nor
				
					6'b101010 : ALU_Ctrl = 7;  // slt do sub        // extra ctrl
					6'b000010 : ALU_Ctrl = 8;  // srl do shamt      // extra ctrl
				endcase
			end			
			6'b001000 :	ALU_Ctrl = 1; // addi do add
			
			6'b001100 : ALU_Ctrl = 3; // andi do and
			
			6'b001010 : ALU_Ctrl = 7; // slti do sub
			
			6'b000100 : ALU_Ctrl = 2; // beq  do sub
			6'b000101 : ALU_Ctrl = 2; // bne  do sub
			
			6'b100011 : ALU_Ctrl = 1; // lw   do add
			6'b100001 : ALU_Ctrl = 1; // lh   do add
			6'b101011 : ALU_Ctrl = 1; // sw   do add
			6'b101001 : ALU_Ctrl = 1; // sh   do add
		endcase	 
	end
		
	// Mux_RF_WriteData_sel   // 1
	always @(*) begin		
		if({opcode, funct} == 12'b000000_001001)
			Mux_RF_WriteData_sel = 1;  // R-Format : jalr
		else if(opcode == 6'b000011)
			Mux_RF_WriteData_sel = 1;  // J-Format : jal
		else	
			Mux_RF_WriteData_sel = 0;
	end
	
	// Mux_WriteReg_sel       // 3
	always @(*) begin
		if({opcode, funct} == 12'b000000_001001)
			Mux_WriteReg_sel = 0;  // R-Format : jalr
		else if(opcode == 6'b000011)
			Mux_WriteReg_sel = 0;  // J-Format : jal
		else
			Mux_WriteReg_sel = 1;
	end
	
	always @(*) begin
		Mux_RtRd_sel = 0;         // 2		
		Mux_ALUsrc_sel =0;        // 4
		Mux_DM_WriteData_sel = 0; // 5
		Mux_DM_output_sel = 0;    // 6
		Mux_ALU_DM_Data_sel = 0;  // 7
		RegWrite_en = 0;
		DM_Ctrl   = 0;
		case(opcode)
			6'b000000 : begin             // R-Format, exclude jalr				
				Mux_RtRd_sel = 0;         // 2		
				Mux_ALUsrc_sel =0;        // 4
				Mux_DM_WriteData_sel = 0; // 5
				Mux_DM_output_sel = 0;    // 6
				Mux_ALU_DM_Data_sel = 1;  // 7
				DM_Ctrl = 0;
				if(funct == 6'b001000) // jr not write data to RF
					RegWrite_en = 0;
				else
					RegWrite_en = 1;
			end
						
			6'b001000 : begin // addi     // I-Format,
				Mux_RtRd_sel = 1;         // 2		
				Mux_ALUsrc_sel = 1;       // 4
				Mux_DM_WriteData_sel = 0; // 5
				Mux_DM_output_sel = 0;    // 6
				Mux_ALU_DM_Data_sel = 1;  // 7
				RegWrite_en = 1;
				DM_Ctrl = 0;
			end
			
			6'b001100 : begin // andi     // I-Format
				Mux_RtRd_sel = 1;         // 2		
				Mux_ALUsrc_sel = 1;       // 4
				Mux_DM_WriteData_sel = 0; // 5
				Mux_DM_output_sel = 0;    // 6
				Mux_ALU_DM_Data_sel = 1;  // 7
				RegWrite_en = 1;
				DM_Ctrl = 0;
			end
			
			6'b001010 : begin // slti     // I-Format
				Mux_RtRd_sel = 1;         // 2		
				Mux_ALUsrc_sel = 1;       // 4
				Mux_DM_WriteData_sel = 0; // 5
				Mux_DM_output_sel = 0;    // 6
				Mux_ALU_DM_Data_sel = 1;  // 7
				RegWrite_en = 1;
				DM_Ctrl = 0;
			end
			
			6'b000100 : begin // beq      // I-Format
				Mux_RtRd_sel = 0;         // 2		
				Mux_ALUsrc_sel = 0;       // 4
				Mux_DM_WriteData_sel = 0; // 5
				Mux_DM_output_sel = 0;    // 6
				Mux_ALU_DM_Data_sel = 0;  // 7	
				RegWrite_en = 0;
				DM_Ctrl = 0;
			end
			
			6'b000101 : begin // bne      // I-Format
				Mux_RtRd_sel = 0;         // 2		
				Mux_ALUsrc_sel = 0;       // 4
				Mux_DM_WriteData_sel = 0; // 5
				Mux_DM_output_sel = 0;    // 6
				Mux_ALU_DM_Data_sel = 0;  // 7	
				RegWrite_en = 0;
				DM_Ctrl = 0;
			end
			
			6'b100011 : begin // lw       // I-Format
				Mux_RtRd_sel = 1;         // 2		
				Mux_ALUsrc_sel = 1;       // 4
				Mux_DM_WriteData_sel = 0; // 5
				Mux_DM_output_sel = 1;    // 6
				Mux_ALU_DM_Data_sel = 0;  // 7
				RegWrite_en = 1;
				DM_Ctrl = 0;
			end
			
			6'b100001 : begin // lh       // I-Format
				Mux_RtRd_sel = 1;         // 2		
				Mux_ALUsrc_sel = 1;       // 4
				Mux_DM_WriteData_sel = 0; // 5
				Mux_DM_output_sel = 0;    // 6
				Mux_ALU_DM_Data_sel = 0;  // 7
				RegWrite_en = 1;
				DM_Ctrl = 0;
			end
			
			6'b101011 : begin // sw       // I-Format
				Mux_RtRd_sel = 1;         // 2		
				Mux_ALUsrc_sel = 1;       // 4
				Mux_DM_WriteData_sel = 1; // 5
				Mux_DM_output_sel = 0;    // 6
				Mux_ALU_DM_Data_sel = 0;  // 7
				RegWrite_en = 0;
				DM_Ctrl = 1;
			end
			
			6'b101001 : begin // sh       // I-Format
				Mux_RtRd_sel = 1;         // 2		
				Mux_ALUsrc_sel = 1;       // 4
				Mux_DM_WriteData_sel = 0; // 5
				Mux_DM_output_sel = 0;    // 6
				Mux_ALU_DM_Data_sel = 0;  // 7
				RegWrite_en = 0;
				DM_Ctrl = 1;
			end
			
			6'b000010 : begin // j        // J-Format
				Mux_RtRd_sel = 0;         // 2		
				Mux_ALUsrc_sel = 0;       // 4
				Mux_DM_WriteData_sel = 0; // 5
				Mux_DM_output_sel = 0;    // 6
				Mux_ALU_DM_Data_sel = 0;  // 7
				RegWrite_en = 0;
			end
			
			6'b000011 : begin // jal      // J-Format
				Mux_RtRd_sel = 0;         // 2		
				Mux_ALUsrc_sel = 0;       // 4
				Mux_DM_WriteData_sel = 0; // 5
				Mux_DM_output_sel = 0;    // 6
				Mux_ALU_DM_Data_sel = 0;  // 7
				RegWrite_en = 1;
			end
		endcase
	end
	
endmodule




