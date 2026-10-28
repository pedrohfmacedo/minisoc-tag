class rst_sequencer extends uvm_sequencer #(rst_item);
    `uvm_component_utils(rst_sequencer)

  function new( string name = "rst_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass 