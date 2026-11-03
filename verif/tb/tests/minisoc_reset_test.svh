class minisoc_reset_test extends minisoc_test_base;

  `uvm_component_utils(minisoc_reset_test)

  function new(string name = "minisoc_reset_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    rst_async_assert_sync_deassert_sequence seq;

    phase.raise_objection(this);
    seq = rst_async_assert_sync_deassert_sequence::type_id::create("seq");
    if (!seq.randomize() with {
      num_pulses == 1;
    })
      `uvm_fatal("RST_TEST", "Falha ao randomizar a sequencia de reset")
    seq.start(env.rst_agt.rst_seq); // seqr
    phase.drop_objection(this);
  endtask

endclass
