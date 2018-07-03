
//`include "def.v"

module titan_dc_unit (
		input 		[31:0] 	instruction,
		//ID STAGE SIGNALS
		output 		[4:0] 	rs1, 
		output 		[4:0] 	rs2,
		output 		[4:0]	rd,
		output 			reg_write,
		output reg 	[2:0] 	comparator_op,
		//MEM STAGE CONTROL SIGNALS
		output 		[5:0] 	mem_flags,
		output 			mem_ex_sel,
		//EX STAGE CONTROL SIGNALS
		output reg 	[3:0] 	alu_op, 	
		output reg 	[31:0] 	imm,
		output reg 		portb_sel,
		output reg 		porta_sel,
		output 			illegal_inst,
		output 			xret_op,
		output 			load_store_op,
		output 			fence_op,
		output 			shift_op,
		output 			syscall_op,
		output 			branch_op,
		output 			jump_op,
		output 			jalr_op,
		output 			break_op,
		output 			csr_imm_op,
		output 		[2:0] 	csr_op, 
		output 		[11:0] 	csr_addr	); 
	
		wire [6:0] opcode;
		wire [2:0] mem_access;
	        wire mem_wr;	
		wire mem_r;
		wire mem_ex_s;
		wire mem_unsigned;
		wire [31:0] inst;
		wire [2:0] func3;
		wire [6:0] func7;


		//ASSIGNMENTS
		assign inst 		= instruction[31:0];
		assign opcode 	 	= inst[6:0];
		assign func3 		= inst[14:12]; 
		assign func7 	 	= inst[31:25]; 
		//+- ID STAGE ASSIGNMENTS 
		assign jalr_op      	= jalr;
		assign jump_op      	= is_j;
		assign branch_op    	= is_b; 	
		//+- EX STAGE ASSIGNMENTS
		assign rs1 	    	= (lui)? 5'b0 : inst[19:15]; 
		assign rs2 	    	= (is_j)? 5'b0 :inst[24:20];
		assign rd  	    	= (is_st)? 5'b0: inst[11:7]; 
		assign illegal_inst	= illegal;
		assign fence_op		= fence & fencei;
		assign xret_op		= xret;
		assign load_store_op	= is_ld;
		assign shift_op		= is_shift;
		assign reg_write    	= (rd == 5'b0)? 1'b0 : is_wr;
	        assign break_op     	= _break;
		assign syscall_op   	= call; 
		//+- MEM STAGE ASSIGMENTS
		assign mem_flags    	= {mem_wr,mem_r,mem_access,mem_unsigned};
		assign mem_ex_sel  	= mem_ex_s;
		//+- WB STAGE ASSIGMENTS
		assign csr_imm_op   	= is_csri; 	 
		assign csr_op	    	= {rc|rci, rs|rsi, rw|rwi}; 
		assign csr_addr		= inst[31:20]; 
		
		//TYPES OF INSTRUCTIONS
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

		reg is_b, is_imm, is_st, is_ld;//flags for immediate generation
		reg is_add, is_sub, is_and, is_xor, is_or, is_sll, is_sr,is_shift, is_slt, is_sltu; //arithmetic operations flags
		reg is_wr, is_alu, is_immop, is_ldu, is_j, is_csri, is_csr,is_fence; //external flags
		reg is_word,is_byte,is_hw; 
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
			//---mem flags------
			is_word     = |{lw,sw};
			is_hw	    = |{lh,lhu,sh};
			is_byte     = |{lb,lbu,sb};

			is_csri	    = |{rwi, rsi, rci}; 
			is_ldu	    = |{lbu,lhu};
			//---IMM FLAGS FOR DECODING
			is_j	    = |{jal,jalr};
			is_st	    = |{sb, sh, sw}; //store operation flags
			is_b	    = |{beq,bne,blt,bge,bltu,bgeu};
			is_ld	    = |{lb,lbu,lh,lhu,lw}; //loads operation flag 
			is_imm	    = |{addi,slti,sltiu,ori,andi,slli,srli, xori, is_ld, jalr}; //immediates operations excluding store
			//--Arithmetic operations 
			is_add	    = |{add, addi, is_st, is_ld, lui, auipc,is_j }; //add operation flag
			is_sub	    = |{sub}; //sub operation flag
			is_xor	    = |{_xor,xori};//xor operation flag
			is_and	    = |{_and,andi}; //and operation flag
			is_or	    = |{_or,ori}; //or operation flag
			is_sll      = |{sll, slli}; //shift left operations flag
			is_sr	    = |{sra, srl, srai, srli}; //shift rights operations flag
			is_shift    = |{sra,srl,sll};
			is_slt      = |{slt,slti};
			is_sltu     = |{sltu, sltiu};
			is_alu      = |{add,addi,sub,is_xor,is_and,is_or,is_sll,is_sr, is_slt, is_sltu}; 
			is_csr	    = |{rw,rs,rc,is_csri};
			is_immop    = |{addi,slli,srai, srli, slti, sltiu, ori, andi, xori, is_st, is_ld, lui,auipc,is_csri };
			is_wr       = |{is_imm, is_alu, is_ld, auipc, lui,is_csr, is_j}; //determines if operations is going to write 
			is_fence    = |{fence,fencei};
			illegal	    = ~|{is_j,is_b,is_add,is_sub,is_xor,is_and,is_or,is_sll,is_sr,is_slt,is_sltu,is_csr,is_fence,_break,call,xret};

		end
	

		//IMMEDIATE GENERATOR
		always @(*) begin
			case(1'b1)	
			lui || auipc	: imm = { inst[31:12] , 12'h0}; 
			jal		: imm = { ((inst[31])? 12'hfff   : 12'b0), inst[31], inst[19:12], inst[20], inst[30:21]}; 
			srai		: imm = { 27'b0, inst[24:20] };
			is_b 		: imm = { ((inst[31])? 20'hfffff : 20'b0), inst[31], inst[7], inst[30:25], inst[11:8]}; 	
			is_imm 		: imm = { ((inst[31])? 20'hfffff : 20'b0), inst[31:20]}; 
			is_st		: imm = { ((inst[31])? 20'hfffff : 20'b0), inst[31:25], inst[11:7]};
			is_csri		: imm = { 27'b0, inst[19:15]};

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
				beq  : comparator_op = 3'b001;
				bne  : comparator_op = 3'b010;
				blt  : comparator_op = 3'b011;
				bge  : comparator_op = 3'b100;
				bltu : comparator_op = 3'b101;
				bgeu : comparator_op = 3'b110;
				default: comparator_op = 3'b0;
			endcase
		end
				
		//ALU_OP
		
		always @(*) begin
			case(1'b1)
				is_add : alu_op = 4'b0000; 
				is_sub : alu_op = 4'b0001;
				is_and : alu_op = 4'b0010;
				is_or  : alu_op = 4'b0011;
				is_xor : alu_op = 4'b0100;
				is_sll : alu_op = 4'b0101;
				is_sr  : alu_op = ((sra || srai)? 4'b0110 : 4'b0111);
				is_slt : alu_op = 4'b1000;
				is_sltu: alu_op = 4'b1001;
			        default: alu_op = 4'b1111;	
			endcase
		end 

		//ALU_PORT SELECTION
		always @(*) begin 
			portb_sel = (is_immop) ? 1'b1 : 1'b0;
			porta_sel = (auipc|is_j) ? 1'b1 : 1'b0;
		end
endmodule			



