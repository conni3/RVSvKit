# Collect every .sv under common/ and modules/
SV_SOURCES := $(shell find common modules -name '*.sv')


ci-verilator:
	@echo "🔍 Running Verilator lint..."
	@if verilator --lint-only -sv \
	     -Icommon/pkg \
	     --no-timing \
	     -Wno-STMTDLY \
	     $(SV_SOURCES); \
	then \
	  echo "✅ Verilator lint passed! 🎉"; \
	else \
	  echo "❌ Verilator lint failed!"; \
	  exit 1; \
	fi


CI_TBS := $(shell find modules -type f -path '*/tb/*_tb.sv')
$(info CI_TBS = [$(CI_TBS)])

ci-icarus:
	@echo "🔍 Running Icarus simulation on all testbenches..."
	@for tb in $(CI_TBS); do \
	  dir=$${tb%/tb/*}; \
	  base=$$(basename $$tb); \
	  name=$${base%_tb.sv}; \
	  src=$${dir}/src/$${name}.sv; \
	  if [ ! -f "$$src" ]; then \
	    echo "❌ RTL not found: $$src"; \
	    exit 1; \
	  fi; \
	  echo " • $$tb → $$src"; \
	  iverilog -g2012 -Icommon/pkg \
	    common/pkg/tb_util_pkg.sv \
	    "$$src" \
	    "$$tb" \
	    -o "$$tb.out" && \
	  vvp "$$tb.out" || exit 1; \
	done
	@echo "✅ All Icarus runs passed! 🎉"
