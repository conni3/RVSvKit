`timescale 1ns/1ps

module half_adder_tb;
  logic [1:0] ab_combined;
  logic        a, b;
  logic        sum, carry;

  half_adder uut (
    .a    (a),
    .b    (b),
    .sum  (sum),
    .carry(carry)
  );

  always_comb begin
    a = ab_combined[0];
    b = ab_combined[1];
  end

  initial begin
  $display("Starting half_adder smoke test…");
  for (int i = 0; i < 4; i++) begin
    
    ab_combined = i;
    #5;  // with `timescale 1ns/1ps`, that’s 5 ns
    $display("  i=%0d a=%b b=%b → sum=%b carry=%b",
             i, a, b, sum, carry);
  end
  $finish;
end

endmodule
