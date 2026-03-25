module bp_be_alu (
    input [63:0] a_i,
    input [63:0] b_i,
    input [3:0]  op_i,
    output logic [63:0] res_o
);
    always_comb begin
        case (op_i)
            4'd0: res_o = a_i + b_i; // ADD
            4'd1: res_o = a_i - b_i; // SUB
            4'd2: res_o = a_i & b_i; // AND
            4'd3: res_o = a_i | b_i; // OR
            4'd4: res_o = a_i ^ b_i; // XOR
            default: res_o = 64'b0;
        endcase
    end
endmodule
