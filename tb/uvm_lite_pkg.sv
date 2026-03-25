   

package uvm_lite_pkg;
    import uvm_pkg::*;

    class alu_transaction;
        logic [63:0] a, b, result;
        logic [3:0] op;
        ...
    endclass

    class alu_scoreboard;
        int pass_count = 0, fail_count = 0;
        bit [4:0] op_seen;

        covergroup op_cov;
            op_cp : coverpoint op {
                bins add  = {4'd0};
                bins sub  = {4'd1};
                bins and_ = {4'd2};
                bins or_  = {4'd3};
                bins xor_ = {4'd4};
            }
        endgroup

        op_cov cov;

        function new();
            cov = new;
            op_seen = '0;
        endfunction

        function logic [63:0] predict(logic [63:0] a, b, logic [3:0] op);
            case (op)
                4'd0: return a + b; // ADD
                4'd1: return a - b; // SUB
                4'd2: return a & b; // AND
                4'd3: return a | b; // OR
                4'd4: return a ^ b; // XOR
                default: return 64'h0;
            endcase
        endfunction

        function void check(alu_transaction tr);
            logic [63:0] exp = predict(tr.a, tr.b, tr.op);
            cov.sample(tr.op);
            if (tr.op < 5) op_seen[tr.op] = 1;

            if (tr.result === exp) begin
                $display("[SCOREBOARD] PASS | Op:%0d A:%h B:%h | Res:%h", tr.op, tr.a, tr.b, tr.result);
                pass_count++;
            end else begin
                string msg = $sformatf("ALU MISMATCH: op=%0d a=%h b=%h exp=%h act=%h", tr.op, tr.a, tr.b, exp, tr.result);
                uvm_error("ALU_SCB", msg);
                $display("[SCOREBOARD] ERROR | %s", msg);
                fail_count++;
            end
        endfunction

        function void report();
            int covered = 0;
            for (int i = 0; i < 5; i++)
                if (op_seen[i]) covered++;

            $display("\n--- FINAL VERIFICATION REPORT ---");
            $display("  PASSED: %0d | FAILED: %0d", pass_count, fail_count);
            $display("  OPCODES COVERED: %0d/5 (%0.2f%%)", covered, (covered * 100.0) / 5.0);
            $display("---------------------------------\n");
        endfunction
    endclass
endpackage
