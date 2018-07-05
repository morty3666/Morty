//`include "./dc_unit.v"
//`include "./mux21.v"
//`include "./mux41.v"
//`include "./def.v"
//`include "./reg_file.v"
//`include "./comparator.v"
//`include "./idex_register.v"

module morty_id_stage(
		 input 			clk_i,
		 input 			rst_i,
		 input  		ex_stall_i,
		 input 			ex_flush_i,
		 input 		[31:0] 	id_pc_i,
		 input 		[31:0] 	id_instruction_i,
		 input  	[31:0]	if_exc_data_i,
		 input 		[ 3:0] 	if_exception_i,
		 input 			if_trap_valid_i,
		 input  	[31:0] 	wb_data_i,
		 input  	[ 4:0] 	wb_address_i,
		 input  		wb_we_i,
		 input  	[31:0] 	ex_fwd_drd_i,
		 input  	[31:0] 	mem_fwd_drd_i,
		 input 		[31:0]  wb_fwd_drd_i,
		 input  	[ 1:0]  forward_a_sel_i,
		 input 		[ 1:0]	forward_b_sel_i,
		 output 	[ 4:0]	id_rs1_o,
		 output 	[ 4:0]	id_rs2_o, 
		 output 	[31:0] 	pc_branch_address_o,
		 output 	[31:0] 	pc_jump_address_o,
		 output 		take_branch_o,
		 output 		take_jump_o,
		 output reg 	[ 3:0]	id_exception_o,
		 output reg		id_trap_valid_o,
		 output 	[31:0]  ex_pc_o,
		 output 	[31:0]	ex_instruction_o,
		 output 	[31:0] 	ex_port_a_o,
		 output	 	[31:0] 	ex_port_b_o,
		 output 	[ 3:0] 	ex_alu_op_o,
		 output 	[ 4:0]  ex_rs1_o,
		 output 	[ 4:0] 	ex_waddr_o,
		 output 		ex_we_o,	
		 output 	[31:0]	ex_store_data_o,
		 output 	[ 5:0] 	ex_mem_flags_o,
		 output 		ex_mem_ex_sel_o,
		 output 		ex_fence_op_o,
		 output 		ex_xret_op_o,
		 output 	[ 3:0]	ex_exception_o,
		 output 		ex_trap_valid_o,
		 output 	[31:0]	ex_exc_data_o,
		 output		[31:0]	ex_csr_data_o,
		 output 	[2:0] 	ex_csr_op_o,
		 output 	[11:0]  ex_csr_addr_o
		 );

	wire [31:0] 	muxa_i;
	wire [31:0] 	muxb_i;	
	wire [ 4:0] 	rs1;
	wire [ 4:0] 	rs2;
	wire [31:0] 	drs1;
	wire [31:0] 	drs2;
	wire 		we;
	wire [ 3:0] 	alu_op;
	wire [ 2:0]	comparator_op;
	wire [31:0] 	imm;
	wire [31:0] 	_imm; 
	wire [4:0] 	waddr;
	wire 		portb_sel;
	wire		porta_sel;
	wire [31:0] 	port_a;
	wire [31:0] 	port_b; 
	wire [31:0]	_port_b;
	wire 		jalr_op;
	wire [5:0] 	mem_flags;
	wire 		mem_ex_sel;
	wire 		jump_op;
	// verilator lint_off UNUSED
	wire [31:0]	pc_jump;
	wire 		branch_op;
	wire 		take_branch;
	wire 		break_op;
	wire 		syscall_op;
	wire [31:0]	csr_data;
	wire [11:0]	csr_addr;
	wire [2:0] 	csr_op;
	wire 		csr_imm_op;
	wire 		fence_op;
	wire 		xret_op;
	wire 		illegal_inst; 
	wire 	[31:0]	id_store_data;
	wire 		shift_op;
	wire 	[31:0]	pc_mux;
	wire 		load_store_op;
	wire 		pc_jexc;
	wire		pc_bexc;
	wire 	[31:0]	id_exc_data;

	assign id_store_data		= muxb_i;
	assign take_branch_o		= (branch_op)? take_branch: 1'b0;
	assign take_jump_o		= jump_op;
	assign id_rs1_o 		= rs1;
	assign id_rs2_o			= rs2;
	assign _imm 		   	= ((jalr_op)? (($signed(imm) + $signed(muxa_i))) : (imm<<1));
	assign pc_jump			= (jalr_op)? _imm : id_pc_i  + _imm;
	assign pc_jump_address_o 	= {pc_jump[31:1], 1'b0}; 
	assign pc_jexc			= (jump_op)? ~(pc_jump_address_o[1:0] == 0): 1'b0;
	assign pc_branch_address_o   	= _imm + id_pc_i; 
	assign pc_bexc			= (branch_op)? ~(pc_branch_address_o[1:0] == 0): 1'b0;
	assign csr_data			= (csr_imm_op)? {27'b0, rs1} : port_a;  

	assign pc_mux			= (jump_op)? (id_pc_i + 4): id_pc_i;

	//EXCEPTION HANDLING 
	localparam INST_MISALIGNED 	= 4'h0;
	localparam ILLEGAL_INST 	= 4'h2;
	localparam BREAKPOINT		= 4'h3;
	localparam MCALL		= 4'hb;

	always @(*) begin
		if(if_trap_valid_i) begin
			id_exc_data   = if_exc_data_i;
			id_trap_valid_o = if_trap_valid_i; 
			id_exception_o  = if_exception_i;
		end else begin
			id_trap_valid_o	= (break_op|syscall_op|illegal_inst | (take_branch & pc_bexc) | pc_jexc);
			case(1'b1) 
				break_op   	: begin id_exception_o = BREAKPOINT;   id_exc_data = id_pc_i;end 
				syscall_op 	: begin id_exception_o = MCALL;        id_exc_data = 0; end
				illegal_inst  	: begin id_exception_o = ILLEGAL_INST; id_exc_data = id_instruction_i; end
				pc_bexc	& take_branch	: begin id_exception_o = INST_MISALIGNED; id_exc_data = pc_branch_address_o; end 
				pc_jexc		: begin id_exception_o = INST_MISALIGNED; id_exc_data = pc_jump_address_o; end 
				default 	: begin id_exception_o = 0; id_exc_data = 0; end 
			endcase 
		end 
	end 



	morty_mux21 SRA_MUX (
			.in_0(_port_b),
			.in_1({27'b0,_port_b[4:0]}),
			.sel(shift_op),
			.out(port_b));

	morty_mux21 PORT_A_MUX (
			.in_0(muxa_i),
			.in_1(pc_mux),
			.sel(porta_sel),
			.out(port_a) );
		
	morty_mux21 PORT_B_MUX (
			.in_0(muxb_i),
			.in_1(imm),
			.sel(portb_sel),
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
			.take_branch(take_branch));

	morty_reg_file RF  (
			.clk(clk_i),
			.raddr_rs1(rs1),
			.raddr_rs2(rs2),
			.waddr_rd(wb_address_i),
			.wdata_rd(wb_data_i),
			.we(wb_we_i),
			.rdata_rs1(drs1),
			.rdata_rs2(drs2) );

	morty_dc_unit    DCU  (	
			.instruction(id_instruction_i),
			.rs1(rs1),
			.rs2(rs2),
			.rd(waddr),
			.reg_write(we),
			.comparator_op(comparator_op),
			.mem_flags(mem_flags),
			.mem_ex_sel(mem_ex_sel),
			.alu_op(alu_op),
			.imm(imm),
			.portb_sel(portb_sel),
			.porta_sel(porta_sel),
			.branch_op(branch_op),
			.jump_op(jump_op),
			.jalr_op(jalr_op),
			.load_store_op(load_store_op),
			.illegal_inst(illegal_inst),
			.shift_op(shift_op),
			.fence_op(fence_op),
			.xret_op(xret_op),
			.syscall_op(syscall_op),
			.break_op(break_op),
		        .csr_addr(csr_addr),	
			.csr_op(csr_op),
			.csr_imm_op(csr_imm_op));
	
	morty_idex_register ID_EX (
			.clk(clk_i),
			.rst(rst_i),
			.stall(ex_stall_i),
			.flush(ex_flush_i),
			.id_pc(id_pc_i),
			.id_instruction(id_instruction_i),
			.id_alu_op(alu_op),
			.id_porta(port_a),
			.id_portb(port_b),
			.id_rs1(id_rs1_o),
			.id_store_data(id_store_data),
			.id_we(we),
			.id_mem_flags(mem_flags),
			.id_mem_ex_sel(mem_ex_sel),
			.id_fence_op(fence_op),
			.id_exception(id_exception_o),
			.id_exc_data(id_exc_data),
			.id_trap_valid(id_trap_valid_o),
			.id_xret_op(xret_op),
			.id_csr_data(csr_data),
			.id_csr_op(csr_op),
			.id_csr_addr(csr_addr),
			.id_waddr(waddr),
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







