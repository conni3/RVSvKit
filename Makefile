#------------------------------------------------------------------------------
# Unified Verilator Makefile: runs both sequential (main) and comb (minimal)
#------------------------------------------------------------------------------

#–– Configuration ––
VERILATOR_FLAGS := --cc --exe -sv --timing -Icommon/pkg
VERILATED_DIR   := obj_dir

# shared RTL: packages + src
PKG_SV := $(shell find common/pkg -type f -name "*.sv")
SRC_SV := $(shell find modules   -type f -path "*/src/*.sv")
RTL_SV := $(PKG_SV) $(SRC_SV)

# find every *_tb.sv under modules via shell
TB_SV     := $(shell find modules -type f -path "*/tb/*_tb.sv")
ALL_TOPS  := $(patsubst %.sv,%,$(notdir $(TB_SV)))

# classify sequential vs combinational
SEQ_TB_SV  := $(shell grep -l "posedge clk" $(TB_SV) || true)
SEQ_TOPS   := $(patsubst %.sv,%,$(notdir $(SEQ_TB_SV)))
COMB_TOPS  := $(filter-out $(SEQ_TOPS),$(ALL_TOPS))

# drivers
DRIVER_FULL    := sim_main.cpp
DRIVER_MINIMAL := sim_main_minimal.cpp

.PHONY: all clean $(SEQ_TOPS) $(COMB_TOPS)

# build & run everything
all: $(SEQ_TOPS) $(COMB_TOPS)

# –– sequential testbenches ––
$(SEQ_TOPS): %:
	@echo "=== [SEQ] building + running $@ ==="
	verilator $(VERILATOR_FLAGS) \
	  --top-module $@ \
	  --Mdir $(VERILATED_DIR) \
	  $(RTL_SV) \
	  modules/*/tb/$@.sv \
	  $(DRIVER_FULL)
	make -C $(VERILATED_DIR) -f V$@.mk -j$(shell nproc)
	./$(VERILATED_DIR)/V$@

# –– combinational testbenches ––
$(COMB_TOPS): %:
	@echo "=== [COMB] building + running $@ ==="
	@TB_PATH=`find modules -type f -path "*/tb/$@.sv" | head -n1` ; \
	if [ -z "$$TB_PATH" ]; then \
	  echo "❌ Could not locate testbench for $@"; exit 1; \
	fi ; \
	verilator $(VERILATOR_FLAGS) \
	  --top-module $@ \
	  --Mdir $(VERILATED_DIR) \
	  $(RTL_SV) \
	  "$$TB_PATH" \
	  $(DRIVER_MINIMAL) ; \
	make -C $(VERILATED_DIR) -f V$@.mk -j$(shell nproc) ; \
	./$(VERILATED_DIR)/V$@

# clean up
clean:
	rm -rf $(VERILATED_DIR) *.vcd
