module top_tb;

  timeunit 1ps;
  timeprecision 1ps;

  import uvm_pkg::*;
  import minisoc_pkg::*;

  // Interfaces dirigidas pelos agentes UVM.
  clk_if clk_vif();
  rst_if rst_vif(.clk(clk_vif.clk));
  minisoc_env_cfg env_cfg;

  // Interfaces ainda sem agentes: valores inativos para o teste de reset.
  logic        spi_sclk = 1'b0;
  logic        spi_cs_n = 1'b1;
  logic        spi_mosi = 1'b0;
  logic        spi_miso;

  logic        mem_clk     = 1'b0;
  logic [31:0] mem_i_data  = '0;
  logic        mem_i_wr_en = 1'b0;
  logic [9:0]  mem_i_addr  = '0;
  logic [31:0] mem_o_data;

  minisoc_top dut (
    .clk         (clk_vif.clk),
    .rst_n       (rst_vif.rst_n),
    .spi_sclk    (spi_sclk),
    .spi_cs_n    (spi_cs_n),
    .spi_mosi    (spi_mosi),
    .spi_miso    (spi_miso),
    .mem_clk     (mem_clk),
    .mem_i_data  (mem_i_data),
    .mem_i_wr_en (mem_i_wr_en),
    .mem_i_addr  (mem_i_addr),
    .mem_o_data  (mem_o_data)
  );

  initial begin
    env_cfg = minisoc_env_cfg::type_id::create("env_cfg");
    env_cfg.clk_cfg_h.vif = clk_vif;
    env_cfg.rst_cfg_h.vif = rst_vif;

    uvm_config_db#(minisoc_env_cfg)::set(
      null, "uvm_test_top.env", "cfg", env_cfg
    );

    run_test();
  end

    initial begin
    // Geracao opcional de ondas: executar com +DUMP_VCD (make waves).
    if ($test$plusargs("DUMP_VCD")) begin
      $dumpfile("clock_reset.vcd");
      $dumpvars(0, clk_vif.clk, rst_vif.rst_n, dut.sys_rst_n, dut.pll_locked);
    end
  end

endmodule
