---
title: 03-coding-conventions
draft: false
weight: "8"
aliases: [Coding Conventions]
linter-yaml-title-alias: Coding Conventions
---
# Coding Conventions

This guide defines the SystemVerilog style and naming rules for **RVSvKit**, ensuring consistency with the Overview and Module Inventory.

## 1. File & Module Naming

- **File names**: `lowercase_with_underscores.sv` (e.g., `half_adder.sv`, `load_store_unit.sv`)
	
- **Module & interface names**: match file name exactly (no extension), in `snake_case` (e.g., `module half_adder`)
	
- **Package names**: suffix `_pkg` (e.g., `common_pkg.sv`, `interfaces_pkg.sv`)
	
- **Testbench files**: same basename + `_tb.sv` (e.g., `half_adder_tb.sv`)

## 2. Directory Structure

Modules live under `modules/<category>/<block>/src/` and testbenches under `tb/`.  
E.g.:

```text
modules/arithmetic/half_adder/src/half_adder.sv
modules/arithmetic/half_adder/tb/half_adder_tb.sv
```

## 3. Coding Style & Formatting

- **Indentation**: 2 spaces (no tabs)
	
- **Line length**: wrap at 100 characters
	
- **Blocks**: braces on the same line as statement
	
- **Port lists**: one port per line, aligned

```verilog
module half_adder #(
  parameter int DATA_WIDTH = 1
) (
  input  logic [DATA_WIDTH-1:0] a,
  input  logic [DATA_WIDTH-1:0] b,
  output logic [DATA_WIDTH-1:0] sum,
  output logic carry
);
```

## 4. Procedural Blocks

- **Combinational**: use `always_comb` (not `always @(*)`)
	
- **Sequential**: use `always_ff @ (posedge clk)` with adjacent reset
	
- **Non-blocking vs blocking**:
	
	- Sequential (`always_ff`): non-blocking (`<=`) only
		
	- Combinational (`always_comb`): blocking (`=`) only

## 5. Case Statements & Enums

- Use `unique` or `priority` for `case` statements in FSMs or decoders
	
- Prefer `enum logic [1:0] {S_IDLE, S_BUSY}` for state machines
	
- List all enum values in `case` and include a `default: assert(0);`

## 6. Parameters & Localparams

- **Parameter names**: `UPPER_SNAKE_CASE` (e.g., `DATA_WIDTH`, `ADDR_WIDTH`)
	
- **Localparam names**: prefix `LP_` (e.g., `localparam int LP_STAGE_COUNT = 5`)

## 7. Constants & Signals

- **Signal names**: `snake_case` (e.g., `valid_in`, `ready_out`)
	
- **Constant nets**: `UPPER_SNAKE_CASE` for macros (in `macros_pkg`) or parameters

## 8. Interface & Package Usage

- Group related signals in interfaces; suffix names with `_if` (e.g., `tilelink_if`)
	
- Import packages at top of file:
	
	```verilog
    import common_pkg::*;
    import interfaces_pkg::*;
    ```

## 9. Assertions & Coverage

- Place assertions in `common/utils/assertions.sv`
	
- Use immediate assertions in sequential blocks and concurrent assertions for properties:
	
	```verilog
    logic valid_reg;
    always_ff @(posedge clk) begin
      assert (!valid_reg || ready) else $error("Backpressure violation");
    end
    ```

## 10. Comments & Documentation

- Use `//` for inline comments and `/* … */` for multi-line blocks
	
- For public modules/interfaces, include a header comment with:
	
	- Brief description
		
	- Author & date
		
	- Parameters & ports summary

---
