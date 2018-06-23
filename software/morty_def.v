
`define lui_op   	7'b0110111
`define auipc_op 	7'b0010111
//---------JUMP DEFINES-----------
`define jal_op   	7'b1101111
`define jalr_op  	7'b1100111
//---------BRANCH DEFINES---------
`define br_op   	7'b1100011 
`define beq_f3   	3'b000 
`define bne_f3   	3'b001
`define blt_f3		3'b100
`define bge_f3 		3'b101
`define bltu_f3		3'b110
`define bgeu_f3		3'b111
//---------LOAD DEFINES----------
`define ld_op		7'b0000011
`define lb_f3		3'b000
`define lh_f3		3'b001
`define lw_f3		3'b010
`define lbu_f3		3'b100
`define lhu_f3		3'b101
//--------STORE DEFINES----------
`define st_op		7'b0100011
`define sb_f3		3'b000
`define sh_f3		3'b001
`define sw_f3		3'b010
//------INMEDIATE DEFINES--------
`define imm_op		7'b0010011
`define addi_f3		3'b000
`define slti_f3		3'b010
`define sltiu_f3	3'b011
`define xori_f3		3'b100
`define ori_f3		3'b110
`define andi_f3		3'b111
`define slli_f3		3'b001
`define sr_f3	 	3'b101
`define slli_f7		7'b0000000
`define srli_f7		7'b0000000
`define srai_f7		7'b0100000
//--------ALU OP DEFINES--------
`define alu_op		7'b0110011
`define add_sub_f3	3'b000
`define sll_f3		3'b001
`define slt_f3		3'b010
`define sltu_f3		3'b011
`define xor_f3		3'b100
`define srl_f3		3'b101
`define sra_f3		3'b101
`define or_f3		3'b110
`define and_f3		3'b111
`define alu_f7		7'b0000000
`define sub_f7		7'b0100000
`define sra_f7		7'b0100000
////---------SPECIAL INST----------
`define nop_op		32'h33
//===========CSR INST===========
`define sp_op		7'b1110011
`define rw_f3		3'b001
`define rs_f3		3'b010
`define rc_f3		3'b011
`define rwi_f3		3'b101
`define rsi_f3		3'b110
`define rci_f3		3'b111
`define syscall		25'b0
`define break		25'b0000000000010000000000000
`define mret_f2		2'b00
`define mret_f21	21'b000000100000000000000
`define fence           7'b0001111
`define fe_f3		3'b000
`define fei_f3		3'b001
