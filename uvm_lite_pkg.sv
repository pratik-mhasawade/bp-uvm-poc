package uvm_lite_pkg;
    import uvm_pkg::*;

    class alu_transaction;
        logic [63:0] a, b, result;
        logic [3:0] op;

        function void manual_randomize();
            a  = {$urandom(), $urandom()};
            b  = {$urandom(), $urandom()};
            op = $urandom_range(0, 4);
        endfunction
    endclass

    class alu_scoreboard;
        int pass_count = 0, fail_count = 0;
        bit [7:0] op_seen;

        function new();
            op_seen = '0;
        endfunction

        function logic [63:0] predict(logic [63:0] a, b, logic [3:0] op);
            case (op)
                4'd0: return a + b; // ADD
                4'd1: return a - b; // SUB
                4'd2: return a & b; // AND
                4'd3: return a | b; // OR
                4'd4: return a ^ b; // XOR
                4'd5: return a << b[5:0]; // SLL
                4'd6: return a >> b[5:0]; // SRL
                4'd7: return $signed(a) >>> b[5:0]; // SRA
                default: return 64'h0;
            endcase
        endfunction

        function void check(alu_transaction tr);
            logic [63:0] exp = predict(tr.a, tr.b, tr.op);
            if (tr.op < 8) op_seen[tr.op] = 1;

            if (tr.result === exp) begin
                $display("[SCOREBOARD] PASS | Op:%0d A:%h B:%h | Res:%h", tr.op, tr.a, tr.b, tr.result);
                pass_count++;
            end else begin
                string msg = $sformatf("ALU MISMATCH: op=%0d a=%h b=%h exp=%h act=%h", tr.op, tr.a, tr.b, exp, tr.result);
                $display("[UVM_ERROR][ALU_SCB] %s", msg);
                $display("[SCOREBOARD] ERROR | %s", msg);
                fail_count++;
            end
        endfunction

        function void report();
            int covered = 0;
            for (int i = 0; i < 8; i++)
                if (op_seen[i]) covered++;

            $display("\n--- FINAL VERIFICATION REPORT ---");
            $display("  PASSED: %0d | FAILED: %0d", pass_count, fail_count);
            $display("  OPCODES COVERED: %0d/8 (%0.2f%%)", covered, (covered * 100.0) / 8.0);
            $display("COV: {\"passed\": %0d, \"failed\": %0d, \"opcodes_covered\": %0d, \"total_opcodes\": 8}", pass_count, fail_count, covered);
            $display("---------------------------------\n");
        endfunction
    endclass
endpackage