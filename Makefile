# ------------------------------------------------------------------------------
# Copyright (c) 2018 Angel Terrones <angelterrones@gmail.com>
# ------------------------------------------------------------------------------
include tests/verilator/pprint.mk
SHELL=bash

# ------------------------------------------------------------------------------
.PROJECTNAME = XYZ
# ------------------------------------------------------------------------------
.SUBMAKE		= $(MAKE) --no-print-directory
.PWD			= $(shell pwd)
.BFOLDER		= build
.RVTESTSF		= tests/riscv-tests
.RVBENCHMARKSF	= tests/benchmarks
.RVXTRASF       = tests/extra-tests
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
	+@$(.SUBMAKE) -C $(.RVXTRASF)

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
	$(eval .RVXTRAS:=$(shell find $(.RVXTRASF) -name "*.riscv"))

	@for file in $(.RVTESTS) $(.RVBENCHMARKS) $(.RVXTRAS); do						\
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
	@$(.SUBMAKE) -C $(.RVXTRASF) clean

.PHONY: verilate compile-tests build-model run-tests clean distclean
