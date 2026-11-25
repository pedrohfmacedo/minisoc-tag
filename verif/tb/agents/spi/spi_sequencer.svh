class spi_sequencer #(

    parameter spi_params_pkg::spi_params_t SPI_PARAMS =
        spi_params_pkg::SPI_PARAMS,

    parameter type seq_item_t = spi_item

) extends uvm_sequencer #(seq_item_t);

    `uvm_component_param_utils(
        spi_sequencer #(
            .SPI_PARAMS(SPI_PARAMS),
            .seq_item_t(seq_item_t)
        )
    )

    // Constructor
    function new(
        string name = "spi_sequencer",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction

endclass