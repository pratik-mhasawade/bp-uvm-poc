interface alu_if(input logic clk);
    logic [63:0] a_i, b_i;
    logic [3:0]  op_i;
    logic [63:0] res_o;

    clocking drv_cb @(posedge clk);
        default input #1ns output #1ns;
        output a_i, b_i, op_i;
        input  res_o;
    endclocking
endinterface
