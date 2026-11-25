// Abordar a parametrizável para reutilizar diferentes epescializaçoes do vips.
class minisoc_virtual_sequencer #(
    // SPI parameters
    parameter spi_params_pkg::spi_params_t SPI_PARAMS =
        spi_params_pkg::SPI_PARAMS,
    parameter type spi_item_t = spi_item,
    // MEM parameters
    parameter mem_params_pkg::mem_params_t MEM_PARAMS =
        mem_params_pkg::MEM_PARAMS,
    parameter type mem_item_t = mem_item,
    // CLK parameters
    parameter clk_params_pkg::clk_params_t CLK_PARAMS =
        clk_params_pkg::CLK_PARAMS,
    parameter type clk_item_t = clk_item,
    // RST parameters
    parameter rst_params_pkg::rst_params_t RST_PARAMS =
        rst_params_pkg::RST_PARAMS,
    parameter type rst_item_t = rst_item

) extends uvm_sequencer;

    `uvm_component_param_utils(
        minisoc_virtual_sequencer #(
            SPI_PARAMS, spi_item_t,
            MEM_PARAMS, mem_item_t,
            CLK_PARAMS, clk_item_t,
            RST_PARAMS, rst_item_t
        )
    )

    // Sequencer types
    typedef spi_sequencer #(
        .SPI_PARAMS(SPI_PARAMS),
        .seq_item_t(spi_item_t)
    ) spi_sequencer_t;

    typedef mem_sequencer #(
        .MEM_PARAMS(MEM_PARAMS),
        .seq_item_t(mem_item_t)
    ) mem_sequencer_t;

    typedef clk_sequencer #(
        .CLK_PARAMS(CLK_PARAMS),
        .seq_item_t(clk_item_t)
    ) clk_sequencer_t;

    typedef rst_sequencer #(
        .RST_PARAMS(RST_PARAMS),
        .seq_item_t(rst_item_t)
    ) rst_sequencer_t;

    // Has-a: Agent sequencer handles
    spi_sequencer_t spi_sqr;
    mem_sequencer_t mem_sqr;
    clk_sequencer_t clk_sqr;
    rst_sequencer_t rst_sqr;

    // Constructor
    function new(
        string name = "minisoc_virtual_sequencer",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction

endclass

// class minisoc_virtual_sequencer extends uvm_sequencer;
//     `uvm_component_utils(minisoc_virtual_sequencer)

//     // Has-a (sequencers)
//     spi_sequencer spi_sqr;
//     mem_sequencer mem_sqr;
//     rst_sequencer rst_sqr;
//     clk_sequencer clk_sqr;

//     //Constructor
//     function new (string name = "minisoc_virtual_sequencer", uvm_component parent = null);
//         super.new(name, parent);
//     endfunction

// endclass

// class minisoc_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);

//     `uvm_component_utils(minisoc_virtual_sequencer)

//     // Agent sequencer handles
//     spi_sequencer spi_sqr;
//     mem_sequencer mem_sqr;
//     clk_sequencer clk_sqr;
//     rst_sequencer rst_sqr;

//     // Constructor
//     function new(
//         string name = "minisoc_virtual_sequencer",
//         uvm_component parent = null
//     );
//         super.new(name, parent);
//     endfunction

// endclass