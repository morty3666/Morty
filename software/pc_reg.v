// Modulo PC (verilog)

module pc_reg;
    input clk_i; 
    input rst_i; 
    input stall;
    input [31:0] new_pc;
    output reg [31:0] pc_o;
    always @(posedge clk_i) 
        begin
        if (rst_i) pc_o <= 0;
        else 
            if (stall) pc_o <= pc_o;
                else pc_o <= new_pc;
        end
endmodule	