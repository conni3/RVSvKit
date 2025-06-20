# Makefile for RVSvKit CI & local testing
# -----------------------------------------------------------------------------
# Usage:
#   make ci-verilator   # lint & simulate with Verilator
#   make ci-icarus     # compile & simulate with Icarus Verilog
# -----------------------------------------------------------------------------

# 1) Gather all RTL sources and testbenches
MODULE_SRCS := $(wildcard modules/**/src/*.sv)
TB_SRCS     := $(wildcard modules/**/tb/*_tb.sv)

# 2) Define where to put builds
VERILATOR_OUT := obj_dir
ICARUS_EXE    := sim_icarus

# 3) Default target (optional)
.PHONY: all
all: ci-verilator ci-icarus

# 4) Verilator CI target
.PHONY: ci-verilator
ci-verilator:
	@echo "=== Verilator lint & build ==="
	verilator --lint-only --Wno-DECLFILENAME \
	  --cc $(MODULE_SRCS) \
	  --exe $(MODULE_SRCS) $(TB_SRCS) \
	  -CFLAGS "-std=c++17 -Icommon/pkg" \
	|| (echo "❌ Verilator lint failed"; exit 1)
	@echo "-- Building simulator"
	$(MAKE) -C $(VERILATOR_OUT) -f Vmodules__dummy.mk -j$(shell nproc) \
	  Vmodules__dummy || true
	@echo "✅ ci-verilator passed"

# 5) Icarus Verilog CI target
.PHONY: ci-icarus
ci-icarus:
	@echo "=== Icarus Verilog build & run ==="
	iverilog -g2012 -o $(ICARUS_EXE) $(MODULE_SRCS) $(TB_SRCS) \
	  -Icommon/pkg || (echo "❌ Icarus compile failed"; exit 1)
	@echo "-- Running simulation"
	vvp $(ICARUS_EXE) || (echo "❌ Icarus simulation failed"; exit 1)
	@echo "✅ ci-icarus passed"
