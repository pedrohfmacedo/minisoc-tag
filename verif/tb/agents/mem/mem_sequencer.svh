class mem_sequencer #(

    parameter mem_params_pkg::mem_params_t MEM_PARAMS =
        mem_params_pkg::MEM_PARAMS,

    parameter type seq_item_t = mem_item

) extends uvm_sequencer #(seq_item_t);

    `uvm_component_param_utils(
        mem_sequencer #(
            .MEM_PARAMS(MEM_PARAMS),
            .seq_item_t(seq_item_t)
        )
    )

    // Constructor
    function new(
        string name = "mem_sequencer",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction

endclass