

module morty_mem_stage( 
		  input 		clk_i, 
		  input 		rst_i,
		  input 		wb_stall,
		  input 		wb_flush,
		  //MEM => ID FORWARDING 
		  output 	[31:0] forward_mem_dat_o,
	          //EX => MEM SIGNALS 
		  input 	[31:0]	mem_pc_i,
		  input 	[31:0]	mem_instruction_i,
		  input		[31:0]	mem_result_i, 
		  input 	[ 4:0] 	mem_waddr_i,
		  input 	[ 4:0]	mem_rs1_i, 
		  input 		mem_we_i,
		  input 	[ 5:0]	mem_mem_flags_i,
		  input 		mem_mem_ex_sel_i,
		  input 	[31:0]	mem_csr_data_i,
		  input 	[11:0]	mem_csr_addr_i,
		  input 	[ 2:0] 	mem_csr_op_i,
		  input 	[31:0]	mem_exc_data_i,
		  input 	[ 3:0]	mem_exception_i,
		  input 		mem_trap_valid_i,
		  input			mem_fence_op_i,
		  input			mem_xret_op_i,
		  //LSU  SIGNALS
		  input 	[31:0] 	mem_data_i,
		  input 		mem_err_i,
		  output 		mem_mread_o,
		  output		mem_mwrite_o,
		  output 		mem_mbyte_o,
		  output		mem_mhw_o,
		  output		mem_mword_o,
		  output		mem_munsigned_o,
		
		  output  	[ 3:0]	mem_exception_o,
		  output 		mem_trap_valid_o,

		  //MEM => WB SIGNALS
		   
		  output reg 	[31:0] 	wb_pc_o,
		  output reg 	[31:0] 	wb_instruction_o,
	 	  output reg 	[31:0]	wb_result_o,
	 	  output reg 	[ 4:0]	wb_waddr_o,
		  output reg 		wb_we_o,
		  //CSR SIGNALS
		  output reg 	[31:0]	wb_csr_data_o,
		  output reg 	[11:0]	wb_csr_addr_o,
		  output reg 	[ 2:0]	wb_csr_op_o,
		  output reg 	[ 4:0]	wb_rs1_o,
	 	  //EXCEPTION SIGNALS
		  output reg	[ 3:0]	wb_exception_o,
		  output reg 	[31:0]	wb_exc_data_o,
		  output reg 		wb_trap_valid_o,
		  output reg		wb_fence_op_o,
		  output reg		wb_xret_op_o
		  ); 
			
	wire 		ld_misaligned;
	wire 		st_misaligned;
	wire 		ld_access_flt;
	wire 		st_access_flt;
	wire [3:0]  	mem_exception;
	wire [31:0] 	mem_exc_data;
	wire 		mem_trap_valid;

	assign ld_misaligned = (mem_mread_o && mem_mword_o)? !(mem_result_i[1:0] == 0): ((mem_mread_o && mem_mhw_o)? !(mem_result_i[0] == 0): 1'b0);
	assign st_misaligned = (mem_mwrite_o && mem_mword_o)? !(mem_result_i[1:0] == 0): ((mem_mwrite_o && mem_mhw_o)? !(mem_result_i[0] == 0): 1'b0);
	assign ld_access_flt = (mem_mem_flags_i[1])? (mem_err_i): 1'b0;
	assign st_access_flt = (mem_mem_flags_i[0])? (mem_err_i): 1'b0;

	assign mem_mwrite_o 	= mem_mem_flags_i[5]; 
	assign mem_mread_o 	= mem_mem_flags_i[4]; 
	assign mem_mword_o 	= mem_mem_flags_i[3]; 
	assign mem_mhw_o 	= mem_mem_flags_i[2]; 
	assign mem_mbyte_o     	= mem_mem_flags_i[1]; 
	assign mem_munsigned_o 	= mem_mem_flags_i[0]; 

	reg [31:0] mem_result; 

	assign mem_exception_o  = mem_exception;
	assign mem_trap_valid_o = mem_trap_valid;


	assign forward_mem_dat_o = mem_result; 

	always @(*) begin 
		case(mem_mem_ex_sel_i) 
		  1'b0: mem_result = mem_result_i;
		  1'b1: mem_result = mem_data_i;
		 endcase
	end 

	localparam LD_MISALIGNED = 4'h4;
	localparam LD_ACCESS_FLT = 4'h5;
	localparam ST_MISALIGNED = 4'h6;
	localparam ST_ACCESS_FLT = 4'h7; 
	//EXCEPTIONS
	//
	always @(*) begin
		if(mem_trap_valid_i) begin
			mem_exception = mem_exception_i;
			mem_exc_data  = mem_exc_data_i;
			mem_trap_valid = mem_trap_valid_i;
		end else begin
			mem_trap_valid = (ld_misaligned | st_misaligned | ld_access_flt | st_access_flt);
			case(1'b1)
				ld_misaligned : begin mem_exception = LD_MISALIGNED; mem_exc_data = mem_result_i; end
				st_misaligned : begin mem_exception = ST_MISALIGNED; mem_exc_data = mem_result_i; end
				ld_access_flt : begin mem_exception = LD_ACCESS_FLT; mem_exc_data = mem_result_i; end 
				st_access_flt : begin mem_exception = ST_ACCESS_FLT; mem_exc_data = mem_result_i; end
			        default       : begin mem_exception = 0; mem_exc_data = 0; end 	
			endcase
		end 
	end 



	always @(posedge clk_i) begin
	wb_pc_o 		  <= (rst_i | wb_flush) ? 32'h0  : ((wb_stall)? wb_pc_o 			: mem_pc_i); 
	wb_instruction_o 	  <= (rst_i | wb_flush) ? 32'h33 : ((wb_stall)? wb_instruction_o 		: mem_instruction_i); 
	wb_result_o 		  <= (rst_i | wb_flush) ? 32'h0  : ((wb_stall)? wb_result_o 			: mem_result); 
	wb_rs1_o 		  <= (rst_i | wb_flush) ? 5'h0   : ((wb_stall)? wb_rs1_o 			: mem_rs1_i); 
	wb_waddr_o 		  <= (rst_i | wb_flush) ? 5'h0   : ((wb_stall)? wb_waddr_o 			: mem_waddr_i); 
	wb_we_o 		  <= (rst_i | wb_flush) ? 1'h0   : ((wb_stall)? wb_we_o 			: mem_we_i); 
	wb_exception_o 		  <= (rst_i | wb_flush) ? 4'h0   : ((wb_stall)? wb_exception_o 			: mem_exception); 
	wb_exc_data_o 		  <= (rst_i | wb_flush) ? 32'h0  : ((wb_stall)? wb_exc_data_o 			: mem_exc_data); 
	wb_trap_valid_o		  <= (rst_i | wb_flush) ? 1'h0   : ((wb_stall)? wb_trap_valid_o			: mem_trap_valid); 
	wb_csr_data_o 		  <= (rst_i | wb_flush) ? 32'h0  : ((wb_stall)? wb_csr_data_o 			: mem_csr_data_i); 
	wb_csr_addr_o 		  <= (rst_i | wb_flush) ? 12'h0  : ((wb_stall)? wb_csr_addr_o 			: mem_csr_addr_i); 
	wb_csr_op_o 		  <= (rst_i | wb_flush) ? 3'h0   : ((wb_stall)? wb_csr_op_o 			: mem_csr_op_i); 
	wb_fence_op_o	 	  <= (rst_i | wb_flush) ? 1'h0   : ((wb_stall)? wb_fence_op_o 			: mem_fence_op_i); 
	wb_xret_op_o	 	  <= (rst_i | wb_flush) ? 1'h0   : ((wb_stall)? wb_xret_op_o 			: mem_xret_op_i); 
	end	

endmodule 








