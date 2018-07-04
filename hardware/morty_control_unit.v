

module morty_control_unit (
			input 		 rst_i,
			//PIPELINE CONTROL INPUT SIGNALS
			input 		 take_branch_i,
			input 		 if_stall_req_i,
			input   	 mem_stall_req_i,
			input 		 csr_stall_req_i,
			input 		 illegal_stall_req_i,
			input 		 ld_stall_req_i,
			input 		 xcall_break_stall_req_i,
			input 		 branch_bubble_req_i,
			input 		 jump_bubble_req_i,
			input 		 exception_stall_req_i,
			//DECODE INPUT SIGNALS 
			input 	[6:0]	 opcode,
			input 	[2:0]	 func3,
			input 	[6:0]	 func7,
			input 	[31:0]	 instruction,
			//CONTROL SIGNALS
			output reg [2:0] imm_sel_o,
			output 	[3:0]	 alu_op_o,
			output 	[2:0]	 comparator_sel_o,
			output 	[2:0]	 csr_op_o,
			output 		 csr_sel_o,
			output 		 jump_sel_o,
			output 		 shift_sel_o,
			output 		 mem_op_o,
			output 	[1:0]	 port_a_sel_o,
			output 	[1:0]	 port_b_sel_o,
			output 	[5:0]	 mem_flags_o,
			output 		 break_op_o,
			output 		 xcall_op_o,
			output 		 fence_op_o,
			output 		 xret_op_o,
			output 		 we_o,
			output 		 illegal_inst_o,
			output 		 if_kill_o,
			output reg [1:0] if_pc_sel_o,
			//STALLS
			output 		 if_stall_o, 
			output 		 id_stall_o,
			output 		 ex_stall_o,
			output  	 mem_stall_o,
			output 		 wb_stall_o,
			//BUBBLES
			output 	 	 if_bubble_o,
			output 	 	 id_bubble_o,
			output 	 	 ex_bubble_o,
			output 	 	 mem_bubble_o,
			output 		 wb_bubble_o  ); 

		wire 	illegal_nop;
		//PIPELINE CONTROL 
		assign  wb_stall_o  = 0;
		assign 	mem_stall_o = mem_stall_req_i ;
		assign 	ex_stall_o  = mem_stall_o; 
		assign  id_stall_o  = ex_stall_o | csr_stall_req_i | ld_stall_req_i; 
		assign  if_stall_o  = if_stall_req_i | id_stall_o ; 
		
       		//BUBBLE 
		assign illegal_nop  =  illegal_stall_req_i;	
		//FLUSHES
		assign if_kill_o    = (jump_bubble_req_i | branch_bubble_req_i) & ~(ex_bubble_o);
		assign if_bubble_o   = rst_i; 
		assign id_bubble_o   = (if_stall_req_i & ~(id_stall_o))| illegal_nop | if_kill_o | rst_i | exception_stall_req_i | xcall_break_stall_req_i;
		assign ex_bubble_o   =  rst_i | exception_stall_req_i | ld_stall_req_i | csr_stall_req_i;
		assign mem_bubble_o  =  rst_i | exception_stall_req_i;
		assign wb_bubble_o   =  rst_i | mem_stall_req_i; 

				//------------------------------DECODING------------------------
		wire 		mem_wr;
		wire 		mem_r;
		wire [2:0] 	mem_access;
		wire 		mem_unsigned;
		wire 		mem_ex_s;
		

		assign illegal_inst_o 	= illegal;
		assign mem_flags_o 	= {mem_wr,mem_r,mem_access,mem_unsigned,mem_ex_s};
		assign break_op_o	= _break;
		assign xcall_op_o	= call;
		assign fence_op_o	= |{fence,fencei};
		assign csr_op_o		= {rw,rc,rs};
		assign csr_sel_o	= |{rwi,rci,rsi};
		assign jump_sel_o	= jalr;
		assign shift_sel_o	= |{sll,srl,sra};
		assign mem_op_o	 	= mem_ex_s;
		assign inst		= instruction;


		wire [31:0]	inst;
		reg lui,auipc;
		reg jal, jalr; 
		reg beq, bne, blt, bge, bltu, bgeu; 
		reg lb, lh, lw, lbu, lhu;
		reg sb, sh, sw;
		reg addi, slti, sltiu, xori, ori, andi, slli, srli, srai;
		reg add, sub, sll, slt, sltu, _xor, srl, sra, _or, _and;
		reg fence, fencei; 
		reg xret;
		reg rw, rs, rc, rwi, rsi, rci;
		reg call, _break;

		reg is_b, is_imm, is_st, is_ld, is_j;//flags for immediate generation
		reg is_add, is_sub, is_and, is_xor, is_or, is_sll, is_sr, is_slt, is_sltu; //arithmetic operations flags
		reg is_wr, is_immop, is_ldu, is_csri, is_csr; //external flags
		reg is_word,is_byte,is_hw, imm_i, is_s, imm_s, imm_b, imm_shf, imm_j, imm_u, is_srl, is_sra, sltui, is_write, is_pc; 
		reg illegal;

		//DECODE INSTRUCTION
		always @(*) begin
			//
			lui 	= opcode == `lui_op;
			auipc 	= opcode == `auipc_op;
			//JUMP OPERATIONS
			jal 	= opcode == `jal_op;
			jalr	= opcode == `jalr_op;
			//BRANCH OPERATIONS
			beq	= opcode == `br_op  && func3 == `beq_f3;
			bne	= opcode == `br_op  && func3 == `bne_f3;
			blt	= opcode == `br_op  && func3 == `blt_f3;
			bge	= opcode == `br_op  && func3 == `bge_f3;
			bltu	= opcode == `br_op  && func3 == `bltu_f3;
			bgeu	= opcode == `br_op  && func3 == `bgeu_f3;
			//LOAD OPERATIONS
			lb	= opcode == `ld_op  && func3 == `lb_f3;
			lh	= opcode == `ld_op  && func3 == `lh_f3;
			lw	= opcode == `ld_op  && func3 == `lw_f3;
			lbu	= opcode == `ld_op  && func3 == `lbu_f3;
			lhu	= opcode == `ld_op  && func3 == `lhu_f3;
			//STORE OPERATIONS
			sb	= opcode == `st_op  && func3 == `sb_f3;
			sh	= opcode == `st_op  && func3 == `sh_f3;
			sw	= opcode == `st_op  && func3 == `sw_f3;
			//INMEDIATE OPERATIONS
			addi	= opcode == `imm_op && func3 == `addi_f3;
			slti	= opcode == `imm_op && func3 == `slti_f3;	
			sltiu	= opcode == `imm_op && func3 == `sltiu_f3;
			xori	= opcode == `imm_op && func3 == `xori_f3;
			ori	= opcode == `imm_op && func3 == `ori_f3;
			andi	= opcode == `imm_op && func3 == `andi_f3;
			slli	= opcode == `imm_op && func3 == `slli_f3    && func7 == `slli_f7;
			srli	= opcode == `imm_op && func3 == `sr_f3      && func7 == `srli_f7;
			srai	= opcode == `imm_op && func3 == `sr_f3      && func7 == `srai_f7;
			//ALU OPERATIONS
			add	= opcode == `alu_op && func3 == `add_sub_f3 && func7 == `alu_f7;
			sub 	= opcode == `alu_op && func3 == `add_sub_f3 && func7 == `sub_f7;
			slt	= opcode == `alu_op && func3 == `slt_f3     && func7 == `alu_f7;	
			sltu	= opcode == `alu_op && func3 == `sltu_f3    && func7 == `alu_f7;
			_xor	= opcode == `alu_op && func3 == `xor_f3     && func7 == `alu_f7;
			_or	= opcode == `alu_op && func3 == `or_f3      && func7 == `alu_f7;
			_and	= opcode == `alu_op && func3 == `and_f3     && func7 == `alu_f7;
			sll	= opcode == `alu_op && func3 == `sll_f3     && func7 == `alu_f7;
			srl	= opcode == `alu_op && func3 == `sr_f3      && func7 == `alu_f7;
			sra	= opcode == `alu_op && func3 == `sr_f3      && func7 == `sra_f7;
			//SPECIAL OPERATIONS
			fence   = opcode == `fence  && func3 == `fe_f3;
		        fencei  = opcode == `fence  && func3 == `fei_f3;
			rw	= opcode == `sp_op  && func3 == `rw_f3; 
			rs	= opcode == `sp_op  && func3 == `rs_f3;
			rc	= opcode == `sp_op  && func3 == `rc_f3;
			rwi	= opcode == `sp_op  && func3 == `rwi_f3;
			rsi	= opcode == `sp_op  && func3 == `rsi_f3;
			rci	= opcode == `sp_op  && func3 == `rci_f3;
			call	= opcode == `sp_op  && inst[31:7] == `syscall;
			_break	= opcode == `sp_op  && inst[31:7] == `break; 
			xret	= opcode == `ret    && inst[31:30] == 2'b0 && inst[27:7] == 21'b0_0000_0100_0000_0000_0000;

			is_word = |{lw,sw};
			is_hw 	= |{lh,lhu,sh};
			is_byte	= |{lb,lbu,sb};
			is_ldu	= |{lbu,lhu};
			is_j 	= |{jal,jalr}; 
			is_b    = |{beq,bne,blt,bltu,bge,bgeu}; 
			is_ld   = |{lb,lbu,lh,lhu,lw};
			is_st   = |{sb,sh,sw};
			is_imm  = |{addi, slti,sltiu,xori,ori,andi}; 
			imm_i	= |{is_ld,is_imm, jalr};
			imm_s	= |{is_s}; 
			imm_b   = |{is_b};
			imm_shf	= |{slli,srli,srai};
			imm_j	= |{jal};
			imm_u	= |{lui,auipc};
			is_add  = |{lui,auipc,add,addi,is_ld,is_st}; 
			is_sub  = |{sub}; 
			is_and	= |{_and,andi}; 
			is_or   = |{_or,ori};
			is_xor  = |{_xor,xori};
			is_sll  = |{sll,slli};
			is_srl	= |{srl,srli};
			is_sra	= |{sra,srai};
			is_slt  = |{slt,slti};
			is_sltu	= |{sltu,sltui};
			is_csr	= |{rw,rs,rc};
			is_csri	= |{rwi,rsi,rci};

			is_write 	= |{is_b,is_st,fence,fencei,xret,call,_break};
			is_immop 	= |{imm_i,imm_s,imm_b,imm_shf,imm_j,imm_u};
			is_pc	 	= |{auipc,jalr}; 
			illegal 	= ~|{imm_u,is_j,is_b,is_ld,is_st,is_imm,is_sll,is_srl,is_sra,add,sub,sll,slt,sltu,_xor,_or,_and,fence,fencei,call,_break,is_csr,is_csri,xret}; 
			

		end 

				//IMMEDIATE GENERATOR
		always @(*) begin
			case(1'b1)	
				imm_i  	: 	imm_sel_o = 3'b000; 
				imm_s  	: 	imm_sel_o = 3'b001;
				imm_b  	: 	imm_sel_o = 3'b010; 
				imm_shf	: 	imm_sel_o = 3'b011;
				imm_j	:	imm_sel_o = 3'b100;
				imm_u	: 	imm_sel_o = 3'b101;
				default : 	imm_sel_o = 3'b111; 
			endcase
		end 
		
		//MEMORY CONTROL SIGNALS 
		assign mem_wr 	    = is_st; 
		assign mem_r  	    = is_ld;
	        assign mem_access   = {is_word,is_hw,is_byte};	
		assign mem_ex_s     = is_ld; 
		assign mem_unsigned = is_ldu;

		//COMPARATOR OP
		
		always @(*) begin
			case(1'b1)
				beq  : comparator_sel_o = 3'b001;
				bne  : comparator_sel_o = 3'b010;
				blt  : comparator_sel_o = 3'b011;
				bge  : comparator_sel_o = 3'b100;
				bltu : comparator_sel_o = 3'b101;
				bgeu : comparator_sel_o = 3'b110;
				default: comparator_sel_o = 3'b0;
			endcase
		end
				
		//ALU_OP
		
		always @(*) begin
			case(1'b1)
				is_add : alu_op_o = 4'b0000; 
				is_sub : alu_op_o = 4'b0001;
				is_and : alu_op_o = 4'b0010;
				is_or  : alu_op_o = 4'b0011;
				is_xor : alu_op_o = 4'b0100;
				is_sll : alu_op_o = 4'b0101;
				is_srl : alu_op_o = 4'b0111;
				is_sra : alu_op_o = 4'b0110;
				is_slt : alu_op_o = 4'b1000;
				is_sltu: alu_op_o = 4'b1001;
			        default: alu_op_o = 4'b1111;	
			endcase
		end 

		//ALU_PORT SELECTION
		always @(*) begin 
			case(1'b1) 
				is_j:		port_b_sel_o = 2'b10;
				is_immop: 	port_b_sel_o = 2'b01;
				default:	port_b_sel_o = 2'b00;
			endcase
		end

		always @(*) begin 
			case(1'b1) 
				imm_u:		port_a_sel_o = 2'b01;
				default:	port_b_sel_o = 2'b00;
			endcase
		end


		// PC selector
		always @(*) begin
			case(1'b1)
				is_b & take_branch_i:	if_pc_sel_o = 2'b01;
				is_j: 			if_pc_sel_o = 2'b10;
				exception_stall_req_i:	if_pc_sel_o = 2'b11;
				default: 		if_pc_sel_o = 2'b00;
			endcase
		end 
		


endmodule 	

