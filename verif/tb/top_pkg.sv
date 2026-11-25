`include "agents/clk/clk_params_pkg.sv"
`include "agents/rst/rst_params_pkg.sv"
`include "agents/mem/mem_params_pkg.sv"
`include "agents/spi/spi_params_pkg.sv"

package minisoc_pkg;

  timeunit 1ps;
  timeprecision 1ps;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // ================================================================
  // ===================         A G E N T        ===================
  // ================================================================
  // Clock agent
  `include "agents/clk/clk_cfg.svh"
  `include "agents/clk/clk_item.svh"
  `include "agents/clk/clk_coverage.svh"
  `include "agents/clk/clk_sequencer.svh"
  `include "agents/clk/clk_driver.svh"
  `include "agents/clk/clk_monitor.svh"
  `include "agents/clk/clk_agent.svh"

  // Reset agent
  `include "agents/rst/rst_item.svh"
  `include "agents/rst/rst_cfg.svh"
  `include "agents/rst/rst_sequencer.svh"
  `include "agents/rst/rst_driver.svh"
  `include "agents/rst/rst_monitor.svh"
  `include "agents/rst/rst_coverage.svh"
  `include "agents/rst/rst_agent.svh"

  // Memory agent
  `include "agents/mem/mem_item.svh"
  `include "agents/mem/mem_cfg.svh"
  `include "agents/mem/mem_sequencer.svh" 
  `include "agents/mem/mem_driver.svh"
  `include "agents/mem/mem_monitor.svh"
  `include "agents/mem/mem_coverage.svh"
  `include "agents/mem/mem_checker.svh"
  `include "agents/mem/mem_agent.sv"

  // SPI agent

  `include "agents/spi/spi_item.svh"
  `include "agents/spi/spi_cfg.svh"
  `include "agents/spi/spi_sequencer.svh"
  `include "agents/spi/spi_driver.svh"
  `include "agents/spi/spi_monitor.svh"
  `include "agents/spi/spi_coverage.svh"
  `include "agents/spi/spi_agent.sv"

  // ================================================================
  // ===================         E N V            ===================
  // ================================================================
  // Environment
  `include "env/minisoc_env_cfg.svh"
  `include "env/minisoc_virtual_sequencer.svh"
  typedef minisoc_virtual_sequencer #(

    .virtual_item_t(uvm_sequence_item),

    .SPI_PARAMS(spi_params_pkg::SPI_PARAMS),
    .spi_item_t(spi_item),

    .MEM_PARAMS(mem_params_pkg::MEM_PARAMS),
    .mem_item_t(mem_item),

    .CLK_PARAMS(clk_params_pkg::CLK_PARAMS),
    .clk_item_t(clk_item),

    .RST_PARAMS(rst_params_pkg::RST_PARAMS),
    .rst_item_t(rst_item)

) minisoc_virtual_sequencer_t;

  `include "env/minisoc_env.svh"
  

  // ================================================================
  // ===================      S E Q U E N C E     ===================
  // ================================================================

  // Clock sequences
  `include "sequences/clk/clk_sequence.svh"
  `include "sequences/clk/clk_2ghz_sequence.svh"
  `include "sequences/clk/clk_500ps_then_1ns_sequence.svh"
  `include "sequences/clk/clk_period_limits_sequence.svh"
  `include "sequences/clk/clk_bounded_random_sequence.svh"
  `include "sequences/clk/clk_random_constrained_sequence.svh"

  // Reset sequences
  `include "sequences/rst/rst_sequence.svh"
  `include "sequences/rst/rst_async_assert_sync_deassert_sequence.svh"
  `include "sequences/rst/rst_fully_async_sequence.svh"
  `include "sequences/rst/rst_sync_posedge_sequence.svh"
  `include "sequences/rst/rst_sync_negedge_sequence.svh"
  `include "sequences/rst/rst_async_pulse_train_sequence.svh"
  `include "sequences/rst/rst_random_constrained_sequence.svh"

  // Memory sequences
  `include "sequences/mem/mem_sequence_base.svh"
  `include "sequences/mem/mem_write_sequence.svh"
  `include "sequences/mem/mem_read_sequence.svh"
  `include "sequences/mem/mem_random_sequence.svh"
  `include "sequences/mem/mem_corners_sequence.svh"
  `include "sequences/mem/mem_mix_sequence.svh"
  `include "sequences/mem/mem_sequence.svh"

  // SPI sequences
  `include "sequences/spi/spi_sequence_base.svh"
  `include "sequences/spi/spi_back_to_back_sequence.svh"
  `include "sequences/spi/spi_control_sequence.svh"
  `include "sequences/spi/spi_num_blocks_sequence.svh"
  `include "sequences/spi/spi_random_sequence.svh"
  `include "sequences/spi/spi_read_sequence.svh"
  `include "sequences/spi/spi_status_sequence.svh"
  `include "sequences/spi/spi_write_read_random_sequence.svh"
  `include "sequences/spi/spi_write_sequence.svh"
  `include "sequences/spi/spi_write_read_sequence.svh"
  `include "sequences/spi/spi_sequence.svh"

  // MINISOC sequences
  `include "sequences/soc/minisoc_ditl_sequence.svh"
  `include "sequences/soc/minisoc_virtual_base_sequence.svh"
  `include "sequences/soc/minisoc_virtual_smoke_sequence.svh"

  // ================================================================
  // ===================          T E S T         ===================
  // ================================================================

  // Tests
  `include "tests/soc/minisoc_test_base.svh"

  // Clock tests
  `include "tests/clk/minisoc_test_clock.svh"
  `include "tests/clk/minisoc_test_clk_2ghz.svh"

  // Reset tests
  `include "tests/rst/minisoc_reset_test.svh"
  `include "tests/rst/minisoc_test_reset.svh"

  // Memory tests
  `include "tests/mem/minisoc_test_mem_base.svh"
  `include "tests/mem/minisoc_test_mem_write.svh"
  `include "tests/mem/minisoc_test_mem_read.svh"
  `include "tests/mem/minisoc_test_mem_random.svh"
  `include "tests/mem/minisoc_test_mem_corners.svh"
  `include "tests/mem/minisoc_test_mem_mix.svh"
  `include "tests/mem/minisoc_test_mem.svh"

  // SPI tests
  `include "tests/spi/minisoc_test_spi_control.svh"
  `include "tests/spi/minisoc_test_spi_read.svh"
  `include "tests/spi/minisoc_test_spi_write_read.svh"
  `include "tests/spi/minisoc_test_spi_write.svh"
  `include "tests/spi/minisoc_test_spi.svh"
  `include "tests/spi/minisoc_test_spi_all.svh"
  
  // SoC integration tests
  `include "tests/soc/minisoc_test_random_constrained.svh"
  `include "tests/soc/minisoc_test_reset_clock.svh"
  `include "tests/soc/minisoc_test_ditl.svh"
  `include "tests/soc/minisoc_test_smoke.svh"
endpackage