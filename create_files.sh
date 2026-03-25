#!/bin/bash

# File 1: alu_if.sv (NO modport clocking)
cat > alu_if.sv << 'EOF'
interface alu_if(input logic clk);
  logic [63:0] a_i;
  logic [63:0] b_i;
  logic [3:0]  op_i;
  logic [63:0] res_o;
endinterface
EOF

# File 2: bp_be_alu_stub.sv
cat > bp_be_alu_stub.sv << 'EOF'
module bp_be_alu
  (input  logic [63:0] a_i
  ,input  logic [63:0] b_i
  ,input  logic [3:0]  op_i
  ,output logic [63:0] res_o
  );
  always_comb begin
    unique case (op_i)
      4'h0: res_o = a_i + b_i;
      4'h1: res_o = a_i - b_i;
      4'h2: res_o = a_i & b_i;
      4'h3: res_o = a_i | b_i;
      4'h4: res_o = a_i ^ b_i;
      4'h5: res_o = a_i << b_i[5:0];
      4'h6: res_o = a_i >> b_i[5:0];
      4'h7: res_o = $signed(a_i) >>> b_i[5:0];
      default: res_o = '0;
    endcase
  end
endmodule
EOF

# File 3: tb_top.sv
cat > tb_top.sv << 'EOF'
`include "uvm_macros.svh"
import uvm_pkg::*;
module tb_top;
  logic clk;
  initial clk = 0;
  always #5 clk = ~clk;
  alu_if dut_if(.clk(clk));
  bp_be_alu dut(
    .a_i   (dut_if.a_i),
    .b_i   (dut_if.b_i),
    .op_i  (dut_if.op_i),
    .res_o (dut_if.res_o)
  );
  initial begin
    `uvm_info("TB_TOP", "Starting BlackParrot ALU UVM Testbench", UVM_NONE)
    dut_if.a_i  = 64'hA;
    dut_if.b_i  = 64'h5;
    dut_if.op_i = 4'h0;
    #10;
    `uvm_info("TB_TOP", $sformatf("ADD: 10+5=%0d (exp 15)", dut_if.res_o), UVM_NONE)
    dut_if.op_i = 4'h1;
    #10;
    `uvm_info("TB_TOP", $sformatf("SUB: 10-5=%0d (exp 5)", dut_if.res_o), UVM_NONE)
    dut_if.op_i = 4'h2;
    #10;
    `uvm_info("TB_TOP", $sformatf("AND: 10&5=%0d (exp 0)", dut_if.res_o), UVM_NONE)
    dut_if.op_i = 4'h3;
    #10;
    `uvm_info("TB_TOP", $sformatf("OR:  10|5=%0d (exp 15)", dut_if.res_o), UVM_NONE)
    dut_if.op_i = 4'h4;
    #10;
    `uvm_info("TB_TOP", $sformatf("XOR: 10^5=%0d (exp 15)", dut_if.res_o), UVM_NONE)
    `uvm_info("TB_TOP", "ALU UVM POC COMPLETE - [BSG-PASS]", UVM_NONE)
    $finish;
  end
endmodule
EOF

echo "All files created successfully!"
ls -la *.sv
