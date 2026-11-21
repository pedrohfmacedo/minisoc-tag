class minisoc_test_spi_write_read extends minisoc_test_base;

  `uvm_component_utils(minisoc_test_spi_write_read)

function new(string name = "minisoc_test_spi_write_read",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);

    spi_write_read_random_sequence seq;

    phase.raise_objection(this);

seq = spi_write_read_random_sequence::type_id::create("seq");
    seq.start(env.spi_agt.spi_seqr);

    phase.drop_objection(this);

  endtask

endclass