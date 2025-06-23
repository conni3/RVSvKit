# ─── Variables ───────────────────────────────────────────────────────────────

TOP        := half_adder_tb
SV_SRCS    := \
  modules/arithmetic/half_adder/src/half_adder.sv \
  modules/arithmetic/half_adder/tb/half_adder_tb.sv \
  sim_main.cpp

VERILATOR  := verilator
VER_FLAGS  := --cc --exe -sv \
              -Icommon/pkg \
              --trace      \
              --Mdir obj_dir
LINT_FLAGS := --lint-only -sv -Icommon/pkg

BUILD_JOBS := -j8

# ─── Targets ────────────────────────────────────────────────────────────────

.PHONY: all lint run clean

all: obj_dir/V$(TOP)

# Lint-only pass
lint:
	$(VERILATOR) $(LINT_FLAGS) $(SV_SRCS)

# Generate C++, build the simulator
obj_dir/V$(TOP): $(SV_SRCS)
	$(VERILATOR) $(VER_FLAGS) $(SV_SRCS)
	$(MAKE) $(BUILD_JOBS) -C obj_dir -f V$(TOP).mk V$(TOP)

# Build then execute
run: all
	@echo ">> Running simulation..."
	@./obj_dir/V$(TOP)

clean:
	rm -rf obj_dir
