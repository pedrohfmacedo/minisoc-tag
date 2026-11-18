interface spi_if (input logic clk);
  timeunit 1ps; timeprecision 1ps;
  // SPI Mode 0: CPOL = 0 e CPHA = 0.
  // MOSI amostrado na borda de subida de spi_sclk.
  // MISO atualizado na borda de descida de spi_sclk.
  // Ordem de bits MSB-first.
  logic spi_sclk; // clk spi if
  logic spi_cs_n; // Sel low active
  logic spi_mosi; // Data sent to slave // In
  logic spi_miso; // Data sent to master // Out

// Para Mode 0, o monitor pode amostrar MOSI/MISO na subida de spi_sclk

  // Driver agenda os pinos nos ciclos do clock de referência.
  clocking drv_cb @(posedge spi_sclk);
    default input #1step output #0;
    output spi_sclk, spi_cs_n, spi_mosi;
    input  spi_miso;
  endclocking

  // Mode 0: captura os dados na borda de subida.
  clocking mon_cb @(posedge spi_sclk);
    default input #1step;
    input spi_cs_n, spi_mosi, spi_miso;
  endclocking

  modport driver  (clocking drv_cb);
  modport monitor (clocking mon_cb);
  
  endinterface
