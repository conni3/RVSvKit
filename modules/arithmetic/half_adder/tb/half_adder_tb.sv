`timescale 1ns/1ps
import tb_util_pkg::*;  // bring in loop_all_values

module half_adder_tb;
  // 32-bit sweep bus (we only use bits [1:0])
  logic [31:0] ab_combined = 0;
  logic        a, b;
  logic        sum, carry;

  // DUT instantiation
  half_adder uut (
    .a    (a),
    .b    (b),
    .sum  (sum),
    .carry(carry)
  );

  // Split off the two LSBs for the half-adder inputs
  always_comb begin
    a = ab_combined[0];
    b = ab_combined[1];
  end

  //----------------------------------------------------------------------  
  // Property: whenever ab_combined changes, sum==a^b and carry==a&b must hold
  //----------------------------------------------------------------------  
  property p_half_adder;
    @(ab_combined)  // trigger on any change to ab_combined
      (sum   == ab_combined[0] ^ ab_combined[1]) &&
      (carry == ab_combined[0] & ab_combined[1]);
  endproperty

  // Concurrent assertion: fire p_half_adder every time it’s triggered
  assert_half_adder: assert property (p_half_adder)
    else $error("Assertion failed at time=%0t: a=%b b=%b → sum=%b carry=%b",
                $time, a, b, sum, carry);

  //----------------------------------------------------------------------  
  // Drive all 2-bit combinations 5 ns apart, then finish
  //----------------------------------------------------------------------  
  initial begin
    $display("Starting half_adder assertion sweep...");
    loop_all_values(ab_combined, 2, 5ns);
    $display("Completed half_adder assertion sweep");
    $finish;
  end

endmodule
