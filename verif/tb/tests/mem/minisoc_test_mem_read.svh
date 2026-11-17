class minisoc_test_mem_read extends minisoc_test_mem_base;
  `uvm_component_utils(minisoc_test_mem_read)

  function new(string name = "minisoc_test_mem_read",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    mem_write_sequence preload_seq;
    mem_read_sequence read_seq;

    phase.raise_objection(this);
    preload_seq = mem_write_sequence::type_id::create("preload_seq");
    read_seq = mem_read_sequence::type_id::create("read_seq");
    run_mem_sequence(preload_seq, "read test preload");
    run_mem_sequence(read_seq, "read test");
    phase.drop_objection(this);
  endtask
endclass
