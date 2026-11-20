
class minisoc_test_spi_write extends minisoc_test_base;

  `uvm_component_utils(minisoc_test_spi_write)

  function new(string name = "minisoc_test_spi_write",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);

    spi_write_sequence seq;

    phase.raise_objection(this);

    seq = spi_write_sequence::type_id::create("seq");
    seq.start(env.spi_agt.spi_seq);

    phase.drop_objection(this);

  endtask

endclass
