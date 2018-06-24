//Load Unit / Jesús Colmenares 14-11384

module load_unit( 	input wire [31:0] data_mem_i,
					input wire [2:0] funct3_i,
					output reg [31:0] data_mem_o //Data defined by funct3
				);

	
	localparam LB=3'b000;
	localparam LH=3'b001;
	localparam LW=3'b010;
	localparam LBU=3'b100;
	localparam LHU=3'b101;


	always @(*) begin

		case(funct3_i)

			LB: data_mem_o={24'b1, data_mem_i[7:0]};
			LH: data_mem_o={16'b1, data_mem_i[15:0]};
			LW: data_mem_o=data_mem_i;
			LBU: data_mem_o={24'b0, data_mem_i[7:0]};
			LHU: data_mem_o={16'b0, data_mem_i[15:0]};
			default: data_mem_o=data_mem_i;

		endcase
		
	end

endmodule

	
	
	
	
	
	
