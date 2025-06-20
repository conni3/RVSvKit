`timescale 1ns/1ps
module half_adder_tb;
  // Instantiate DUT
  half_adder uut (
    .a(1'b0), // First input bit
    .b(1'b0), // Second input bit
    .sum(),   // Sum output bit
    .carry()  // Carry output bit
  );

  initial begin
    // TODO: stimulus
    #100 $finish;
  end
endmodule
