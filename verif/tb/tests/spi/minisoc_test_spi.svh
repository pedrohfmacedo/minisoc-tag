
class minisoc_test_spi extends minisoc_test_base;

  `uvm_component_utils(minisoc_test_spi)

  function new(string name = "minisoc_test_spi",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);

    spi_back_to_back_sequence      back_to_back_seq;
    spi_control_sequence           control_seq;
    spi_num_blocks_sequence        num_blocks_seq;
    spi_random_sequence            random_seq;
    spi_read_sequence              read_seq;
    spi_status_sequence            status_seq;
    spi_write_read_random_sequence write_read_random_seq;

    phase.raise_objection(this);

    // Back-to-back sequence
    back_to_back_seq = spi_back_to_back_sequence::type_id::create(
      "back_to_back_seq"
    );
    back_to_back_seq.start(env.spi_agt.spi_seqr);

    // Control sequence
    control_seq = spi_control_sequence::type_id::create(
      "control_seq"
    );
    control_seq.start(env.spi_agt.spi_seqr);

    // NUM_BLOCKS sequence
    num_blocks_seq = spi_num_blocks_sequence::type_id::create(
      "num_blocks_seq"
    );
    num_blocks_seq.start(env.spi_agt.spi_seqr);

    // Random sequence
    random_seq = spi_random_sequence::type_id::create(
      "random_seq"
    );
    random_seq.start(env.spi_agt.spi_seqr);

    // Read sequence
    read_seq = spi_read_sequence::type_id::create(
      "read_seq"
    );
    read_seq.start(env.spi_agt.spi_seqr);

    // Status sequence
    status_seq = spi_status_sequence::type_id::create(
      "status_seq"
    );
    status_seq.start(env.spi_agt.spi_seqr);

    // Write/Read random sequence
    write_read_random_seq = spi_write_read_random_sequence::type_id::create(
      "write_read_random_seq"
    );
    write_read_random_seq.start(env.spi_agt.spi_seqr);

    phase.drop_objection(this);

  endtask

endclass
