`include "uvm_macros.svh"
import uvm_pkg::*;
import uvm_lite_pkg::*;

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

  alu_scoreboard sb;

  initial begin
    `uvm_info("TB_TOP", "Starting BlackParrot ALU UVM Testbench", UVM_NONE)

    sb = new();

    for (int i = 0; i < 50; i++) begin
      alu_transaction tr = new();
      tr.a  = {$urandom(), $urandom()};
      tr.b  = {$urandom(), $urandom()};
      tr.op = $urandom_range(0, 7);

      dut_if.a_i  = tr.a;
      dut_if.b_i  = tr.b;
      dut_if.op_i = tr.op;

      #10;

      tr.result = dut_if.res_o;
      sb.check(tr);
    end

    sb.report();

    if (sb.fail_count == 0)
      `uvm_info("TB_TOP", "ALU UVM POC COMPLETE - [BSG-PASS]", UVM_NONE)
    else
      $fatal(1, "ALU scoreboard reported %0d failures", sb.fail_count);

    $finish;
  end
endmodule
