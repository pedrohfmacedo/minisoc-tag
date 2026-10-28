interface rst_if(input logic clk);
  timeunit 1ps; timeprecision 1ps;
  logic rst_n;

  modport driver (
    input  clk,
    output rst_n
  );

  modport monitor (
    input clk,
    input rst_n
  );
endinterface