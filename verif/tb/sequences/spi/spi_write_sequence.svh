class spi_write_sequence extends spi_sequence_base #(spi_item);
  `uvm_object_utils(spi_write_sequence)

function new(string name = "spi_write_seq");
    super.new(name);
  endfunction

  task body();

// Write KEY0
    send_write(
      spi_item::REG_KEY0,
      32'h12345678,
      40000
    );

// Write KEY1
    send_write(
      spi_item::REG_KEY1,
      32'hAABBCCDD,
      40000
    );

// Write IV0
    send_write(
      spi_item::REG_IV0,
      32'h11223344,
      40000
    );

// Write NUM_BLOCKS
    send_write(
      spi_item::REG_NUM_BLOCKS,
      32'd16,
      40000
    );

  endtask

endclass
