// interface mem_if;
//   timeunit 1ps; timeprecision 1ps;
//   logic mem_clk; // In
//   logic [31:0] mem_i_data; // input data to memory // escrever
//   logic mem_i_wr_en; //1 = write, 0 = read // In
//   logic [9:0] mem_i_addr; // In endereço
//   logic [31:0] mem_o_data; // Out ler

//   modport driver (
//     output mem_clk,
//     output mem_i_data,
//     output mem_i_wr_en,
//     output mem_i_addr,
//     input mem_o_data

//   );

//   modport monitor (
//     input mem_clk,
//     input mem_i_data,
//     input mem_i_wr_en,
//     input mem_i_addr,
//     input mem_o_data // in?
//   );
//   endinterface


// clocking blocking para evitar race conditions e garantir sincronia 
interface mem_if;
    timeunit 1ps; timeprecision 1ps;

    logic        mem_clk;
    logic [31:0] mem_i_data;
    logic        mem_i_wr_en;
    logic [9:0]  mem_i_addr;
    logic [31:0] mem_o_data;

    // Driver Clocking Block
    clocking drv_cb @(negedge mem_clk); // negdge druver abtes da borda ativa
        default input #1step output #1ps;
        output mem_i_data;
        output mem_i_wr_en;
        output mem_i_addr;
        input  mem_o_data;
    endclocking

    // Monitor Clocking Block
    clocking mon_cb @(posedge mem_clk);
        default input #1step;
        input mem_i_data;
        input mem_i_wr_en;
        input mem_i_addr;
        input mem_o_data;
    endclocking

    modport driver (
        clocking drv_cb,
        output mem_clk
    );

    modport monitor (
        clocking mon_cb,
        input mem_clk
    );

endinterface