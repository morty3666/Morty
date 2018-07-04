
module morty_csr_exception_unit #(
		parameter ENABLE_COUNTERS=1,
		parameter RESET_ADDR=32'h0000_0000
		)(	
		//CSR signals
		input 			clk_i,
		input 			rst_i,
		input 	[11:0]		csr_addr_i,
	       	input 	[31:0]		csr_dat_i,
		input 	[ 2:0]		csr_op_i,
		input 	[ 4:0]		csr_rs1_i,
		//EXCEPTION UNIT SIGNALS
		input 			xint_meip_i,
		input 			xint_mtip_i,
		input 			xint_msip_i,
		/* verilator lint_off UNUSED*/
		input 	[31:0]		exception_pc_i,
		input 	[31:0]		exception_inst_i,
		input 	[31:0]		exc_data_i,
		input 	[ 3:0]		exception_i,
		input 			trap_valid_i,
		input 			inst_fence_i,
		input 			inst_xret_i,
		output 			exception_stall_req_o,
		output reg [31:0]	exception_pc_o,
		/* verilator lint_off UNDRIVEN */
		output 			exception_sel_flag_o,
		output reg [31:0]	csr_dat_o	); 

	localparam HART_ID	= 0;
	localparam MHARTID	= 12'hf14;
	localparam MVENDORID	= 12'hf11;
	localparam MARCHID	= 12'hf12;
	localparam MIMPID	= 12'hf14;
	localparam MSTATUS	= 12'h300;
	localparam MISA		= 12'h301;
	localparam MEDELEG	= 12'h302;
	localparam MIDELEG	= 12'h303;
	localparam MIE		= 12'h304;
	localparam MTVEC	= 12'h305;
	localparam MCOUNTEREN	= 12'h306;
	localparam MSCRATCH	= 12'h340; 
	localparam MEPC		= 12'h341;
	localparam MCAUSE	= 12'h342;
	localparam MTVAL	= 12'h343;
	localparam MIP		= 12'h344; 
	localparam MCYCLE	= 12'hb00;
	localparam MINSTRET	= 12'hb02;
	localparam MCYCLEH	= 12'hb80;
	localparam MINSTRETH	= 12'hb82;

	localparam INST_ADDR_MISALIGNED 	= 4'h0;
	localparam INST_ACCESS_FAULT		= 4'h1;
	localparam ILLEGAL_INST			= 4'h2;
	localparam BREAKPOINT			= 4'h3;
	localparam LOAD_ADDR_MISALIGNED 	= 4'h4;
	localparam LOAD_ACCESS_FAULT		= 4'h5;
	localparam STORE_ADDR_MISALIGNED 	= 4'h6;
	localparam STORE_ACCESS_FAULT		= 4'h7;
	localparam MCALL			= 4'hb;
	localparam I_SOFTWARE			= 4'h3;
	localparam I_TIMER			= 4'h7;
	localparam I_EXTERNAL			= 4'hb;

	reg [31:0]	csr_wdata;
	reg [31:0] 	mstatus;
	reg [31:0] 	mie;
	reg [31:0] 	mtvec; 
	reg [31:0] 	mscratch;
	reg [31:0] 	mepc;
	reg [31:0] 	mcause; 
	reg [31:0]	mtval;
	reg [31:0] 	mip;
	reg [63:0] 	mcycle;
	reg [63:0] 	minstret;
	reg 		wen;
	wire 		undef_register;
	reg 		mstatus_mpie;
	reg		mstatus_mie;
	reg 		mie_meie;
	reg		mie_mtie;
	reg		mie_msie;

	reg 	[ 3:0]	icode;
	reg 	[31:0]	pend_int;
	reg		interrupt;
	
	reg 		mcause_int; 
	reg 	[3:0]	mcause_exc; 

	reg 		is_misa, is_mhartid, is_mvendorid, is_marchid;
	reg		is_mimpid, is_mstatus, is_mie, is_mtvec, is_mepc;
	reg		is_mcause, is_mtval, is_mip, is_mcycle, is_minstret;
	reg		is_mcycleh, is_minstreth, is_mscratch; 


	assign exception_stall_req_o = (trap_valid_i) | inst_xret_i; 

	always @(*) begin
		if(trap_valid_i | interrupt) begin
			exception_pc_o 	 = mtvec; 
		end else if(inst_xret_i) begin
			exception_pc_o = mepc;
		end 
	end

	always @(*) begin
		if(interrupt) begin
			case(1'b1) 
				pend_int[11]: icode = I_SOFTWARE;
				pend_int[7] : icode = I_TIMER;
				pend_int[3] : icode = I_EXTERNAL;
			endcase
		end
	end	

	//WRITE REGISTERS
	always @(posedge clk_i) begin 
		mstatus <= {19'b0, 2'b11, 3'b0, mstatus_mpie, 3'b0, mstatus_mie, 3'b0}; 
		mip	<= {20'b0, xint_meip_i, 3'b0, xint_mtip_i, 3'b0, xint_msip_i, 3'b0};
		mie	<= {20'b0, mie_meie, 3'b0, mie_mtie, 3'b0, mie_msie, 3'b0};
	        mcause  <= {mcause_int, 27'b0, mcause_exc}; 	
	end 

	always @(*) wen	= (csr_rs1_i != 0); 
	//INTERRUPTS 
	//
	always @(*) begin
		pend_int  = mstatus_mie? mip & mie: 32'b0;
		interrupt = |{pend_int[11], pend_int[7], pend_int[3]};
	end 	

	//DETERMINE REGISTER TO BE USE
	always @(*) begin
		is_misa 	= csr_addr_i == MISA; 
		is_mhartid 	= csr_addr_i == MHARTID; 
		is_mvendorid 	= csr_addr_i == MVENDORID; 
		is_marchid 	= csr_addr_i == MARCHID; 
		is_mimpid 	= csr_addr_i == MIMPID; 
		is_mstatus 	= csr_addr_i == MSTATUS; 
		is_mie 		= csr_addr_i == MIE; 
		is_mtvec 	= csr_addr_i == MTVEC; 
		is_mscratch	= csr_addr_i == MSCRATCH; 
		is_mepc 	= csr_addr_i == MEPC; 
		is_mcause 	= csr_addr_i == MCAUSE; 
		is_mtval 	= csr_addr_i == MTVAL;
	        is_mip		= csr_addr_i == MIP; 	
		is_mcycle 	= csr_addr_i == MCYCLE; 
	       	is_minstret	= csr_addr_i == MINSTRET; 
		is_mcycleh	= csr_addr_i == MCYCLEH; 
		is_minstreth	= csr_addr_i == MINSTRETH; 
	
	end 	
		
	//DECODE OPERATION AND ASSIGN INPUT DATA
	always @(*) begin
		case(csr_op_i)
			3'b001: csr_wdata = csr_dat_i;
			3'b010: csr_wdata = csr_dat_o | csr_dat_i;
			3'b100: csr_wdata = csr_dat_o & ~csr_dat_i;
			default: csr_wdata = 32'b0;
		endcase 
	end 
	//WRITING ------------------------------------------------------------
	//MCYCLE
	always @(posedge clk_i) begin
		if (ENABLE_COUNTERS) begin
			if(rst_i) begin
				mcycle <= 0; 
			end else begin
				case (1'b1) 
					wen && is_mcycle:  mcycle[31:0]  <= csr_wdata; 
					wen && is_mcycleh: mcycle[63:32] <= csr_wdata;
					default 	mcycle <= mcycle + 1; 
				endcase
			end 
		end else begin 
			mcycle <= 64'hx; 
		end 
	end 

	wire 	xcall;
	wire 	xbreak;

	assign 	xcall 	= (exception_i == 4'hb);
	assign 	xbreak 	= (exception_i == 4'h3);
	//MINSTRET------------------------------------------------------------
	always @(posedge clk_i) begin
		if(ENABLE_COUNTERS) begin
			if(rst_i) begin
				minstret <= 0; 
			end else begin
				case(1'b1)
					wen && is_minstret: 		 	minstret[31: 0] <= csr_wdata;
					wen && is_minstreth:		 	minstret[63:32] <= csr_wdata;
//					instruction_ret:		 	minstret	 <= minstret + 1;
					inst_fence_i:			 	minstret	 <= minstret + 1;
					inst_xret_i:			 	minstret	 <= minstret + 1;
					trap_valid_i && (xcall || xbreak ): 	minstret 	 <= minstret + 1;
				endcase
			end 
		end else begin
			minstret <= 64'hx;
		end
	end 
	

	always @(posedge clk_i) begin
		if(rst_i) begin
			mstatus_mpie <= 0;
			mstatus_mie  <= 0;
		end else if(trap_valid_i) begin
			mstatus_mpie <= mstatus_mie;
			mstatus_mie   <= 0;
		end else if(inst_xret_i) begin
			mstatus_mpie <= 1;
			mstatus_mie  <= mstatus_mpie;
		end else if (wen && is_mstatus) begin
			mstatus_mpie <= csr_wdata[7];
			mstatus_mie  <= csr_wdata[3];
		end 
	end 

	always @(posedge clk_i) begin
		if(rst_i) mepc <= 0; 
		else if (trap_valid_i) mepc <= {exception_pc_i[31:2], 2'b0};
		else if (wen && is_mepc) mepc <= {csr_wdata[31:2], 2'b0};
	end 

	always @(posedge clk_i) begin
		if(rst_i) begin
			mcause_int <= 0;
			mcause_exc <= ILLEGAL_INST;
		end else if (trap_valid_i) begin
			mcause_int <= interrupt;
			mcause_exc <= exception_i;
		end else if( wen && is_mcause) begin
			mcause_int <= csr_wdata[31];
			mcause_exc <= csr_wdata[3:0];
		end 
	end 

	always @(posedge clk_i) begin
		if(trap_valid_i) begin
			mtval <= exc_data_i;
		end else if( wen && is_mtval) begin
			mtval <= csr_wdata;
		end 
	end 

	always @(posedge clk_i) begin
		if(rst_i) begin
			mie_meie <= 0;
			mie_mtie <= 0;
			mie_msie <= 0;
		end else if (wen && is_mie) begin
			mie_meie <= csr_wdata[11];
			mie_mtie <= csr_wdata[7];
			mie_msie <= csr_wdata[3];
		end 
	end 

	always @(posedge clk_i) begin
		if(rst_i) begin
			mtvec <= RESET_ADDR;
		end else if (wen) begin
			case(1'b1)
				is_mtvec: 	mtvec   <= csr_wdata;
				is_mscratch:	mscratch <= csr_wdata;
			endcase
		end
	end 

	always @(*) begin
		case(1'b1)
			is_misa:				csr_dat_o = 32'b01_0000_00000000000000000010000000; 
			is_mhartid:				csr_dat_o = HART_ID; 
			|{is_mvendorid,is_marchid,is_mimpid}:	csr_dat_o = 0;
			is_mstatus:				csr_dat_o = mstatus;
			is_mie:					csr_dat_o = mie;
			is_mtvec:				csr_dat_o = mtvec;
			is_mscratch: 				csr_dat_o = mscratch;
			is_mepc:				csr_dat_o = mepc;
			is_mcause:				csr_dat_o = mcause;
			is_mtval:				csr_dat_o = mtval;
			is_mip:					csr_dat_o = mip;
			|{is_mcycle, is_mcycleh}:		csr_dat_o = is_mcycle? mcycle[31:0]: mcycle[63:32];
			|{is_minstret, is_minstreth}:		csr_dat_o = is_minstret? minstret[31:0]: minstret[63:32];
			default:				csr_dat_o = 0;
		endcase
	end
endmodule 
