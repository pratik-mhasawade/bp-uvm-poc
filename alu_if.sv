interface alu_if(input logic clk);
  logic [63:0] a_i;
  logic [63:0] b_i;
  logic [3:0]  op_i;
  logic [63:0] res_o;
endinterface
