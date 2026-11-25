class rst_sequencer #(

    parameter rst_params_pkg::rst_params_t RST_PARAMS =
        rst_params_pkg::RST_PARAMS,

    parameter type seq_item_t = rst_item

) extends uvm_sequencer #(seq_item_t);

    `uvm_component_param_utils(
        rst_sequencer #(
            .RST_PARAMS(RST_PARAMS),
            .seq_item_t(seq_item_t)
        )
    )

    // Constructor
    function new(
        string name = "rst_sequencer",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction

endclass