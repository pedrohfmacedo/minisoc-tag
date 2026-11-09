class minisoc_test_clk_2ghz extends minisoc_test_base;

  `uvm_component_utils(minisoc_test_clk_2ghz)

  function new(string name = "minisoc_test_clk_2ghz",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    clk_sequence clk_seq;
    rst_sequence rst_seq;

    phase.raise_objection(this);

    clk_seq = clk_2ghz_sequence::type_id::create("clk_2ghz_seq");
    rst_seq = rst_random_constrained_sequence::type_id::create("rst_random_constrained_seq");

    if (!clk_seq.randomize())
      `uvm_fatal("CLK_TEST", "Falha ao randomizar clock de 2 GHz")
    if (!rst_seq.randomize() with { num_pulses == 3; })
      `uvm_fatal("RST_TEST", "Falha ao randomizar reset constrained")

    fork
      clk_seq.start(env.clk_agt.clk_seqr);
      rst_seq.start(env.rst_agt.rst_seq);
    join

    phase.drop_objection(this);
  endtask

endclass