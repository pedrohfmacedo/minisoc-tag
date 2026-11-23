
class spi_write_read_sequence extends spi_sequence_base;

  `uvm_object_utils(spi_write_read_sequence)

  function new(string name = "spi_write_read_sequence");
    super.new(name);
  endfunction

  task body();

    spi_write_sequence write_seq;
    spi_read_sequence  read_seq;

    // Create sequences
    write_seq = spi_write_sequence::type_id::create("write_seq");
    read_seq  = spi_read_sequence::type_id::create("read_seq");

    // Execute all WRITE transactions
    `uvm_info("SPI_SEQ",
      "Starting SPI WRITE sequence",
      UVM_MEDIUM)

    write_seq.start(m_sequencer);

    // Execute all READ transactions
    `uvm_info("SPI_SEQ",
      "Starting SPI READ sequence",
      UVM_MEDIUM)

    read_seq.start(m_sequencer);

    `uvm_info("SPI_SEQ",
      "SPI WRITE/READ sequence completed",
      UVM_MEDIUM)

  endtask

endclass
