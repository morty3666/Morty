

`include "comp_equal.v"
`include "comp_less_signed.v"
`include "comp_less_unsigned.v"
`include "IMM_EXT.v"
`include "mult4.v"
`include "reg_file.v"


module ID_Stage(
				//INPUTS
				input wire clk,
				/* verilator lint_off UNUSED */
				input wire [31:0] inst,		
				input wire [31:0] pc_i,
				input wire [31:0] pc4_i,
				input wire we_wb, //WB
				input wire [4:0] rd_wb, //WB
				input wire [31:0] data_wb, //WB
				input wire [3:0] trap_code_id_i, //trap_cause
				input wire is_trap_i,                    //New
				 //forwarding
				input wire [31:0] fexc, 
				input wire [31:0] fmem,
				input wire [31:0] fwb, 
				input wire [1:0] ctrl_forwa, //SEL MUX FW1
				input wire [1:0] ctrl_forwb, //SEL MUX FW2
				//Control inputs
				input wire [1:0] ctrl_muxa_i,
				input wire [1:0] ctrl_muxb_i,
				input wire  ctrl_muxcsr_i,
				input wire  ctrl_muxj_i,
				input wire [2:0] type_imm,

				//OUTPUTS
				output reg [4:0] rd,
				output reg [31:0] pc_o,
				output reg [31:0] pc4_o,
				output reg [31:0] port_a,  //ALU scr A
				output reg [31:0] port_b,  //ALU scr B
				output reg [31:0] pc_j_o,  				
				output reg [11:0] CSR_addr_o,  //CSR address
				output reg [31:0] CSR_data_o,
				output reg [3:0] trap_code_id_o,
				output reg [31:0] forw_b_o, //data en rs2 corregida con FW

				output reg is_trap_o,			
				output reg  is_rs0,
				//Hacia la unidad de control				
				output reg equal_o, //Señal de salida del comparador equal
				output reg ltu_o, //Señal de salida del comparador ltu
				output reg lts_o //Señal de salida del comparador lts
				);

			
	//SIGNALS
	wire [31:0] imm; //Salida del EXT_IMM
	wire [31:0] forw_a; //Salida del forwarding A
	wire [31:0] drs1; //Salida 1 del RF
	wire [31:0] drs2; //Salida 2 del RF
	wire [4:0] rs1; //Entrada 1 del RF
	wire [4:0] rs2; //Entrada 2 del RF	
	wire [31:0] imm_j; //Salida del multiplexor del inmediato para salto
	wire [31:0] immj_or_rs1;
	wire [31:0] dr2_corrected;
    				
	
	//Propagated to next stage
	always @(*) begin
		pc_o = pc_i;
		pc4_o = pc4_i;
		rd = inst[11:7];
		trap_code_id_o=trap_code_id_i;
		is_trap_o = is_trap_i;
		CSR_addr_o = inst[31:20];
	end
	
	
	assign rs1 = inst[19:15];
	assign rs2 = inst[24:20];	
	assign is_rs0 = (rs1 == 5'b0);
	
	//MULTIPLEXOR
	// mult4 (in1, in2, in3, in4, sel, out);
	mult4 MUX_A(forw_a, pc_i, 32'b0, 32'b0, ctrl_muxa_i, port_a);
	assign dr2_corrected = ctrl_muxb_i[1] ? forw_b_o & 32'h1F : forw_b_o;
	assign port_b = ctrl_muxb_i[0] ? imm : dr2_corrected;
	mult4 FW1(drs1, fexc, fmem, fwb, ctrl_forwa, forw_a);
	mult4 FW2(drs2, fexc, fmem, fwb, ctrl_forwb, forw_b_o);
	assign CSR_data_o = ctrl_muxcsr_i ? imm : forw_a ;
	assign imm_j = ctrl_muxj_i ? imm : imm << 1 ;
	assign  immj_or_rs1 = ctrl_muxj_i ? forw_a : pc_i;
  

		
	//PC for BJ instructions
	assign  pc_j_o= immj_or_rs1  + imm_j;
	
	//IMMEDIATE GENERATOR
	//IMM_EXT(inst, type_imm, imm);
	IMM_EXT IMM_EXT(inst[31:7], type_imm, imm);
	
	//COMPARATOR
	//ComparatorGeneral(drs1, drs2, out)
	wire [31:0] comp_b;
	assign comp_b = inst[5] ? forw_b_o : { ((inst[31]) ? 20'hfffff : 20'b0), inst[31:20] };
	comp_equal EQUAL(forw_a, comp_b, equal_o);
	comp_less_unsigned LTU(forw_a, comp_b, ltu_o);
	comp_less_signed LTS(forw_a, comp_b, lts_o);
	
	//REGISTER FILE
	//register_file(clk, raddr_rs1, raddr_rs2, waddr_rd, wdata_rd, we, rdata_rs1, rdatars2)
	reg_file RF(clk, rs1, rs2, rd_wb, data_wb, we_wb, drs1, drs2);
	
endmodule
