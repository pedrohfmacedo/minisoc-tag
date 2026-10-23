
#################################################################
#                           GENERAL
#################################################################

.DEFAULT_GOAL := help

VCS_KDB   = -kdb
VCS_DEBUG = -debug_access+all +ntb_random_seed=random
VCS_FLAGS = -full64 -sverilog -l ./vcs_logger.log $(VCS_KDB) $(VCS_DEBUG) -timescale=1ns/1ps

.PHONY: vcs_clean \
        vcs_comp_aes vcs_run_aes vcs_fall_aes \
        vcs_comp_mem vcs_run_mem vcs_fall_mem \
        vcs_comp_pll vcs_run_pll vcs_fall_pll \
        vcs_comp_spi vcs_run_spi vcs_fall_spi \
        vcs_comp_top vcs_run_top vcs_fall_top \
        vcs_gui help

#################################################################
#                            A E S
#################################################################

MINISOC_AES_FILES = \
	../rtl/minisoc_aes/minisoc_aes_dp.sv \
	../rtl/minisoc_aes/minisoc_aes_key_exp.sv \
	../rtl/minisoc_aes/minisoc_aes_top.sv

MINISOC_AES_TB = \
	./minisoc_aes_top_tb.sv

#################################################################
#                            M E M
#################################################################

MINISOC_MEM_FILES = \
	../rtl/minisoc_mem/minisoc_memory.sv

MINISOC_MEM_TB = \
	./minisoc_memory_tb.sv

#################################################################
#                            P L L
#################################################################

MINISOC_PLL_FILES = \
	../rtl/minisoc_pll/minisoc_pll_mock.sv

MINISOC_PLL_TB = \
	./minisoc_pll_mock_tb.sv

#################################################################
#                            S P I
#################################################################

MINISOC_SPI_FILES = \
	../rtl/minisoc_spi/minisoc_spi.sv

MINISOC_SPI_TB = \
	./minisoc_spi_tb.sv

#################################################################
#                            T O P
#################################################################

MINISOC_TOP_FILES = \
	../rtl/minisoc_aes/minisoc_aes_key_exp.sv \
	../rtl/minisoc_aes/minisoc_aes_dp.sv \
	../rtl/minisoc_aes/minisoc_aes_top.sv \
	../rtl/minisoc_mem/minisoc_memory.sv \
	../rtl/minisoc_pll/minisoc_pll_mock.sv \
	../rtl/minisoc_spi/minisoc_spi.sv \
	../rtl/minisoc_top.sv

MINISOC_TOP_TB = \
	./minisoc_top_tb.sv

#################################################################
#                           CLEAN
#################################################################

vcs_clean:
	@echo "[VCS] Cleaning simulation files"
	rm -rf csrc simv.daidir *.log
	rm -rf simv ucli.key *.vpd verdiLog *.fsdb novas.*

#################################################################
#                         AES TARGETS
#################################################################

vcs_comp_aes:
	@echo "[VCS] Compiling ( A E S )"
	vcs $(VCS_FLAGS) $(MINISOC_AES_FILES) $(MINISOC_AES_TB)

vcs_run_aes:
	@echo "[VCS] Running ( A E S )"
	./simv

vcs_fall_aes:
	@echo "[VCS] Compiling and Running ( A E S )"
	$(MAKE) vcs_clean
	$(MAKE) vcs_comp_aes
	$(MAKE) vcs_run_aes

#################################################################
#                         MEM TARGETS
#################################################################

vcs_comp_mem:
	@echo "[VCS] Compiling ( M E M )"
	vcs $(VCS_FLAGS) $(MINISOC_MEM_FILES) $(MINISOC_MEM_TB)

vcs_run_mem:
	@echo "[VCS] Running ( M E M )"
	./simv

vcs_fall_mem:
	@echo "[VCS] Compiling and Running ( M E M )"
	$(MAKE) vcs_clean
	$(MAKE) vcs_comp_mem
	$(MAKE) vcs_run_mem

#################################################################
#                         PLL TARGETS
#################################################################

vcs_comp_pll:
	@echo "[VCS] Compiling ( P L L )"
	vcs $(VCS_FLAGS) $(MINISOC_PLL_FILES) $(MINISOC_PLL_TB)

vcs_run_pll:
	@echo "[VCS] Running ( P L L )"
	./simv

vcs_fall_pll:
	@echo "[VCS] Compiling and Running ( P L L )"
	$(MAKE) vcs_clean
	$(MAKE) vcs_comp_pll
	$(MAKE) vcs_run_pll

#################################################################
#                         SPI TARGETS
#################################################################

vcs_comp_spi:
	@echo "[VCS] Compiling ( S P I )"
	vcs $(VCS_FLAGS) $(MINISOC_SPI_FILES) $(MINISOC_SPI_TB)

vcs_run_spi:
	@echo "[VCS] Running ( S P I )"
	./simv

vcs_fall_spi:
	@echo "[VCS] Compiling and Running ( S P I )"
	$(MAKE) vcs_clean
	$(MAKE) vcs_comp_spi
	$(MAKE) vcs_run_spi

#################################################################
#                         TOP TARGETS
#################################################################

vcs_comp_top:
	@echo "[VCS] Compiling ( T O P )"
	vcs $(VCS_FLAGS) $(MINISOC_TOP_FILES) $(MINISOC_TOP_TB)

vcs_run_top:
	@echo "[VCS] Running ( T O P )"
	./simv

vcs_fall_top:
	@echo "[VCS] Compiling and Running ( T O P )"
	$(MAKE) vcs_clean
	$(MAKE) vcs_comp_top
	$(MAKE) vcs_run_top

#################################################################
#                         GUI TARGET
#################################################################

vcs_gui:
	@echo "[VCS] Opening simulation GUI"
	./simv -gui

#################################################################
#                            HELP
#################################################################

help:
	@echo "======================================"
	@echo "        MINISOC - VCS MAKEFILE        "
	@echo "======================================"
	@echo "Compilation:"
	@echo "  make vcs_comp_aes"
	@echo "  make vcs_comp_mem"
	@echo "  make vcs_comp_pll"
	@echo "  make vcs_comp_spi"
	@echo "  make vcs_comp_top"
	@echo ""
	@echo "Simulation:"
	@echo "  make vcs_run_aes"
	@echo "  make vcs_run_mem"
	@echo "  make vcs_run_pll"
	@echo "  make vcs_run_spi"
	@echo "  make vcs_run_top"
	@echo ""
	@echo "Clean + Compile + Run:"
	@echo "  make vcs_fall_aes"
	@echo "  make vcs_fall_mem"
	@echo "  make vcs_fall_pll"
	@echo "  make vcs_fall_spi"
	@echo "  make vcs_fall_top"
	@echo ""
	@echo "Other:"
	@echo "  make vcs_clean"
	@echo "  make vcs_gui"
