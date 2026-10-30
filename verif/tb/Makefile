.DEFAULT_GOAL := help

SIM          ?= vcs
UVM_VERSION  ?= uvm-1.2
UVM_SEED     ?= 1
UVM_TESTNAME ?= minisoc_reset_test

RTL_DIR := ../../frontend/rtl
OUT_DIR := build/vcs
LOG_DIR := $(OUT_DIR)/logs
SIMV    := $(OUT_DIR)/simv
URG     ?= urg
COV_DIR := $(OUT_DIR)/coverage.vdb
COV_REPORT := $(OUT_DIR)/coverage_report
COV_TYPES ?= line+cond+fsm+tgl+branch+assert
COV_FLAGS := -cm $(COV_TYPES) -cm_dir $(COV_DIR)

# Order matters: dependencies first; minisoc_top is compiled last.
DUT_FILES := \
	$(RTL_DIR)/minisoc_aes/minisoc_aes_key_exp.sv \
	$(RTL_DIR)/minisoc_aes/minisoc_aes_dp.sv \
	$(RTL_DIR)/minisoc_aes/minisoc_aes_top.sv \
	$(RTL_DIR)/minisoc_mem/minisoc_memory.sv \
	$(RTL_DIR)/minisoc_pll/minisoc_pll_mock.sv \
	$(RTL_DIR)/minisoc_spi/minisoc_spi.sv \
	$(RTL_DIR)/minisoc_top.sv

IF_FILES := \
	interfaces/clk_if.sv \
	interfaces/rst_if.sv

PKG_FILE := top_pkg.sv
TB_TOP   := top_tb.sv

COMPILE_FLAGS := \
	-full64 \
	-sverilog \
	-ntb_opts $(UVM_VERSION) \
	-timescale=1ps/1ps \
	-kdb \
	-debug_access+all \
	+incdir+. \
	-l $(LOG_DIR)/vcs_compile.log

RUN_FLAGS := \
	+UVM_TESTNAME=$(UVM_TESTNAME) \
	+ntb_random_seed=$(UVM_SEED) \
	+UVM_TR_RECORD \
	+UVM_LOG_RECORD

.PHONY: all compile run coverage gui clean help

all: compile run

compile:
	@mkdir -p $(LOG_DIR)
	@echo "[VCS] Compiling $(UVM_TESTNAME)"
	$(SIM) $(COMPILE_FLAGS) $(DUT_FILES) $(IF_FILES) $(PKG_FILE) $(TB_TOP) -top top_tb -o $(SIMV)

run:
	@mkdir -p $(LOG_DIR)
	@echo "[VCS] Running $(UVM_TESTNAME)"
	$(SIMV) $(RUN_FLAGS) -l $(LOG_DIR)/sim.log

coverage: COMPILE_FLAGS += $(COV_FLAGS)
coverage: RUN_FLAGS += $(COV_FLAGS)
coverage: compile
	@echo "[VCS] Running $(UVM_TESTNAME) with coverage"
	$(SIMV) $(RUN_FLAGS) -l $(LOG_DIR)/coverage.log
	$(URG) -dir $(COV_DIR) -report $(COV_REPORT) -format text
	@echo "[URG] Coverage report: $(COV_REPORT)"

gui: compile
	$(SIMV) -gui $(RUN_FLAGS) -l $(LOG_DIR)/sim_gui.log

clean:
	rm -rf build csrc ucli.key *.vpd *.fsdb novas.* verdiLog

help:
	@echo "make compile                 Compile the MiniSoC UVM testbench"
	@echo "make run UVM_TESTNAME=<test> Run a selected UVM test"
	@echo "make coverage UVM_TESTNAME=<test> Run test and generate coverage report"
	@echo "make all UVM_TESTNAME=<test> Compile and run"
	@echo "make gui UVM_TESTNAME=<test> Compile and open the GUI"
	@echo "make clean                   Remove generated simulation files"
