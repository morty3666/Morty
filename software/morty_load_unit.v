//Load Unit / Jesús Colmenares 14-11384

module load_unit( 	input wire [31:0] data_mem_i,
					input wire [2:0] funct3_i,
					input wire [1:0] addr_i,
					output reg [31:0] data_mem_o //Data defined by funct3
				);

	
	localparam LB=3'b000;
	localparam LH=3'b001;
	localparam LW=3'b010;
	localparam LBU=3'b100;
	localparam LHU=3'b101;

	wire [7:0] data_sel_LB;
	wire [15:0] data_sel_LH;


	always @(*) begin

		case(addr_i)
					2'b00: data_sel_LB= data_mem_i[7:0];
					2'b01: data_sel_LB= data_mem_i[15:8];
					2'b10: data_sel_LB= data_mem_i[23:16];
					2'b11: data_sel_LB= data_mem_i[31:24];
		endcase

		case(addr_i[0])
					1'b0: data_sel_LH= data_mem_i[15:0];
					1'b1: data_sel_LH= data_mem_i[31:16];
		endcase

		case(funct3_i)

			LB: data_mem_o={{24{data_mem_i[7]}}, data_sel_LB};			
			LH: data_mem_o={{16{data_mem_i[15]}}, data_sel_LH};
			LW: data_mem_o=data_mem_i;
			LBU: data_mem_o={24'b0, data_sel_LB};
			LHU: data_mem_o={16'b0, data_sel_LH};
			default: data_mem_o=data_mem_i;

		endcase
		
	end

endmodule

	
	
	
	
	
	
