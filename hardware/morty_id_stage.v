
module morty_id_stage(
		 input 			clk_i,
		 input 			rst_i,
		 // ID/EX register control signals
		 input  		ex_stall_i,
		 input 			ex_bubble_i,
		 //------------------------------
		 // IF => ID 
		 input 		[31:0] 	id_pc_i,
		 input 		[31:0] 	id_instruction_i,
		 input 		[31:0]	if_exc_data_i,
		 input 		[ 3:0]	if_exception_i,
		 input 			if_trap_valid_i,
		 //------------------------------
		 // WB => ID
		 input  	[31:0] 	wb_data_i,
		 input  	[ 4:0] 	wb_address_i,
		 input  		wb_we_i,
		 // --------------------------------
		 // FORWARDING DATA FROM OTHER STAGES
		 // --------------------------------
		 // EX => ID
		 input  	[31:0] 	ex_fwd_drd_i,
		 // --------------------------------
		 // MEM => ID
		 input  	[31:0] 	mem_fwd_drd_i,
		 // WB => ID
		 input 		[31:0]  wb_fwd_drd_i,
		 //---------------------------------
		 // CSR control signals
		 input 		[2:0]	csr_op_i,
		 input 			csr_sel_i,
		 input 			jump_sel_i,
		 input 		[2:0]   comparator_sel_i,
		 input 		[3:0]	alu_op_i,
		 input 			shift_sel_i,
		 input 			mem_op_i,
		 input 		[1:0]	port_a_sel_i,	
		 input 		[1:0]	port_b_sel_i,
		 input 		[5:0]	mem_flags_i,
		 input 		[2:0]	imm_sel_i,
		 input 			break_op_i,
		 input 			xcall_op_i,
		 input 			fence_op_i,
		 input 			xret_i,
		 input 			we_i,
		 // CONTROL for FWD
		 input  	[ 1:0]  forward_a_sel_i,
		 input 		[ 1:0]	forward_b_sel_i,	
		 //---------------------------------
		 // ID => FWD 
		 output 	[ 4:0]	id_rs1_o,
		 output 	[ 4:0]	id_rs2_o, 
		 //---------------------------------
		 // ID => IF
		 output 	[31:0] 	pc_branch_address_o,
		 output 	[31:0] 	pc_jump_address_o,
		 // -------------------------------
		 //
		 output 		take_branch_o,
		 //EXCEPTIONS 
		 output reg 	[ 3:0]	id_exception_o,
		 output reg		id_trap_valid_o,
		 output reg	[31:0]	id_exc_data_o,
		 
		 output 	[31:0]	ex_pc_o,
		 output 	[31:0]	ex_instruction_o,
		 output 	[31:0] 	ex_port_a_o,
		 output 	[31:0] 	ex_port_b_o,
		 output		[ 3:0] 	ex_alu_op_o,
		 output 	[ 4:0]  ex_rs1_o,
		 output 	[ 4:0] 	ex_waddr_o,
		 output 		ex_we_o,	
		 output 	[31:0]	ex_store_data_o,
		 output 	[ 5:0] 	ex_mem_flags_o,
		 output 		ex_mem_ex_sel_o,
		 output 		ex_fence_op_o,
		 output 		ex_xret_op_o,
		 //EXCEPTIONS 
		 output 	[ 3:0]	ex_exception_o,
		 output 	[31:0]	ex_exc_data_o,
		 output 		ex_trap_valid_o,
		 // CSR signals
		 output		[31:0]	ex_csr_data_o,
		 output 	[2:0] 	ex_csr_op_o,
		 output 	[11:0]  ex_csr_addr_o
		 );

	wire [31:0] 	muxa_i;
	wire [31:0] 	muxb_i;	
	//REG FILE
	wire [ 4:0] 	rs1;
	wire [ 4:0] 	rs2;
	wire [31:0] 	drs1;
	wire [31:0] 	drs2;
	wire 		we;
	wire [31:0]	imm;
	wire [4:0] 	waddr;
	wire [31:0] 	port_a;
	wire [31:0] 	port_b; 
	wire [31:0]	_port_b;
	// verilator lint_off UNUSED
	wire [31:0]	pc_jump;
	// CSR 
	wire [31:0]	csr_data;
	wire [11:0]	csr_addr;
	wire 		illegal_inst; 
	wire [31:0]	store_data;

	wire [31:0]	exc_data;
	wire [ 3:0]	exception;
	wire 		trap_valid;

	wire 		pc_jexc;
	wire 		pc_bexc;



	assign waddr	 		= id_instruction_i[11:7];
	assign id_rs1_o 		= id_instruction_i[19:15];
	assign id_rs2_o			= id_instruction_i[24:20];
	assign pc_jump			= (jump_sel_i)? (imm + drs1) : id_pc_i  + imm;
	assign pc_jump_address_o 	= (jump_sel_i)? {pc_jump[31:1], 1'b0}: pc_jump; 
	assign pc_branch_address_o  	= imm + id_pc_i; 
	assign pc_jexc			= (jump_sel_i)? ~(pc_jump_address_o[1:0] == 0): 1'b0;
	assign pc_bexc			= (take_branch_o)? ~(pc_branch_address_o[1:0] == 0): 1'b0;
	assign csr_data			= (csr_sel_i)? {27'b0, rs1} : port_a;  
	assign csr_addr			= id_instruction_i[31:20]; 
        assign store_data		= muxb_i; 

	//EXCEPTION HANDLING 
	localparam INST_MISALIGNED 	= 4'h0;
	localparam ILLEGAL_INST 	= 4'h2;
	localparam BREAKPOINT		= 4'h3;
	localparam MCALL		= 4'hb;

	always @(*) begin
		if(if_trap_valid_i) begin
			id_exc_data_o   = if_exc_data_i;
			id_trap_valid_o = if_trap_valid_i; 
			id_exception_o  = if_exception_i;
		end else begin
			trap_valid	= (break_op_i|xcall_op_i|illegal_inst | (take_branch_o & pc_bexc) | pc_jexc);
			case(1'b1) 
				break_op_i 		: begin id_exception_o = BREAKPOINT;   	  id_exc_data_o = id_pc_i;end 
				xcall_op_i		: begin id_exception_o = MCALL;        	  id_exc_data_o = 0; end
				illegal_inst		: begin id_exception_o = ILLEGAL_INST; 	  id_exc_data_o = id_instruction_i; end
				pc_bexc	& take_branch	: begin id_exception_o = INST_MISALIGNED; id_exc_data_o = pc_branch_address_o; end 
				pc_jexc			: begin id_exception_o = INST_MISALIGNED; id_exc_data_o = pc_jump_address_o; end 
				default 		: begin id_exception_o = 0;		  id_exc_data_o = 0; end 
			endcase 
		end 
	end 


	morty_mux21 SRA_MUX (
			.in_0(_port_b),
			.in_1({27'b0,_port_b[4:0]}),
			.sel(shift_op),
			.out(port_b));


	morty_mux31 PORT_A_MUX (
			.in_0(muxa_i),
			.in_1(id_pc_i),
			.in_2(id_pc_i + 4),
			.sel(porta_sel_i),
			.out(port_a) );
		
	morty_mux21 PORT_B_MUX (
			.in_0(muxb_i),
			.in_1(imm_i),
			.in_2(0),
			.sel(portb_sel_i),
			.out(_port_b));


	morty_mux41 FORWARD_A_MUX (
			.in_0(drs1),
			.in_1(ex_fwd_drd_i),
			.in_2(mem_fwd_drd_i),
			.in_3(wb_fwd_drd_i),
			.sel(forward_a_sel_i),
			.out(muxa_i) ); 

	morty_mux41 FORWARD_B_MUX (
			.in_0(drs2),
			.in_1(ex_fwd_drd_i),
			.in_2(mem_fwd_drd_i),
			.in_3(wb_fwd_drd_i),
			.sel(forward_b_sel_i),
			.out(muxb_i) ); 
	
	morty_comparator BP (
			.sel(comparator_op),
			.drs1(muxa_i),
			.drs2(muxb_i),
			.take_branch(take_branch_o));

	morty_reg_file RF  (
			.clk(clk_i),
			.raddr_rs1(rs1),
			.raddr_rs2(rs2),
			.waddr_rd(wb_address_i),
			.wdata_rd(wb_data_i),
			.we(wb_we_i),
			.rdata_rs1(drs1),
			.rdata_rs2(drs2) );


	morty_imm_gen IMM (
			.instruction(id_instruction_i),
			.imm_sel_i(imm_sel_i),
			.imm_o(imm)	);	

	
	morty_idex_register ID_EX (
			.clk(clk_i),
			.rst(rst_i),
			.stall(ex_stall_i),
			.bubble(ex_bubble_i),
			.id_pc(id_pc_i),
			.id_instruction(id_instruction_i),
			.id_alu_op(alu_op_i),
			.id_porta(port_a),
			.id_portb(port_b),
			.id_rs1(id_rs1_o),
			.id_store_data(store_data),
			.id_waddr(waddr),
			.id_we(we_i),
			.id_mem_flags(mem_flags_i),
			.id_mem_ex_sel(mem_op_i),
			.id_exception(id_exception_o),
			.id_trap_valid(id_trap_valid_o),
			.id_exc_data(id_exc_data_o),
			.id_fence_op(fence_op),
			.id_xret_op(xret_op),
			.id_csr_data(csr_data),
			.id_csr_op(csr_op),
			.id_csr_addr(csr_addr),
			//OUTPUTS
			.ex_pc(ex_pc_o),
			.ex_instruction(ex_instruction_o),
			.ex_porta(ex_port_a_o),
			.ex_portb(ex_port_b_o),
			.ex_alu_op(ex_alu_op_o),
			.ex_we(ex_we_o),
			.ex_rs1(ex_rs1_o),
			.ex_store_data(ex_store_data_o),
			.ex_mem_flags(ex_mem_flags_o),
			.ex_mem_ex_sel(ex_mem_ex_sel_o),
			.ex_exception(ex_exception_o),
			.ex_exc_data(ex_exc_data_o),
			.ex_trap_valid(ex_trap_valid_o),
			.ex_fence_op(ex_fence_op_o),
			.ex_xret_op(ex_xret_op_o),
			.ex_csr_data(ex_csr_data_o),
			.ex_csr_op(ex_csr_op_o),
			.ex_csr_addr(ex_csr_addr_o),
			.ex_waddr(ex_waddr_o)
		);



endmodule







