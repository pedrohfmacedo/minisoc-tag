class minisoc_test_clk extends minisoc_test_base;

  `uvm_component_utils(minisoc_test_clk)

  function new(string name = "minisoc_test_clk",
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

    // seq = clk_500ps_then_1ns_sequence::type_id::create("nominal_seq");
    // run_clock_sequence(seq, "clock nominal");

    // seq = clk_period_limits_sequence::type_id::create("period_limits_seq");
    // run_clock_sequence(seq, "limites de periodo");

    // seq = clk_bounded_random_sequence::type_id::create("bounded_random_seq");
    // run_clock_sequence(seq, "clock aleatorio limitado");

    // seq = clk_period_limits_sequence::type_id::create("period_limits_seq");
    // run_clock_sequence(seq, "clock limitado");

    // seq = clk_random_constrained_sequence::type_id::create("constrained_seq");
    // run_clock_sequence(seq, "clock constrainted");

    // seq = clk_2ghz_sequence::type_id::create("2ghz_seq");
    // run_clock_sequence(seq, "clock sequence");

    seq = clk_standard_sequence::type_id::create("standard_seq");
    run_clock_sequence(seq, "clock_standard");
    phase.drop_objection(this);
  endtask

endclass

