package minisoc_pkg;

  timeunit 1ps;
  timeprecision 1ps;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Clock agent
  `include "agents/clk/clk_cfg.svh"
  `include "agents/clk/clk_item.svh"
  `include "agents/clk/clk_sequencer.svh"
  `include "agents/clk/clk_driver.svh"
  `include "agents/clk/clk_monitor.svh"
  `include "agents/clk/clk_agent.svh"

  // Reset agent: item/configuration must be declared before its components.
  `include "agents/rst/rst_item.svh"
  `include "agents/rst/rst_cfg.svh"
  `include "agents/rst/rst_sequencer.svh"
  `include "agents/rst/rst_driver.svh"
  `include "agents/rst/rst_monitor.svh"
  `include "coverage/rst_coverage.svh/coverage_rst.svh"
  `include "agents/rst/rst_agent.svh"

  // Environment built from the currently implemented agents.
  `include "env/minisoc_env_cfg.svh"
  `include "env/minisoc_env.svh"

  // Reset sequence and initial UVM tests.
  `include "agents/clk/clk_sequences.svh"
  `include "agents/rst/rst_sequences.svh"
  `include "tests/minisoc_test_base.svh"
  `include "tests/minisoc_reset_test.svh"

endpackage
