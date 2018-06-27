//Modelo de la ALU

module ALU(
    input [31:0]      A;      // Entrada A
    input [31:0]      B;      // Entrada b
    input [2:0]      ALU_OP;  // Señal de control para determinar tipo de operación a realizar
    output reg [31:0] alu_o; // Salida proveniente de la operación
    );

		case (ALU_OP)

			3'b000: alu_o = A + B; // SUMA
			3'b001: alu_o = A - B; // RESTA
			3'b010: alu_o = A & B; // AND
			3'b011: alu_o = A | B; // OR
			3'b100: alu_o = A ^ B; // XOR
			3'b101: alu_o = A << B; // Logical shift left
			3'b110: alu_o = A >> B; // Logical shift right
			3'b111: alu_o = A >>> B; // Arithmetic shift right
		endcase
	end
endmodule
