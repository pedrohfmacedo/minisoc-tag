class minisoc_test_spi_write_read extends minisoc_test_base;

  `uvm_component_utils(minisoc_test_spi_write_read)

function new(string name = "minisoc_test_spi_write_read",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);

    rst_async_assert_sync_deassert_sequence rst_seq;
    spi_write_read_sequence seq;

    phase.raise_objection(this);

    rst_seq = rst_async_assert_sync_deassert_sequence::type_id::create("rst_seq");
    if (!rst_seq.randomize() with {
      num_pulses == 1;
      assert_duration == 10000;
      deassert_cycles == 2;
    })
      `uvm_fatal("SPI_WR_RD_TEST", "Falha ao configurar/resetar o DUT")

    rst_seq.start(env.rst_agt.rst_seq);

    seq = spi_write_read_sequence::type_id::create("seq");
    seq.start(env.spi_agt.spi_seqr);

    phase.drop_objection(this);

  endtask

endclass