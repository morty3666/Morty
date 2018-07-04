

module morty_hazard_unit (
			  input 	id_illegal_i,
			  input 	ex_illegal_i,
			  input 	mem_illegal_i,
			  input 	id_xcall_break_i,	
			  input 	ex_xcall_break_i,	
			  input 	mem_xcall_break_i,
			  input		ex_csr_op_i, 	
			  input 	mem_csr_op_i,
			  input 	ex_ld_op_i,
			  input 	mem_ld_op_i,
			  input 	hazard_i,
			  output 	enable_fwd_o,
			  output 	illegal_stall_req_o,
			  output 	csr_stall_req_o,
	  		  output 	ld_stall_req_o,
			  output 	xcall_break_stall_req_o	  ); 

		
		  wire csr;
		  wire ld;
		  /* verilator lint_off UNOPTFLAT*/
		  wire xcall_break;
		  /* verilator lint_on UNOPTFLAT*/
		  wire illegal;
		  assign csr_stall_req_o 	 = csr;
		  assign ld_stall_req_o  	 = ld;
		  assign xcall_break_stall_req_o = xcall_break;
		  assign illegal_stall_req_o     = illegal;

		  assign illegal	= (id_illegal_i | ex_illegal_i | mem_illegal_i); 
		  assign csr 		= (hazard_i & (ex_csr_op_i | mem_csr_op_i));
		  assign ld  		= (hazard_i & (ex_ld_op_i  | mem_ld_op_i )); 
		  assign xcall_break 	= ((id_xcall_break_i | ex_xcall_break_i | mem_xcall_break_i)); 
		  assign enable_fwd_o	= ~(csr | ld | xcall_break); 

endmodule 
