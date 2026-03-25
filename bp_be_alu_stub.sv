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
