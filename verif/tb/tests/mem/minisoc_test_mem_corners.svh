class minisoc_test_mem_corners extends minisoc_test_mem_base;
  `uvm_component_utils(minisoc_test_mem_corners)

  function new(string name = "minisoc_test_mem_corners",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    mem_corners_sequence seq;

    phase.raise_objection(this);
    seq = mem_corners_sequence::type_id::create("corners_seq");
    run_mem_sequence(seq, "corners test");
    phase.drop_objection(this);
  endtask
endclass
