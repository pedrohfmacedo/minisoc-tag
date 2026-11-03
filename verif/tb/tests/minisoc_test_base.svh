class minisoc_test_base extends uvm_test;

  `uvm_component_utils(minisoc_test_base)

  minisoc_env     env;

  function new(string name = "minisoc_test_base",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = minisoc_env::type_id::create("env", this);
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction

endclass
