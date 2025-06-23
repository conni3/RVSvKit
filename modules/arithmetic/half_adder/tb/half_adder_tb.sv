`timescale 1ns/1ps

import tb_util_pkg::*;

module half_adder_tb;

  logic a;
  logic b;
  logic sum;
  logic carry;

  // Instantiate DUT
  half_adder uut (
    .a(1'b0), // First input bit
    .b(1'b0), // Second input bit
    .sum(),   // Sum output bit
    .carry()  // Carry output bit
  );


  // Combine a and b into a single bus for looping
  logic [31:0] ab_combined;

  // Drive a and b from ab_combined
  always_comb begin
    a = ab_combined[0];
    b = ab_combined[1];
  end

  initial begin
    $dumpfile("half_adder.vcd");
    $dumpvars(0, half_adder_tb);
    
    $display("Starting half_adder test...");
    $monitor("a=%b b=%b => sum=%b carry=%b", a, b, sum, carry);

    loop_all_values(ab_combined, 2, 5ns);

    $display("Test complete.");
    $finish;
  end


endmodule: half_adder_tb
