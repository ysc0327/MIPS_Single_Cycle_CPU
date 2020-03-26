// top

module top ( clk,
             rst,
			 // Instruction Memory
			 IM_Address,
             Instruction,
			 // Data Memory
			 DM_Address,
			 DM_enable,
			 DM_Write_Data,
			 DM_Read_Data);

	parameter data_size = 32;
	parameter mem_size = 16;	

	input  clk, rst;
	
	// Instruction Memory
	input  [data_size-1:0] Instruction;
	output [mem_size-1:0] IM_Address;	
	
	// Data Memory
	input  [data_size-1:0] DM_Read_Data;
	output [mem_size-1:0] DM_Address;
	output DM_enable;
	output [data_size-1:0] DM_Write_Data;	
    
	wire [31:0] four;
	assign four = 32'd1;
	wire [31:0] thirty_one;
	assign thirty_one = 32'd31;
	
	wire [31:0] Mux_nPC_o;
	wire [31:0] PC_4_o;
	wire [31:0] PC_o;
	wire [31:0] Add_jal_o;
	
	// Controller output
	wire [31:0] Mux_RF_WriteData_sel_o;
	wire [4:0]  Mux_RtRd_sel_o;
	wire [4:0] Mux_WriteReg_sel_o;
	wire [31:0] Mux_ALUsrc_sel_o;
	wire [31:0] Mux_DM_WriteData_sel_o;
	wire [31:0] Mux_DM_output_sel_o;
	wire [31:0] Mux_ALU_DM_Data_sel_o;
	wire [3:0] ALU_Ctrl_o;
	
	wire Zero_flag;
	wire [1:0] JumpOP_o;
	wire [31:0] Adder_SE_shift_o;
	wire RegWrite_o;
	wire DM_Ctrl_o;
	wire [31:0] shift_two_SE_imm_o; 
	wire [31:0] shift_two_imm_o; 
	wire [31:0] Mux_ALU_DM_Data_o;
	wire [31:0] SE_DM_out_o;
	wire [31:0] DM_Read_Data_o;
	wire [31:0] SE_DM_in_o;
	wire [31:0] ALU_result_o;
	wire [31:0] SE_imm_o;   
	wire [31:0] RF_RS_Data_o;
	wire [31:0] RF_RT_Data_o;

	
	// Mux output
	wire Mux_RF_WriteData_sel_Ctrl;
	wire Mux_RtRd_sel_Ctrl;
	wire Mux_WriteReg_sel_Ctrl;
	wire Mux_ALUsrc_sel_Ctrl;
	wire Mux_DM_WriteData_sel_Ctrl;
	wire Mux_DM_output_sel_Ctrl;
	wire Mux_ALU_DM_Data_sel_Ctrl;
	
	
	
	
	assign IM_Address = PC_o;
	assign DM_Address = ALU_result_o >> 2;
	assign DM_Write_Data = Mux_DM_WriteData_sel_o;
	assign DM_enable  = DM_Ctrl_o;
	
	// write your code here
	PC #(.bit_size(32)) PC_inst (                        ///
		.clk(clk),
		.rst(rst),
		.PCin(Mux_nPC_o),
		.PCout(PC_o)
	);	
	
	Adder #(.width(32)) Adder_PC_plus (                  ///
		.src1_i(four),
		.src2_i(PC_o),
		.sum_o(PC_4_o)
	);
	Adder #(.width(32)) Adder_jal (                         ///
		.src1_i(PC_o),
		.src2_i(four),
		.sum_o(Add_jal_o)
	);
	Mux_2to1 #(.mux_size(32)) Mux_RF_WriteData (
		.data_0_i(Mux_ALU_DM_Data_o),
		.data_1_i(Add_jal_o),
		.sel(Mux_RF_WriteData_sel_Ctrl),
		.data_o(Mux_RF_WriteData_sel_o)
	);
	Mux_2to1 #(.mux_size(5)) Mux_RtRd (                    ///
		.data_0_i(Instruction[15:11]),
		.data_1_i(Instruction[20:16]),
		.sel(Mux_RtRd_sel_Ctrl),
		.data_o(Mux_RtRd_sel_o)
	);
	
	
	Mux_2to1 #(.mux_size(5)) Mux_WriteReg (                   ///
		.data_0_i(thirty_one),
		.data_1_i(Mux_RtRd_sel_o),
		.sel(Mux_WriteReg_sel_Ctrl),
		.data_o(Mux_WriteReg_sel_o)
	);	
	
	
	
	Regfile RF(                                                 ///
		.clk(clk), 
		.rst(rst),
		.Read_addr_1(Instruction[25:21]),
		.Read_addr_2(Instruction[20:16]),
	  .Read_data_1(RF_RS_Data_o),
    .Read_data_2(RF_RT_Data_o),
		.RegWrite(RegWrite_o),
		.Write_addr(Mux_WriteReg_sel_o),
		.Write_data(Mux_RF_WriteData_sel_o)
	); 
	
	///
	Sign_Extend #(.width(16)) SE_imm (
		.data_i(Instruction[15:0]),
		.data_o(SE_imm_o)
    );
	Mux_2to1 #(.mux_size(32)) Mux_ALUsrc (                   ///
		.data_0_i(RF_RT_Data_o),
		.data_1_i(SE_imm_o),
		.sel(Mux_ALUsrc_sel_Ctrl),
		.data_o(Mux_ALUsrc_sel_o)
	);

	ALU ALU_inst ( 
		.ALUOp(ALU_Ctrl_o),
		.src1(RF_RS_Data_o),
		.src2(Mux_ALUsrc_sel_o),
		.shamt(Instruction[10:6]),
		.ALU_result(ALU_result_o),
		.Zero(Zero_flag)
	);	
	
	///=========================================///

	Mux_2to1 #(.mux_size(32)) Mux_DM_WriteData (
		.data_0_i(SE_DM_in_o),
		.data_1_i(RF_RT_Data_o),
		.sel(Mux_DM_WriteData_sel_Ctrl),
		.data_o(Mux_DM_WriteData_sel_o)
	);

	Sign_Extend #(.width(16)) SE_DM (
		.data_i(RF_RT_Data_o),
		.data_o(SE_DM_in_o)
    );
	///=========================================///
	
	
	///=========================================///

	Mux_2to1 #(.mux_size(32)) Mux_DM_output (
		.data_0_i(SE_DM_out_o),
		.data_1_i(DM_Read_Data),
		.sel(Mux_DM_output_sel_Ctrl),
		.data_o(DM_Read_Data_o)
	);

	Sign_Extend #(.width(16)) SE_DM_out (
		.data_i(DM_Read_Data[15:0]),
		.data_o(SE_DM_out_o)
    );
	///=========================================///
	

	Mux_2to1 #(.mux_size(32)) Mux_ALU_DM_Data (
		.data_0_i(DM_Read_Data_o),
		.data_1_i(ALU_result_o),
		.sel(Mux_ALU_DM_Data_sel_Ctrl),
		.data_o(Mux_ALU_DM_Data_o)
	);	
	
	///
	shift_two #(.width(16)) shift_two_imm (
		.data_i(Instruction[15:0]),
		.data_o(shift_two_imm_o)
	);
	
	///
	shift_two #(.width(16)) shift_two_SE (
		.data_i(SE_imm_o),
		.data_o(shift_two_SE_imm_o)
	);			
	
	Controller Controller_inst( 				                               ///
		.opcode(Instruction[31:26]),
		.funct(Instruction[5:0]),
		.Mux_RF_WriteData_sel(Mux_RF_WriteData_sel_Ctrl),
		.Mux_RtRd_sel(Mux_RtRd_sel_Ctrl),
		.Mux_WriteReg_sel(Mux_WriteReg_sel_Ctrl),
		.Mux_ALUsrc_sel(Mux_ALUsrc_sel_Ctrl),
		.Mux_DM_WriteData_sel(Mux_DM_WriteData_sel_Ctrl),
		.Mux_DM_output_sel(Mux_DM_output_sel_Ctrl),
		.Mux_ALU_DM_Data_sel(Mux_ALU_DM_Data_sel_Ctrl),
		.ALU_Ctrl(ALU_Ctrl_o),
		.RegWrite_en(RegWrite_o),
		.DM_Ctrl(DM_Ctrl_o)
	);	

	Adder Adder_SE_shift(
		.src1_i(shift_two_SE_imm_o),
		.src2_i(PC_4_o),
		.sum_o(Adder_SE_shift_o)
	);
	Mux_4to1 #(.mux_size(32)) Mux_nPC (                    ///
		.data_0_i(shift_two_imm_o),
		.data_1_i(RF_RS_Data_o),
		.data_2_i(Adder_SE_shift_o),
		.data_3_i(PC_4_o),
		.sel(JumpOP_o),
		.data_o(Mux_nPC_o)
	);

	Jump_Ctrl Jump_Ctrl_inst (                     ///
		.Zero(Zero_flag),
    .JumpOP(JumpOP_o),
		.opcode_i(Instruction[31:26]),
		.ins(Instruction)
	);
	
endmodule


