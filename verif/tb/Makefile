.DEFAULT_GOAL := help

SIM          ?= vcs
UVM_VERSION  ?= uvm-1.2
UVM_SEED     ?= 1
UVM_TESTNAME ?= minisoc_test_mem
VERDI       ?= verdi

TB_DIR := $(CURDIR)
WORKSPACE ?= $(TB_DIR)/workspace
RTL_DIR := $(TB_DIR)/../../frontend/rtl
OUT_DIR := $(WORKSPACE)/build/vcs
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
	$(TB_DIR)/agents/clk/clk_if.sv \
	$(TB_DIR)/agents/rst/rst_if.sv \
	$(TB_DIR)/agents/mem/mem_if.sv

PKG_FILE := $(TB_DIR)/top_pkg.sv
TB_TOP   := $(TB_DIR)/top_tb.sv

COMPILE_FLAGS := \
	-full64 \
	-sverilog \
	-ntb_opts $(UVM_VERSION) \
	-timescale=1ps/1ps \
	-kdb \
	-debug_access+all \
	-Mdir=$(OUT_DIR)/csrc \
	+incdir+$(TB_DIR) \
	-l $(LOG_DIR)/vcs_compile.log

RUN_FLAGS := \
	+UVM_TESTNAME=$(UVM_TESTNAME) \
	+ntb_random_seed=$(UVM_SEED) \
	+UVM_TR_RECORD \
	+UVM_LOG_RECORD

SIM_CDS      ?= xrun
OUT_DIR_CDS  := $(WORKSPACE)/build/cadence
LOG_DIR_CDS  := $(OUT_DIR_CDS)/logs
SIMV_CDS     := $(OUT_DIR_CDS)/xrun

COMPILE_FLAGS_CDS := \
	-64bit \
	-sv \
	-elaborate \
	-ntb_opts uvm-1.2 \
	-timescale 1ps/1ps \
	-access +rwc \
	+incdir+$(TB_DIR) \
	-l $(LOG_DIR_CDS)/xrun_compile.log

RUN_FLAGS_CDS := \
	+UVM_TESTNAME=$(UVM_TESTNAME) \
	+ntb_random_seed=$(UVM_SEED) \
	+UVM_TR_RECORD \
	+UVM_LOG_RECORD

COV_FLAGS_CDS := $(COV_FLAGS)

.PHONY: all compile run coverage gui clean help coverage_verdi compile_cds run_cds gui_cds

all: clean compile run

compile:
	@mkdir -p $(LOG_DIR)
	@echo "[VCS] Compiling $(UVM_TESTNAME)"
	cd $(OUT_DIR) && $(SIM) $(COMPILE_FLAGS) $(DUT_FILES) $(IF_FILES) $(PKG_FILE) $(TB_TOP) -top top_tb -o $(SIMV)

run:
	@mkdir -p $(LOG_DIR)
	@echo "[VCS] Running $(UVM_TESTNAME)"
	cd $(OUT_DIR) && $(SIMV) $(RUN_FLAGS) -l $(LOG_DIR)/sim.log

compile_cds:
	@mkdir -p $(LOG_DIR_CDS)
	@echo "[Cadence] Compiling $(UVM_TESTNAME)"
	cd $(OUT_DIR_CDS) && $(SIM_CDS) $(COMPILE_FLAGS_CDS) $(DUT_FILES) $(IF_FILES) $(PKG_FILE) $(TB_TOP) -top top_tb -o $(SIMV_CDS)

run_cds:
	@mkdir -p $(LOG_DIR_CDS)
	@echo "[Cadence] Running $(UVM_TESTNAME)"
	cd $(OUT_DIR_CDS) && $(SIMV_CDS) $(RUN_FLAGS_CDS) -l $(LOG_DIR_CDS)/sim.log

gui: compile
	cd $(OUT_DIR) && $(SIMV) -gui $(RUN_FLAGS) -l $(LOG_DIR)/sim_gui.log

verdi_wf: 
	verdi -play ../cmd/verdi.cmd
gui_cds: compile_cds
	cd $(OUT_DIR_CDS) && $(SIMV_CDS) -gui $(RUN_FLAGS_CDS) -l $(LOG_DIR_CDS)/sim_gui.log

coverage: COMPILE_FLAGS += $(COV_FLAGS)
coverage: RUN_FLAGS += $(COV_FLAGS)
coverage: compile
	@echo "[VCS] Running $(UVM_TESTNAME) with coverage"
	cd $(OUT_DIR) && $(SIMV) $(RUN_FLAGS) -l $(LOG_DIR)/coverage.log
	cd $(OUT_DIR) && $(URG) -dir $(COV_DIR) -report $(COV_REPORT) -format text
	@echo "[URG] Coverage report: $(COV_REPORT)"

coverage_verdi:
	@test -d "$(COV_DIR)" || { echo "[VERDI] Coverage DB not found at $(COV_DIR). Run 'make coverage UVM_TESTNAME=<test>' first."; exit 1; }
	@echo "[VERDI] Opening coverage database: $(COV_DIR)"
	cd $(OUT_DIR) && $(VERDI) -cov -covdir $(COV_DIR)

clean:
	rm -rf $(WORKSPACE)

help:
	@echo "Artifacts are written under $(WORKSPACE)"
	@echo "make compile                 Compile the MiniSoC UVM testbench"
	@echo "make run UVM_TESTNAME=<test> Run a selected UVM test"
	@echo "make compile_cds             Compile the MiniSoC UVM testbench with Cadence"
	@echo "make run_cds UVM_TESTNAME=<test> Run a selected UVM test with Cadence"
	@echo "make coverage UVM_TESTNAME=<test> Run test and generate coverage report"
	@echo "make coverage_verdi          Open the generated Verdi coverage database"
	@echo "make all UVM_TESTNAME=<test> Compile and run"
	@echo "make gui UVM_TESTNAME=<test> Compile and open the GUI"
	@echo "make gui_cds UVM_TESTNAME=<test> Compile and open the Cadence GUI"
	@echo "make clean                   Remove generated simulation files"
