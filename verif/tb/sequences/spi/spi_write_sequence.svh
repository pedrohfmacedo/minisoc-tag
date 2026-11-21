class spi_write_sequence extends spi_sequence_base;

  `uvm_object_utils(spi_write_sequence)

  function new(string name = "spi_write_sequence");
    super.new(name);
  endfunction

  task body();

    // write KEY0
    send_write(
      spi_item::REG_KEY0,
      40000
    );

    // write KEY1
    send_write(
      spi_item::REG_KEY1,
      40000
    );

    // write KEY2
    send_write(
      spi_item::REG_KEY2,
      40000
    );

    // write KEY3
    send_write(
      spi_item::REG_KEY3,
      40000
    );

    // write IV0
    send_write(
      spi_item::REG_IV0,
      40000
    );

    // write IV1
    send_write(
      spi_item::REG_IV1,
      40000
    );

    // write IV2
    send_write(
      spi_item::REG_IV2,
      40000
    );

    // write IV3
    send_write(
      spi_item::REG_IV3,
      40000
    );

    // write COUNTER_HI
    send_write(
      spi_item::REG_COUNTER_HI,
      40000
    );

    // write COUNTER_LO
    send_write(
      spi_item::REG_COUNTER_LO,
      40000
    );

    // write NUM_BLOCKS
    send_write(
      spi_item::REG_NUM_BLOCKS,
      40000
    );

    // write AES_CONTROL
    send_write(
      spi_item::REG_AES_CONTROL,
      40000
    );

    // write SYSTEM_CONTROL
    send_write(
      spi_item::REG_SYSTEM_CONTROL,
      40000
    );

  endtask

endclass
