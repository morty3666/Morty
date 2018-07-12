//Comparadores 




Module ComparadorEqual (rs1, rs2, equal_out) //compara si ambos valores son iguales, de ser así la salida es 1
	input [5:0] rs1;
	input [5:0] rs2;
	output reg equal_out=0;
	begin
	if (rs1==rs2)
		equal_out = 1;
	end

Module ComparadorLess_than_unsigned (rs1, rs2, ltu_out) //compara valores sin verificar signo, si el primero es menor la salida es 1
	input [5:0] rs1;
	input [5:0] rs2;
	output reg ltu_out=0;
	begin
	if (rs1<rs2)
		ltu_out = 1;
	end

Module ComparadorLess_than_signed (rs1, rs2, lts_out)
	input [5:0] rs1;
	input [5:0] rs2;
	output reg lts_out=0;
	begin
	if (rs1[5]>rs2[5]) //Si el BMS de rs1 es mayor que el de rs2 significa que el primnero es un número negativo, y por lo tanto es menor 
		lts_out = 1;
	else if (rs1[5]<rs2[5]) //Si ocurre lo contrario, la señal de salida sigue igual, y funciona para los branch if greater than
	else if (rs1[5]==rs2[5]) // Si ambos bits son 0, se verifican de manera normal los otros 4 bits
		if (rs1[4:0]<rs2[4:0]) //Si ambos números son negativos, se verifica que el resto sea menor, ya que esto implica sumarle menor valor al del primer bit (valor negativo)
			lts_out = 1;
	end
