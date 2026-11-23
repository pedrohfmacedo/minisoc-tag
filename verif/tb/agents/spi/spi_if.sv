//interface spi_if (input logic clk);
interface spi_if ();

  timeunit 1ps;
  timeprecision 1ps;

  // SPI Mode 0: CPOL = 0, CPHA = 0
  // MOSI sampled on rising edge
  // MISO updated on falling edge
  // MSB first

  logic spi_sclk;
  logic spi_cs_n;
  logic spi_mosi;
  logic spi_miso;

  // Monitor clocking block
  clocking mon_cb @(posedge spi_sclk);
    default input #1step;

    input spi_cs_n;
    input spi_mosi;
    input spi_miso;
  endclocking

  // Driver controls SPI pins directly
  modport driver (
    output spi_sclk,
    output spi_cs_n,
    output spi_mosi,
    input  spi_miso
  );

  // Monitor only observes SPI signals
  modport monitor (
    clocking mon_cb,
    input spi_sclk,
    input spi_cs_n,
    input spi_mosi,
    input spi_miso
  );

endinterface

// //interface spi_if (input logic clk);
// interface spi_if ();

//   timeunit 1ps;
//   timeprecision 1ps;

//   // SPI Mode 0: CPOL = 0, CPHA = 0
//   // MOSI sampled on rising edge
//   // MISO updated on falling edge
//   // MSB first

//   logic spi_sclk;
//   logic spi_cs_n;
//   logic spi_mosi;
//   logic spi_miso;

//   // Monitor clocking block
//   clocking mon_cb @(posedge spi_sclk);
//     default input #1step;

//     input spi_cs_n;
//     input spi_mosi;
//     input spi_miso;
//   endclocking

//   // Driver controls SPI pins directly
//   modport driver (
//     output spi_sclk,
//     output spi_cs_n,
//     output spi_mosi,
//     input  spi_miso
//   );

//   // Monitor only observes SPI signals
//   modport monitor (
//     clocking mon_cb,
//     input spi_sclk,
//     input spi_cs_n,
//     input spi_mosi,
//     input spi_miso
//   );

// endinterface
