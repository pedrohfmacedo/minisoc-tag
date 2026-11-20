class spi_read_sequence extends spi_sequence_base;

  `uvm_object_utils(spi_read_sequence)

  function new(string name = "spi_read_sequence");
    super.new(name);
  endfunction

  task body();

    // Read KEY0
    send_read(
      spi_item::REG_KEY0,
      40000
    );

    // Read KEY1
    send_read(
      spi_item::REG_KEY1,
      40000
    );

    // Read KEY2
    send_read(
      spi_item::REG_KEY2,
      40000
    );

    // Read KEY3
    send_read(
      spi_item::REG_KEY3,
      40000
    );

    // Read IV0
    send_read(
      spi_item::REG_IV0,
      40000
    );

    // Read IV1
    send_read(
      spi_item::REG_IV1,
      40000
    );

    // Read IV2
    send_read(
      spi_item::REG_IV2,
      40000
    );

    // Read IV3
    send_read(
      spi_item::REG_IV3,
      40000
    );

    // Read COUNTER_HI
    send_read(
      spi_item::REG_COUNTER_HI,
      40000
    );

    // Read COUNTER_LO
    send_read(
      spi_item::REG_COUNTER_LO,
      40000
    );

    // Read NUM_BLOCKS
    send_read(
      spi_item::REG_NUM_BLOCKS,
      40000
    );

    // Read AES_CONTROL
    send_read(
      spi_item::REG_AES_CONTROL,
      40000
    );

    // Read SYSTEM_CONTROL
    send_read(
      spi_item::REG_SYSTEM_CONTROL,
      40000
    );

  endtask

endclass
