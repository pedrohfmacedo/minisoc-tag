
class spi_sequence extends spi_sequence_base;

  `uvm_object_utils(spi_sequence)

  function new(string name = "spi_sequence");
    super.new(name);
  endfunction

  task body();

    spi_back_to_back_sequence       back_to_back_seq;
    spi_control_sequence            control_seq;
    spi_num_blocks_sequence         num_blocks_seq;
    spi_random_sequence             random_seq;
    spi_read_sequence               read_seq;
    spi_status_sequence             status_seq;
    spi_write_read_random_sequence  write_read_random_seq;

    // Create sequences
    back_to_back_seq = spi_back_to_back_sequence::type_id::create("back_to_back_seq");
    control_seq = spi_control_sequence::type_id::create("control_seq");
    num_blocks_seq = spi_num_blocks_sequence::type_id::create("num_blocks_seq");
    random_seq = spi_random_sequence::type_id::create("random_seq");
    read_seq = spi_read_sequence::type_id::create("read_seq");
    status_seq = spi_status_sequence::type_id::create("status_seq");
    write_read_random_seq = spi_write_read_random_sequence::type_id::create("write_read_random_seq");

    // Start sequences
    back_to_back_seq.start(m_sequencer, this);
    control_seq.start(m_sequencer, this);
    num_blocks_seq.start(m_sequencer, this);
    random_seq.start(m_sequencer, this);
    read_seq.start(m_sequencer, this);
    status_seq.start(m_sequencer, this);
    write_read_random_seq.start(m_sequencer, this);

  endtask

endclass
