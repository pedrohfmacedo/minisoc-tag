
module top_tb;

  timeunit 1ps;
  timeprecision 1ps;

  import uvm_pkg::*;
  import minisoc_pkg::*;

  // Interfaces dirigidas pelos agentes UVM
  clk_if clk_vif();
  rst_if rst_vif(.clk(clk_vif.clk));
  mem_if mem_vif();
  spi_if spi_vif();
  //spi_if spi_vif(.clk(clk_vif.clk));

  minisoc_env_cfg env_cfg;

  // DUT
  minisoc_top dut (
    .clk         (clk_vif.clk),
    .rst_n       (rst_vif.rst_n),

    // SPI interface
    .spi_sclk    (spi_vif.spi_sclk),
    .spi_cs_n    (spi_vif.spi_cs_n),
    .spi_mosi    (spi_vif.spi_mosi),
    .spi_miso    (spi_vif.spi_miso),

    // Memory interface
    .mem_clk     (mem_vif.mem_clk),
    .mem_i_data  (mem_vif.mem_i_data),
    .mem_i_wr_en (mem_vif.mem_i_wr_en),
    .mem_i_addr  (mem_vif.mem_i_addr),
    .mem_o_data  (mem_vif.mem_o_data)
  );

  initial begin

    env_cfg = minisoc_env_cfg::type_id::create("env_cfg");

    // Clock configuration
    env_cfg.clk_cfg_h.vif = clk_vif;

    // Reset configuration
    env_cfg.rst_cfg_h.vif = rst_vif;

    // Memory configuration
    env_cfg.mem_cfg_h.vif = mem_vif;

    // SPI configuration
    env_cfg.spi_cfg_h.vif = spi_vif;

    uvm_config_db#(minisoc_env_cfg)::set(
      null,
      "uvm_test_top.env",
      "cfg",
      env_cfg
    );

    run_test();

  end

  initial begin

    // Geracao opcional de ondas: executar com +DUMP_VCD
    if ($test$plusargs("DUMP_VCD")) begin

      $dumpfile("minisoc.vcd");

      $dumpvars(
        0,
        clk_vif.clk,
        rst_vif.rst_n,
        dut.sys_rst_n,
        dut.pll_locked,
        spi_vif.spi_sclk,
        spi_vif.spi_cs_n,
        spi_vif.spi_mosi,
        spi_vif.spi_miso
      );

    end

  end

endmodule
