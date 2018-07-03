//`include "clk_gen.v"
//`include "pc_reg.v"
//`include "pc_source.v"
//`include "pc_add.v"
//`include "ifid_reg.v"
//`include "bram.v"

module morty_if_stage #(
		parameter [31:0] RESET_ADDR = 32'h0000_0000
		)(
		input  		clk_i,
		input  		rst_i,
		input  		if_stall,
		input 		if_flush,
		input 		id_stall,
		input 		id_bubble,
		input  [31:0]	if_instruction_i,
		input  [31:0]	pc_branch_address_i,
		input  [31:0] 	pc_jump_address_i,
		input  [31:0]	exception_pc_i,
		input  [ 1:0] 	if_pc_sel_i,
		input 		if_inst_access_fault_i,
		output [31:0]	if_pc_o,
		output [31:0] 	id_instruction_o,
		output [31:0] 	id_pc_o,
		output [ 3:0]	if_exception_o,
		output [31:0]	if_exc_data_o,
		output 		if_trap_valid_o	); 

	localparam INST_ADDR_MISALIGNED = 4'h0;
	localparam INST_ACCESS_FAULT	= 4'h1;

	wire 	[31:0] 	if_pc_mux; 
	wire 	[31:0] 	if_pc_add4;
	wire 	[ 3:0] 	if_exception;
	wire 	    	trap_valid;
	wire 	    	addr_misaligned;
       	wire 	[31:0]	exc_data;	
	assign 	   	addr_misaligned = ~(if_pc_o[1:0] == 0);
	assign 		exc_data   	= if_pc_o; 
	assign	   	trap_valid 	= (if_inst_access_fault_i | addr_misaligned ); 
	assign		if_exception 	= (if_inst_access_fault_i)? INST_ACCESS_FAULT : ((addr_misaligned)? INST_ADDR_MISALIGNED: 4'b0);

	morty_pc_reg  #(.RESET_ADDR(RESET_ADDR))
			PC_REG(.clk_i(clk_i),
				.rst_i(rst_i),
				.stall(if_stall),
				.flush(if_bubble),
				.pc_i(if_pc_mux),
				.pc_o(if_pc_o) );
	morty_pc_add PC_ADD   (
				.pc(if_pc_o),
				.pc_next(if_pc_add4));

	morty_pc_source PC_SOURCE(
				.in0(if_pc_add4),
				.in1(pc_branch_address_i),
				.in2(pc_jump_address_i),
				.in3(exception_pc_i),
				.sel(if_pc_sel_i),
				.out(if_pc_mux) ); 
	
	
	morty_ifid_reg IF_ID (
				.clk(clk_i),
				.rst(rst_i),
				.id_stall(id_stall),
				.id_bubble(id_bubble),
				.if_pc(if_pc_o),
				.if_exception_i(if_exception),
				.if_trap_valid(trap_valid),
				.if_exc_data(exc_data),
				.if_inst(if_instruction_i),
				.id_pc(id_pc_o),
				.id_inst(id_instruction_o),
				.if_exception_o(if_exception_o),
				.id_exc_data(if_exc_data_o),
				.id_trap_valid(if_trap_valid_o)	); 
endmodule 	
		
	

