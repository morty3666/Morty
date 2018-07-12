
// Modulo Multiplexor (verilog)
// Ejemplo de multiplexor generico simple de 4 entradas

module mult4 (in1, in2, in3, in4, sel, out);
    input [31:0] in1, in2, in3, in4; 
    input [1:0] sel;
    output reg [31:0] out;
    always @(in1, in2, in3, in4, sel)
    case (sel)
        0: out = in1;
        1: out = in2;
        2: out = in3;
        default: out = in4;
	endcase
endmodule		

