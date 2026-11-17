class minisoc_test_mem extends minisoc_test_mem_base;

  `uvm_component_utils(minisoc_test_mem)

  function new(string name = "minisoc_test_mem",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    mem_write_sequence write_seq;
    mem_read_sequence read_seq;
    mem_random_sequence random_seq;
    mem_corners_sequence corners_seq;
    mem_mix_sequence mix_seq;

    phase.raise_objection(this);
    write_seq = mem_write_sequence::type_id::create("write_seq");
    read_seq = mem_read_sequence::type_id::create("read_seq");
    random_seq = mem_random_sequence::type_id::create("random_seq");
    corners_seq = mem_corners_sequence::type_id::create("corners_seq");
    mix_seq = mem_mix_sequence::type_id::create("mix_seq");

    run_mem_sequence(write_seq, "full write");
    run_mem_sequence(read_seq, "full read");
    run_mem_sequence(random_seq, "random operations");
    run_mem_sequence(corners_seq, "corner addresses");
    run_mem_sequence(mix_seq, "back-to-back operations");

    phase.drop_objection(this);
  endtask
endclass

/* Versao anterior de minisoc_test_mem:
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
*/