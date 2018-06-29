//XYZ Processor Core ---- Control unit

module control_unit(/* verilator lint_off UNUSED */
					input wire [31:0] instr,
					input wire equal_i,  //comparator flag
					input wire ltu_i, 	//comparator flag
					input wire lts_i,	//comparator flag
					input wire PC_csr_i,  //Flag for any type of exception
					//Control signals
					output reg [1:0] PC_control_o,
					output reg [1:0] ctrl_muxa_o,
					output reg 	  ctrl_muxb_o,
					output reg ctrl_muxcsr_o,
					output reg    ctrl_muxj_o,
					output reg [2:0] type_imm_o,
					output reg we_mem_o,
					output reg is_LS_o,
					output reg [2:0] funct3_mem_o,
					output reg data_or_alu_o,
					output reg [2:0] alu_op_ex_o,
					output reg we_wb_o,
					output reg [1:0] mux_wb_sel_o,
					output reg [1:0] csr_op_o,
					output reg comp_o,
					output reg is_csr_o,
					output reg is_mret_o,  //Flag for CSR to mret instr.
					//More controls signals
					output reg is_trap_o,
					output reg [3:0] cause_trap_o,
					output reg		  branch_taken_o  //for hazard unit.
					);


		
	//Flags for instructions

	wire   is_lui, is_auipc;
    wire   is_jal, is_jalr;
    wire   is_beq, is_bne, is_blt, is_bge, is_bltu, is_bgeu;
    wire   is_lb, is_lh, is_lw, is_lbu, is_lhu;
    wire   is_sb, is_sh, is_sw;
    wire   is_addi, is_slti, is_sltiu, is_xori, is_ori, is_andi, is_slli, is_srli, is_srai;
    wire   is_add, is_sub, is_sll, is_slt, is_sltu, is_xor, is_srl, is_sra, is_or, is_and;
    wire   is_fence, is_nop;
    wire   is_csrrw, is_csrrs, is_csrrc, is_csrrwi, is_csrrsi, is_csrrci;
   	wire   is_ecall, is_ebreak, is_mret;

    //General flags
    wire is_u, is_j, is_branch, is_load, is_store, is_CSR, is_CSR_i, is_CSR_r, is_alu_r, is_alu_i, is_alu, is_comp;
    
    //Exceptions codes
    localparam E_ILLEGAL_INST  = 4'd2;
    localparam E_BREAKPOINT    = 4'd3;
    localparam E_ECALL         = 4'd11;
    

 	//Decoding instruction
    always @(*) begin
    	
       		//U instructions
    		is_lui     = instr[6:0] == 7'b0110111;
            is_auipc   = instr[6:0] == 7'b0010111;
            //jump instructions
            is_jal     = instr[6:0] == 7'b1101111;
            is_jalr    = instr[6:0] == 7'b1100111;
            //branch instructions
            is_beq     = instr[6:0] == 7'b1100011 && instr[14:12] == 3'b000;
            is_bne     = instr[6:0] == 7'b1100011 && instr[14:12] == 3'b001;
            is_blt     = instr[6:0] == 7'b1100011 && instr[14:12] == 3'b100;
            is_bge     = instr[6:0] == 7'b1100011 && instr[14:12] == 3'b101;
            is_bltu    = instr[6:0] == 7'b1100011 && instr[14:12] == 3'b110;
            is_bgeu    = instr[6:0] == 7'b1100011 && instr[14:12] == 3'b111;
            //load instructions
            is_lb      = instr[6:0] == 7'b0000011 && instr[14:12] == 3'b000;
            is_lh      = instr[6:0] == 7'b0000011 && instr[14:12] == 3'b001;
            is_lw      = instr[6:0] == 7'b0000011 && instr[14:12] == 3'b010;
            is_lbu     = instr[6:0] == 7'b0000011 && instr[14:12] == 3'b100;
            is_lhu     = instr[6:0] == 7'b0000011 && instr[14:12] == 3'b101;
            //store instructions
            is_sb      = instr[6:0] == 7'b0100011 && instr[14:12] == 3'b000;
            is_sh      = instr[6:0] == 7'b0100011 && instr[14:12] == 3'b001;
            is_sw      = instr[6:0] == 7'b0100011 && instr[14:12] == 3'b010;
            //reg-imm instructions
            is_addi    = instr[6:0] == 7'b0010011 && instr[14:12] == 3'b000;
            is_slti    = instr[6:0] == 7'b0010011 && instr[14:12] == 3'b010;
            is_sltiu   = instr[6:0] == 7'b0010011 && instr[14:12] == 3'b011;
            is_xori    = instr[6:0] == 7'b0010011 && instr[14:12] == 3'b100;
            is_ori     = instr[6:0] == 7'b0010011 && instr[14:12] == 3'b110;
            is_andi    = instr[6:0] == 7'b0010011 && instr[14:12] == 3'b111;
            is_slli    = instr[6:0] == 7'b0010011 && instr[14:12] == 3'b001 && instr[31:25] == 7'b0000000;
            is_srli    = instr[6:0] == 7'b0010011 && instr[14:12] == 3'b101 && instr[31:25] == 7'b0000000;
            is_srai    = instr[6:0] == 7'b0010011 && instr[14:12] == 3'b101 && instr[31:25] == 7'b0100000;
            //reg-reg instructions
            is_add     = instr[6:0] == 7'b0110011 && instr[14:12] == 3'b000 && instr[31:25] == 7'b0000000;
            is_sub     = instr[6:0] == 7'b0110011 && instr[14:12] == 3'b000 && instr[31:25] == 7'b0100000;
            is_sll     = instr[6:0] == 7'b0110011 && instr[14:12] == 3'b001 && instr[31:25] == 7'b0000000;
            is_slt     = instr[6:0] == 7'b0110011 && instr[14:12] == 3'b010 && instr[31:25] == 7'b0000000;
            is_sltu    = instr[6:0] == 7'b0110011 && instr[14:12] == 3'b011 && instr[31:25] == 7'b0000000;
            is_xor     = instr[6:0] == 7'b0110011 && instr[14:12] == 3'b100 && instr[31:25] == 7'b0000000;
            is_srl     = instr[6:0] == 7'b0110011 && instr[14:12] == 3'b101 && instr[31:25] == 7'b0000000;
            is_sra     = instr[6:0] == 7'b0110011 && instr[14:12] == 3'b101 && instr[31:25] == 7'b0100000;
            is_or      = instr[6:0] == 7'b0110011 && instr[14:12] == 3'b110 && instr[31:25] == 7'b0000000;
            is_and     = instr[6:0] == 7'b0110011 && instr[14:12] == 3'b111 && instr[31:25] == 7'b0000000;
            //fence
            is_fence   = instr[6:0] == 7'b0001111;
            //CSR instructions
            is_csrrw   = instr[6:0] == 7'b1110011 && instr[14:12] == 3'b001;
            is_csrrs   = instr[6:0] == 7'b1110011 && instr[14:12] == 3'b010;
            is_csrrc   = instr[6:0] == 7'b1110011 && instr[14:12] == 3'b011;
            is_csrrwi  = instr[6:0] == 7'b1110011 && instr[14:12] == 3'b101;
            is_csrrsi  = instr[6:0] == 7'b1110011 && instr[14:12] == 3'b110;
            is_csrrci  = instr[6:0] == 7'b1110011 && instr[14:12] == 3'b111;
            //system instructions
             is_ecall   = instr[6:0] == 7'b1110011 && instr[31:7] == 25'b0;
             is_ebreak  = instr[6:0] == 7'b1110011 && instr[31:7] == 25'b0000000000010000000000000;
             is_nop     = instr == 32'b0;
             is_mret    = instr[6:0] == 7'b1110011 && instr[31:30] == 2'b0 && instr[27:7] == 21'b000000100000000000000;

            //General flags
            is_u= is_lui | is_auipc;
            is_j= is_jal | is_jalr;
            is_branch = is_beq | is_bne | is_bge | is_bgeu | is_blt | is_bltu;
            is_load = is_lb | is_lh | is_lw | is_lbu | is_lhu;
            is_store = is_sb | is_sh | is_sw;
            is_alu_i=  is_addi | is_slti| is_sltiu | is_xori | is_ori | is_andi | is_slli | is_srli | is_srai;
            is_alu_r = is_add | is_sub | is_slt | is_sltu | is_xor | is_or | is_and | is_sll | is_srl | is_sra;
            is_alu = is_alu_i | is_alu_r;
            is_comp = is_slti| is_sltiu | is_slt | is_sltu;
            is_CSR_r = is_csrrw | is_csrrs | is_csrrc; 
            is_CSR_i = is_csrrwi | is_csrrsi | is_csrrci;
            is_CSR = is_CSR_r | is_CSR_i;

     end

     //Generating signals
     always @(*) begin

     	case(1'b1)

     		is_u: begin
     			if(is_lui)
     				ctrl_muxa_o=2'b10;
     			else
     				ctrl_muxa_o=2'b01;
     			ctrl_muxb_o=1'b1;
     			type_imm_o=3'b0;
     			is_LS_o=1'b0;
     			data_or_alu_o=1'b0;
     			alu_op_ex_o=3'b0;
     			we_wb_o=1'b1;
     			mux_wb_sel_o=2'b0;
     			is_csr_o=1'b0;
     			is_trap_o=1'b0;
     		end

     		is_j: begin     			
     			if(is_jal) begin
     				ctrl_muxj_o=1'b0;
     				type_imm_o=3'b011;     				
     			end
     			else begin
     				ctrl_muxj_o=1'b1;
     				type_imm_o=3'b001;
     			end
     			is_LS_o=1'b0;
     			we_wb_o=1'b1;
     			mux_wb_sel_o=2'b01;
     			is_csr_o=1'b0;
     			is_trap_o=1'b0;
     		end

     		is_load: begin
     			ctrl_muxa_o=2'b0;
     			ctrl_muxb_o=1'b1;
     			type_imm_o=3'b001;
     			we_mem_o=1'b0;
     			is_LS_o=1'b1;
     			data_or_alu_o=1'b1;
     			alu_op_ex_o=3'b0;
     			we_wb_o=1'b1;
     			mux_wb_sel_o=2'b0;
     			is_csr_o=1'b0;
     			is_trap_o=1'b0;
     			funct3_mem_o=instr[14:12];
     		end

     		is_store: begin
     			ctrl_muxa_o=2'b0;
     			ctrl_muxb_o=1'b1;
     			type_imm_o=3'b100;
     			we_mem_o=1'b1;
     			is_LS_o=1'b1;     		
     			alu_op_ex_o=3'b0;
     			we_wb_o=1'b0;     		
     			is_csr_o=1'b0;
     			is_trap_o=1'b0;
     			funct3_mem_o=instr[14:12];
     		end

     		is_alu: begin

     			ctrl_muxa_o=2'b0;
     			if(is_alu_r)
     				ctrl_muxb_o=1'b0;
     			else 
     				ctrl_muxb_o=1'b1;

     			type_imm_o=3'b001;
     			is_LS_o=1'b0;
     			data_or_alu_o=1'b0;
     			we_wb_o=1'b1;     			
     			is_csr_o=1'b0;
     			is_trap_o=1'b0;

     			if(is_comp) begin
     				mux_wb_sel_o=2'b11;
     				comp_o= (is_slt & lts_i) | (is_sltu & ltu_i) | (is_slti & lts_i) | (is_sltiu & ltu_i);
     			end     				
     			else
     				mux_wb_sel_o=2'b0;

     			if(is_sub)
     				alu_op_ex_o=3'b010;
     			else if(is_sra | is_srai)
     				alu_op_ex_o=3'b011;
     			else
     				alu_op_ex_o=instr[14:12];	

     		end

     		is_branch: begin
     			ctrl_muxj_o=1'b0;
     			type_imm_o=3'b010;
     			is_LS_o=1'b0;
     			we_wb_o=1'b0;
     			is_csr_o=1'b0;
     			is_trap_o=1'b0;
     		end

     		is_CSR: begin

     			if(is_CSR_r)
     				ctrl_muxcsr_o=1'b0;
     			else
     				ctrl_muxcsr_o=1'b1;
     			type_imm_o = 3'b101;
     			is_LS_o=1'b0;
     			we_wb_o = 1'b1;
     			mux_wb_sel_o = 2'b10;
     			csr_op_o = instr[13:12];
     			is_csr_o=1'b1;
     			is_trap_o=1'b0;

     		end
     		is_ecall: begin
     			is_trap_o=1'b1;
     			cause_trap_o=E_ECALL;

     		end

     		is_ebreak: begin
     			is_trap_o=1'b1;
     			cause_trap_o=E_BREAKPOINT;     			
     		end

     		is_nop || is_fence : begin
     			ctrl_muxa_o=2'b0;
     			ctrl_muxb_o=1'b1;
     			type_imm_o=3'b0;
     			is_LS_o=1'b0;
     			data_or_alu_o=1'b0;
     			alu_op_ex_o=3'b0;
     			we_wb_o=1'b0;
     			is_csr_o=1'b0;
     			is_trap_o=1'b0;

     		end

     		is_mret: begin
     			is_LS_o=1'b0;
     			we_wb_o=1'b0;
     			is_csr_o=1'b1;
     			is_trap_o=1'b0;
     			is_mret_o=1'b1;     			
     		end

     		default: begin
     			is_trap_o=1'b1;
     			cause_trap_o=E_ILLEGAL_INST;
     		end

     	endcase

     	//Determine if a branch is taken.
     	branch_taken_o = (is_beq & equal_i) | (is_bne & ~equal_i) | (is_bge & ~lts_i) | (is_bgeu & ~lts_i) | (is_blt & lts_i) | (is_bltu & ltu_i);

     	//PC control
     	if(PC_csr_i)
     		PC_control_o = 2'b10;
     	else if(is_j | branch_taken_o)
     		PC_control_o = 2'b01;
     	else 
     		PC_control_o = 2'b00;
     	
     end

     endmodule
