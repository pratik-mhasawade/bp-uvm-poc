module tb_top;
    import uvm_lite_pkg::*;

    bit clk;
    always #5 clk = ~clk;

    alu_if _if(clk);
    
    bp_be_alu dut (
        .a_i(_if.a_i),
        .b_i(_if.b_i),
        .op_i(_if.op_i),
        .res_o(_if.res_o)
    );

    initial begin
        alu_driver drv = new(_if);
        alu_scoreboard sb = new();
        alu_transaction tr;

        $display("\n[UVM_LITE] Starting Self-Checking ALU Test...");

        repeat (50) begin
            tr = new();
            tr.manual_randomize();
            drv.drive(tr);
            sb.check(tr);
        end

        sb.report();
        
        if (sb.fail_count == 0)
            $display("[UVM_LITE] POC COMPLETE - [BSG-PASS]\n");
        else
            $display("[UVM_LITE] POC FAILED - [BSG-FAIL]\n");

        $finish;
    end
endmodule