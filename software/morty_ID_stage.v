
module ID_Stage(
				//INPUTS
				input clk,
				input [31:0] inst,		
				input [31:0] pc_i,
				input [31:0] pc4_i,
				input we_wb,
				input [4:0] rd_wb,
				input [31:0] data_wb,
				input [3:0] exc_i,
				input [31:0] fexc,
				input [31:0] fmem,
				input [31:0] fwb,
				input [1:0] ctrl_forw_a;
				input [1:0] ctrl_forw_b;
				//OUTPUTS
				output reg [4:0] rd,
				output reg [31:0] pc_o,
				output reg [31:0] pc4_o,
				output reg [31:0] port_a,
				output reg [31:0] port_b,
				output reg [31:0] pc_j,
				output reg [31:0] forw_b,//drs2
				output reg [11:0] CSR,
				output reg [31:0] drs1_imm,
				output reg [3:0] exc_o);

	//SIGNALS
	wire [31:0] imm; //Salida del EXT_IMM
	wire [31:0] imm_; //imm << 1
	wire [31:0] forw_a; //Salida del forwarding A
	wire [31:0] drs1; //Salida 1 del RF
	wire [31:0] drs2; //Salida 2 del RF
	wire [4:0] rs1; //Entrada 1 del RF
	wire [4:0] rs2; //Entrada 2 del RF
	wire [6:0] opcode; 
	wire [2:0] funct3;
	wire [6:0] funct7;
	wire [31:0] imm_j, //Salida del multiplexor del inmediato para salto
	wire rs0; //Bandera en caso de que el registro 1 sea x0
				
		//CONTROL
	wire [1:0] ctrl_muxa;
	wire ctrl_muxb;
	wire ctrl_muxcsr;
	wire ctrl_muxj;
	wire equal_o; //Señal de salida del comparador equal
	wire ltu_o; //Señal de salida del comparador ltu
	wire lts_o; //Señal de salida del comparador lts
	wire [2:0] type_imm;
	
	always @(*) begin
		pc_o = pc_i;
		pc4_o = pc4_i;
		rd = inst[11:7];
		CSR = inst[31:20];
	end
	
	assign imm_ = imm << 1;
	assign rs1 = inst[19:15];
	assign rs2 = inst[24:20];
	assign opcode = inst[6:0];
	assign funct3 = inst[14:12];
	assign funct7 = inst[31:25];
	assign rs0 = (rs1 == 5'b0);
	
	//MULTIPLEXOR
	// mult4 (in1, in2, in3, in4, sel, out);
	mult4 MUX_A(forw_a, pc_i, 0, 0, ctrl_muxa, port_a);
	mult4 MUX_B(forw_b, imm, 0, 0, ctrl_muxb, port_b);
	mult4 FORW_A(drs1, fexc, fmem, fwb, ctrl_forwa, forw_a);
	mult4 FORW_B(drs2, fexc, fmem, fwb, ctrl_forwb, forw_b);
	mult4 MUX_CSR(forwa, imm, 0, 0, ctrl_muxcsr, drs1_imm);
	mult4 MUX_J(imm, imm_, 0, 0, ctrl_muxj, imm_j);
	
	//ADD (in1, in2, out)
	ADD ADD1(imm_j, pc_i, pc_j);
	
	//IMMEDIATE GENERATOR
	//IMM_EXT(inst, type_imm, imm);
	IMM_EXT IMM_EXT(inst, type_imm, imm);
	
	//COMPARATOR
	//ComparatorGeneral(drs1, drs2, out)
	Comparatorequal EQUAL(forwa, port_b, equal_o);
	Comparatorless_than_unsigned LTU(forw_a, port_b, ltu_o);
	Comparatorless_than_signed LTS(forw_a, port_b, lts_o);
	
	//REGISTER FILE
	//register_file(clk, raddr_rs1, raddr_rs2, waddr_rd, wdata_rd, we, rdata_rs1, rdatars2)
	register_file RF(clk, rs1, rs2, rd_wb, data_wb, we_wb, drs1, drs2);
	
endmodule