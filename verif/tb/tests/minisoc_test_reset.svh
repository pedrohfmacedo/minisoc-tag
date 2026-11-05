
class minisoc_test_reset extends minisoc_test_base;

  `uvm_component_utils(minisoc_test_reset)

  function new(string name = "minisoc_test_reset",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_reset_sequence(rst_sequence seq,
                          int unsigned pulse_count,
                          string scenario);
    if (!seq.randomize() with { num_pulses == pulse_count; })
      `uvm_fatal("RST_TEST", $sformatf("Falha ao randomizar %s", scenario))
    seq.start(env.rst_agt.rst_seq);
  endtask

  task run_phase(uvm_phase phase);
    rst_sequence seq;

    phase.raise_objection(this);

    seq = rst_fully_async_sequence::type_id::create("fully_async_seq");
    run_reset_sequence(seq, 1, "reset totalmente assincrono");

    seq = rst_sync_posedge_sequence::type_id::create("sync_posedge_seq");
    run_reset_sequence(seq, 1, "reset sincrono na borda de subida");

    seq = rst_sync_negedge_sequence::type_id::create("sync_negedge_seq");
    run_reset_sequence(seq, 1, "reset sincrono na borda de descida");

    seq = rst_async_pulse_train_sequence::type_id::create("async_pulse_train_seq");
    run_reset_sequence(seq, 3, "trem de pulsos assincronos");

    seq = rst_async_assert_sync_deassert_sequence::type_id::create("mixed_seq");
    run_reset_sequence(seq, 1, "assert assincrono e deassert sincrono");

    phase.drop_objection(this);
  endtask

endclass
