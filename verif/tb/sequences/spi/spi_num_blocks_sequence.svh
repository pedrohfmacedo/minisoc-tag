class spi_num_blocks_sequence extends spi_sequence_base;

  `uvm_object_utils(spi_num_blocks_sequence)

  function new(string name = "spi_num_blocks_sequence");
    super.new(name);
  endfunction

  task body();

    `uvm_info("SPI_SEQ", "Starting SPI NUM_BLOCKS sequence", UVM_LOW)

    // Minimum valid value
    send_write(spi_item::REG_NUM_BLOCKS, 32'd1);
    send_read(spi_item::REG_NUM_BLOCKS);

    // Two blocks
    send_write(spi_item::REG_NUM_BLOCKS, 32'd2);
    send_read(spi_item::REG_NUM_BLOCKS);

    // Intermediate value
    send_write(spi_item::REG_NUM_BLOCKS, 32'd128);
    send_read(spi_item::REG_NUM_BLOCKS);

    // Maximum - 1
    send_write(spi_item::REG_NUM_BLOCKS, 32'd255);
    send_read(spi_item::REG_NUM_BLOCKS);

    // Maximum valid value
    send_write(spi_item::REG_NUM_BLOCKS, 32'd256);
    send_read(spi_item::REG_NUM_BLOCKS);

  endtask

endclass