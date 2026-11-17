class minisoc_test_mem_write extends minisoc_test_mem_base;
  `uvm_component_utils(minisoc_test_mem_write)

  function new(string name = "minisoc_test_mem_write",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    mem_write_sequence seq;

    phase.raise_objection(this);
    seq = mem_write_sequence::type_id::create("write_seq");
    run_mem_sequence(seq, "write test");
    phase.drop_objection(this);
  endtask
endclass
