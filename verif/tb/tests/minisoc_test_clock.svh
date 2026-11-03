class minisoc_test_clock extends minisoc_test_base;

  `uvm_component_utils(minisoc_test_clock)

  function new(string name = "minisoc_test_clock",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_clock_sequence(clk_sequence seq, string scenario);
    if (!seq.randomize())
      `uvm_fatal("CLK_TEST", $sformatf("Falha ao randomizar %s", scenario))
    seq.start(env.clk_agt.clk_seqr);
  endtask

  task run_phase(uvm_phase phase);
    clk_sequence seq;

    phase.raise_objection(this);

    seq = clk_500ps_then_1ns_sequence::type_id::create("nominal_seq");
    run_clock_sequence(seq, "clock nominal");

    seq = clk_period_limits_sequence::type_id::create("period_limits_seq");
    run_clock_sequence(seq, "limites de periodo");

    seq = clk_bounded_random_sequence::type_id::create("bounded_random_seq");
    run_clock_sequence(seq, "clock aleatorio limitado");

    phase.drop_objection(this);
  endtask

endclass

class minisoc_test_reset_clock extends minisoc_test_base;

  `uvm_component_utils(minisoc_test_reset_clock)

  function new(string name = "minisoc_test_reset_clock",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_clock_sequence(clk_sequence seq, string scenario);
    if (!seq.randomize())
      `uvm_fatal("CLK_TEST", $sformatf("Falha ao randomizar %s", scenario))
    seq.start(env.clk_agt.clk_seqr);
  endtask

  task run_reset_sequence(rst_sequence seq,
                          int unsigned pulse_count,
                          string scenario);
    if (!seq.randomize() with {
      num_pulses == pulse_count;
      if (assert_mode == rst_item::RST_SYNC)
        assert_cycles inside {[1:5]};
      if (deassert_mode == rst_item::RST_SYNC)
        deassert_cycles inside {[1:5]};
    })
      `uvm_fatal("RST_TEST", $sformatf("Falha ao randomizar %s", scenario))
    seq.start(env.rst_agt.rst_seq);
  endtask

  task run_phase(uvm_phase phase);
    clk_sequence clk_seq;
    rst_sequence rst_seq;

    phase.raise_objection(this);

    clk_seq = clk_500ps_then_1ns_sequence::type_id::create("nominal_seq");
    run_clock_sequence(clk_seq, "clock nominal");

    clk_seq = clk_period_limits_sequence::type_id::create("period_limits_seq");
    run_clock_sequence(clk_seq, "limites de periodo");

    clk_seq = clk_bounded_random_sequence::type_id::create("bounded_random_seq");
    run_clock_sequence(clk_seq, "clock aleatorio limitado");

    rst_seq = rst_fully_async_sequence::type_id::create("fully_async_seq");
    run_reset_sequence(rst_seq, 1, "reset totalmente assincrono");

    rst_seq = rst_sync_posedge_sequence::type_id::create("sync_posedge_seq");
    run_reset_sequence(rst_seq, 1, "reset sincrono na borda de subida");

    rst_seq = rst_sync_negedge_sequence::type_id::create("sync_negedge_seq");
    run_reset_sequence(rst_seq, 1, "reset sincrono na borda de descida");

    rst_seq = rst_async_pulse_train_sequence::type_id::create("async_pulse_train_seq");
    run_reset_sequence(rst_seq, 3, "trem de pulsos assincronos");

    rst_seq = rst_async_assert_sync_deassert_sequence::type_id::create("mixed_seq");
    run_reset_sequence(rst_seq, 1, "assert assincrono e deassert sincrono");

    phase.drop_objection(this);
  endtask

endclass