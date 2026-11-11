class minisoc_test_mem extends minisoc_test_base;

  `uvm_component_utils(minisoc_test_mem)

  function new(string name = "minisoc_test_mem",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    mem_sequence seq;

    phase.raise_objection(this);
    seq = mem_sequence::type_id::create("seq");
    seq.start(env.mem_agt.mem_seqr);
    phase.drop_objection(this);
  endtask
endclass