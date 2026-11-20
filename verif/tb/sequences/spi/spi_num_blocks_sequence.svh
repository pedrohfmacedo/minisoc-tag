
class spi_num_blocks_sequence extends spi_sequence_base;

  `uvm_object_utils(spi_num_blocks_sequence)

  function new(string name = "spi_num_blocks_sequence");
    super.new(name);
  endfunction

  task body();

    // Minimum valid value
    send_write(
      spi_item::REG_NUM_BLOCKS,
      32'd1,
      40000
    );

    send_read(
      spi_item::REG_NUM_BLOCKS,
      40000
    );

    // Two blocks
    send_write(
      spi_item::REG_NUM_BLOCKS,
      32'd2,
      40000
    );

    send_read(
      spi_item::REG_NUM_BLOCKS,
      40000
    );

    // Intermediate value
    send_write(
      spi_item::REG_NUM_BLOCKS,
      32'd128,
      40000
    );

    send_read(
      spi_item::REG_NUM_BLOCKS,
      40000
    );

    // Maximum - 1
    send_write(
      spi_item::REG_NUM_BLOCKS,
      32'd255,
      40000
    );

    send_read(
      spi_item::REG_NUM_BLOCKS,
      40000
    );

    // Maximum valid value
    send_write(
      spi_item::REG_NUM_BLOCKS,
      32'd256,
      40000
    );

    send_read(
      spi_item::REG_NUM_BLOCKS,
      40000
    );

  endtask

endclass
