class minisoc_test_spi_control extends minisoc_test_base;

  `uvm_component_utils(minisoc_test_spi_control)

  function new(string name = "minisoc_test_spi_control",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);

    spi_control_sequence control_seq;
    spi_num_blocks_sequence        num_blocks_seq;
    spi_status_sequence            status_seq;
    phase.raise_objection(this);

    // Control sequence
    control_seq = spi_control_sequence::type_id::create(
      "control_seq"
    );
    control_seq.start(env.spi_agt.spi_seq);

    // NUM_BLOCKS sequence
    num_blocks_seq = spi_num_blocks_sequence::type_id::create(
      "num_blocks_seq"
    );
    num_blocks_seq.start(env.spi_agt.spi_seq);

    // Status sequence
    status_seq = spi_status_sequence::type_id::create(
      "status_seq"
    );
    status_seq.start(env.spi_agt.spi_seq);    
    
    phase.drop_objection(this);

  endtask

endclass
