class clk_sequencer #(

    parameter clk_params_pkg::clk_params_t CLK_PARAMS =
        clk_params_pkg::CLK_PARAMS,

    parameter type seq_item_t = clk_item

) extends uvm_sequencer #(seq_item_t);

    `uvm_component_param_utils(
        clk_sequencer #(
            .CLK_PARAMS(CLK_PARAMS),
            .seq_item_t(seq_item_t)
        )
    )

    // Constructor
    function new(
        string name = "clk_sequencer",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction

endclass