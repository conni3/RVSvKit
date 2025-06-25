import tb_util_pkg::loop_all_values;

module half_adder_tb;
  logic [31:0] ab_combined = 0;
  logic         a, b;
  logic         sum, carry;

  half_adder uut (.a(a), .b(b), .sum(sum), .carry(carry));

  always_comb begin
    a = ab_combined[0];
    b = ab_combined[1];

    assert (sum   === (a ^ b))
      else $error("…");
    assert (carry === (a & b))
      else $error("…");
  end

  initial begin
    loop_all_values(ab_combined, 2, 5ns);
    $finish;
  end
endmodule
