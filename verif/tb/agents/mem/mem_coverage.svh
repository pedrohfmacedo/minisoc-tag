class mem_coverage extends uvm_subscriber #(mem_item);

  `uvm_component_utils(mem_coverage)

// covergroups....

  function new(string name = "mem_coverage",
               uvm_component parent = null);
    super.new(name, parent);
    clk_cg = new();
  endfunction

  function void write(mem_item t);
    clk_cg.sample(t);
  endfunction

endclass
