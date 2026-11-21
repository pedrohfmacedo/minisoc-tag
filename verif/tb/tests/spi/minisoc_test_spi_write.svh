
class minisoc_test_spi_write extends minisoc_test_base;

  `uvm_component_utils(minisoc_test_spi_write)

  function new(string name = "minisoc_test_spi_write",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);

    spi_write_sequence seq_write;

    phase.raise_objection(this);

    seq_write = spi_write_sequence::type_id::create("seq_write");
    seq_write.start(env.spi_agt.spi_seqr);

    phase.drop_objection(this);

  endtask

endclass
