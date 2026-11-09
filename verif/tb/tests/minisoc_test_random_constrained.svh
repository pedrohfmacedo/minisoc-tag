class minisoc_test_random_constrained extends minisoc_test_base;

  `uvm_component_utils(minisoc_test_random_constrained)

  function new(string name = "minisoc_test_random_constrained",
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
    if (!seq.randomize() with { num_pulses == pulse_count; })
      `uvm_fatal("RST_TEST", $sformatf("Falha ao randomizar %s", scenario))
    seq.start(env.rst_agt.rst_seq);
  endtask

  task run_phase(uvm_phase phase);
    clk_sequence clk_seq;
    rst_sequence rst_seq;

    phase.raise_objection(this);

    clk_seq = clk_random_constrained_sequence::type_id::create("clk_random_constrained_seq");
    run_clock_sequence(clk_seq, "clock aleatorio constrained");

    rst_seq = rst_random_constrained_sequence::type_id::create("rst_random_constrained_seq");
    run_reset_sequence(rst_seq, 3, "reset aleatorio constrained");

    phase.drop_objection(this);
  endtask

endclass
