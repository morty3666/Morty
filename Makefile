# ------------------------------------------------------------------------------
# Copyright (c) 2018 Angel Terrones <angelterrones@gmail.com>
# ------------------------------------------------------------------------------
include tests/verilator/pprint.mk
SHELL=bash

# ------------------------------------------------------------------------------
.PROJECTNAME = Titan
# ------------------------------------------------------------------------------
.SUBMAKE		= $(MAKE) --no-print-directory
.PWD			= $(shell pwd)
.BFOLDER		= build
.RVTESTSF		= tests/riscv-tests
.RVBENCHMARKSF	= tests/benchmarks
.MKTB			= tests/verilator/build.mk
.TBEXE			= $(.BFOLDER)/$(.PROJECTNAME).exe --timeout 50000000 --file

# ------------------------------------------------------------------------------
# targets
# ------------------------------------------------------------------------------
help:
	@echo -e "--------------------------------------------------------------------------------"
	@echo -e "Please, choose one target:"
	@echo -e "- compile-tests:  Compile RISC-V assembler tests, benchmarks and extra tests."
	@echo -e "- verilate:       Generate C++ core model."
	@echo -e "- build-model:    Build C++ core model."
	@echo -e "- run-tests:      Execute assembler tests, benchmarks and extra tests."
	@echo -e "--------------------------------------------------------------------------------"

compile-tests:
	+@$(.SUBMAKE) -C $(.RVTESTSF)
	+@$(.SUBMAKE) -C $(.RVBENCHMARKSF)

# ------------------------------------------------------------------------------
# verilate and build
verilate:
	@printf "%b" "$(.MSJ_COLOR)Building RTL (Modules) for Verilator$(.NO_COLOR)\n"
	@mkdir -p $(.BFOLDER)
	+@$(.SUBMAKE) -f $(.MKTB) build-vlib BUILD_DIR=$(.BFOLDER)

build-model: verilate
	+@$(.SUBMAKE) -f $(.MKTB) build-core BUILD_DIR=$(.BFOLDER) EXE=$(.PROJECTNAME)

# ------------------------------------------------------------------------------
# verilator tests
run-tests: compile-tests build-model
	$(eval .RVTESTS:=$(shell find $(.RVTESTSF) -name "rv32ui*.elf" -o -name "rv32um*.elf" -o -name "rv32mi*.elf" ! -name "*breakpoint*.elf"))
	$(eval .RVBENCHMARKS:=$(shell find $(.RVBENCHMARKSF) -name "*.riscv"))

	@for file in $(.RVTESTS) $(.RVBENCHMARKS) $(.RVXTRATESTS); do						\
		$(.TBEXE) $$file --mem-delay $$delay > /dev/null;								\
		if [ $$? -eq 0 ]; then															\
			printf "%-50b %b\n" $$file "$(.OK_COLOR)$(.OK_STRING)$(.NO_COLOR)";			\
		else																			\
			printf "%-50s %b" $$file "$(.ERROR_COLOR)$(.ERROR_STRING)$(.NO_COLOR)\n";	\
		fi;																				\
	done
# ------------------------------------------------------------------------------
# clean
# ------------------------------------------------------------------------------
clean:
	@rm -rf $(.BFOLDER)

distclean: clean
	@find . | grep -E "(__pycache__|\.pyc|\.pyo|\.cache)" | xargs rm -rf
	@$(.SUBMAKE) -C $(.RVTESTSF) clean
	@$(.SUBMAKE) -C $(.RVBENCHMARKSF) clean

run_test_ui: 
	@./build/Titan.exe --file tests/riscv-tests/rv32ui-p-$(obj).elf --timeout 100000 --trace

run_test_mi: 
	@./build/Titan.exe --file tests/riscv-tests/rv32mi-p-$(obj).elf --timeout 100000 --trace

run_test_um: 
	@./build/Titan.exe --file tests/riscv-tests/rv32um-p-$(obj).elf --timeout 100000 --trace

run_benchmark:
	@./build/Titan.exe --file tests/benchmarks/$(obj).riscv --timeout 10000000

vcd:
	@gtkwave --giga build/vcd/*.vcd >/dev/null &

.PHONY: verilate compile-tests build-model run-tests clean distclean
