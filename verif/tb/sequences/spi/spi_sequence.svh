class spi_sequence extends spi_sequence_base #(spi_item);
  `uvm_object_utils(spi_sequence)

  function new(string name = "spi_sequence");
    super.new(name);
  endfunction

  task body ()
    spi_write_sequence write_seq;
    spi_read_sequence read_seq;
    spi_write_read_sequence write_read_seq;
    spi_readwrite_random_sequence readwrite_random_seq;
    spi_back_to_back_sequence back_to_back_seq;

    write_seq = write_seq::type_id::create("write_seq");
    read_seq = read_seq::type_id::create("read_seq");
    write_read_seq = spi_readwrite_random_sequence::type_id::create("write_read_seq");
    readwrite_random_seq = spi_readwrite_random_sequence::type_id::create("readwrite_random_seq");
    back_to_back_seq = spi_back_to_back_sequence::type_id::create("back_to_back_seq");

    write_seq.start(s_sequencer, this); 
    read_seq.start(s_sequencer, this);  
    write_read_seq.start(s_sequencer, this);  
    readwrite_random_seq.start(s_sequencer, this);  
    back_to_back_seq.start(s_sequencer, this);  
  endtask

endclass
