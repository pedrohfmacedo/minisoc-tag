interface mem_if;
  timeunit 1ps; timeprecision 1ps;
  logic mem_clk; // In
  logic [31:0] mem_i_data; // input data to memory // In
  logic mem_i_wr_en; //1 = write, 0 = read // In
  logic [9:0] mem_i_addr; // In
  logic [31:0] mem_o_data; // Out

  modport driver (
    output mem_clk,
    output mem_i_data,
    output mem_i_wr_en,
    output mem_i_addr,
    input mem_o_data

  );

  modport monitor (
    input mem_clk,
    input mem_i_data,
    input mem_i_wr_en,
    input mem_i_addr,
    output mem_o_data
  );
  endinterface