class minisoc_test_mem_mix extends minisoc_test_mem_base;
  `uvm_component_utils(minisoc_test_mem_mix)

  function new(string name = "minisoc_test_mem_mix",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    mem_mix_sequence seq;

    phase.raise_objection(this);
    seq = mem_mix_sequence::type_id::create("mix_seq");
    run_mem_sequence(seq, "mix test");
    phase.drop_objection(this);
  endtask
endclass
