//-------------------------------------------------------------------------
// Module : half_adder
// Author : Connie
// Date   : 2025-06-20
// Brief  : 1 bit adder: calculate sum and carry out from two bits
//-------------------------------------------------------------------------
module half_adder #(
  parameter int DATA_WIDTH = 1
) (
  input  logic [DATA_WIDTH-1:0] a,
  input  logic [DATA_WIDTH-1:0] b,
  output logic [DATA_WIDTH-1:0] sum,
  output logic carry
);
  // Calculate sum and carry
  assign sum = a ^ b;          // Sum is the XOR of a and b
  assign carry = a & b;        // Carry is the AND of a and b
  // Note: For DATA_WIDTH > 1, this will still work bit-wise

  // This module is intended for single-bit addition.
  // For multi-bit addition, use a full adder or a ripple carry adder.
  // The carry output is a single bit, regardless of DATA_WIDTH.

endmodule: half_adder