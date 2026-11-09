package minisoc_pkg;

  timeunit 1ps;
  timeprecision 1ps;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

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

  // Environment
  `include "env/minisoc_env_cfg.svh"
  `include "env/minisoc_env.svh"

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

  // Tests
  `include "tests/minisoc_test_base.svh"
  `include "tests/minisoc_reset_test.svh"
  `include "tests/minisoc_test_reset.svh"
  `include "tests/minisoc_test_clock.svh"
  `include "tests/minisoc_test_reset_clock.svh"
  `include "tests/minisoc_test_random_constrained.svh"
  `include "tests/minisoc_test_clk_2ghz.svh"

endpackage
