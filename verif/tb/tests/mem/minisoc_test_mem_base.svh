class minisoc_test_mem_base extends minisoc_test_base;
  `uvm_component_utils(minisoc_test_mem_base)

  function new(string name = "minisoc_test_mem_base",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_mem_sequence(mem_sequence_base seq, string scenario);
    if (seq == null)
      `uvm_fatal("MEM_TEST", $sformatf("Sequence is null: %s", scenario))
    seq.start(env.mem_agt.mem_seqr);
  endtask
endclass
