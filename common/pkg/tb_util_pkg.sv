//-------------------------------------------------------------------------
// Package   : tb_util_pkg
// Version   : 0.1.0
// Author    : Connie
// Date      : 2025-06-20
// Brief     : Testbench helper tasks (full-range & custom-range looping)
//-------------------------------------------------------------------------
`timescale 1ns/1ps


package tb_util_pkg;

  //-------------------------------------------------------------------------
  // loop_all_values:
  //   Drives a W-bit signal from 0 to (2**W-1) in increments of 1,
  //   waiting `step` timeunits between each value.
  //-------------------------------------------------------------------------
  task automatic loop_all_values
    (output logic [31:0] sig,  // your signal (only lower W bits used)
     input int          W,   // width in bits
     input time         step // delay between assignments
    );
    int max_val;
    begin
      max_val = 1 << W;
      for (int i = 0; i < max_val; i++) begin
        sig = i[31:0];
        #step;
      end
    end
  endtask: loop_all_values

  //-------------------------------------------------------------------------
  // loop_range:
  //   Drives an integer/reference var from `start` to `stop` (inclusive)
  //   by `step`, waiting `delay` timeunits between each.
  //-------------------------------------------------------------------------
  task automatic loop_range
    (
      inout int   loop_val, // reference variable to update
      input  int   start,    // first value
      input  int   stop,     // last value (inclusive)
      input  int   step,     // increment
      input  time  delay     // time to wait each iteration
    );
    int v;
    begin
      for (v = start; v <= stop; v += step) begin
        loop_val = v;
        #delay;
      end
    end
  endtask: loop_range

endpackage: tb_util_pkg
