//Execute stage. Author: Jesus Colmenares

module ex_stage(//Inputs
				input wire [31:0] PC4_ex_i, //PC+4
				input wire [31:0] PC_ex_i,  //PC
				input wire [4:0]  rd_ex_i,  //rd address for WB stage
				input wire [31:0] src_A_ex_i, //alu input
				input wire [31:0] src_B_ex_i,  //alu input
				input wire [2:0]  alu_op_ex_i, //alu control signal
				input wire [31:0] csr_data_ex_i, //data for CSR
				input wire [11:0] csr_addr_ex_i, //CSR address
				input wire [31:0] rs2_data_ex_i, //Data from rs2 to be written in MEM
				input wire [10:0] trap_code_ex_i, //Each bit represent an exception type.
				input wire is_trap_ex_i, //flag for exceptions
				//Outputs
				output reg [31:0] PC4_ex_o,
				output reg [31:0] PC_ex_o,
				output reg [4:0]  rd_ex_o,		
				output reg [31:0] csr_data_ex_o,
				output reg [11:0] csr_addr_ex_o,
				output reg [31:0] rs2_data_ex_o,
				output reg [10:0] trap_code_ex_o, 
				output reg is_trap_ex_o, 
				output reg [31:0] alu_out_ex_o  //alu result after execution.
				);


	always @(*) begin

		//Propagated signals to next stage
		PC4_ex_o = PC4_ex_i;
		PC_ex_o = PC_ex_i;
		rd_ex_o = rd_ex_i;		
		csr_data_ex_o = csr_data_ex_i;
		csr_addr_ex_o = csr_addr_ex_i ;
		rs2_data_ex_o = rs2_data_ex_i;
		trap_code_ex_o = trap_code_ex_i; 
		is_trap_ex_o = is_trap_ex_i; 

		//ALU operations
		case(alu_op_ex_i)

			3'b000: alu_out_ex_o = src_A_ex_i + src_B_ex_i;
			3'b001: alu_out_ex_o = src_A_ex_i << src_B_ex_i;
			3'b010: alu_out_ex_o = src_A_ex_i - src_B_ex_i;
			3'b011: alu_out_ex_o = src_A_ex_i >>> src_B_ex_i;
			3'b100: alu_out_ex_o = src_A_ex_i ^ src_B_ex_i;
			3'b101: alu_out_ex_o = src_A_ex_i >> src_B_ex_i;
			3'b110: alu_out_ex_o = src_A_ex_i | src_B_ex_i;
			3'b111: alu_out_ex_o = src_A_ex_i & src_B_ex_i;

		endcase
	
	end

endmodule 