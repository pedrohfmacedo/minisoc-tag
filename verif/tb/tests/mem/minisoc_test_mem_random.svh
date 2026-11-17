class minisoc_test_mem_random extends minisoc_test_mem_base;
  `uvm_component_utils(minisoc_test_mem_random)

  function new(string name = "minisoc_test_mem_random",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    mem_random_sequence seq;

    phase.raise_objection(this);
    seq = mem_random_sequence::type_id::create("random_seq");
    run_mem_sequence(seq, "random test");
    phase.drop_objection(this);
  endtask
endclass
