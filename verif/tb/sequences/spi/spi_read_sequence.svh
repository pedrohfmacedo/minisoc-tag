
class spi_read_sequence extends spi_sequence_base;

  `uvm_object_utils(spi_read_sequence)

  function new(string name = "spi_read_sequence");
    super.new(name);
  endfunction

  task body();

    // AES KEY - 128 bits
    send_read(spi_item::REG_KEY0);
    send_read(spi_item::REG_KEY1);
    send_read(spi_item::REG_KEY2);
    send_read(spi_item::REG_KEY3);

    // AES IV - 128 bits
    send_read(spi_item::REG_IV0);
    send_read(spi_item::REG_IV1);
    send_read(spi_item::REG_IV2);
    send_read(spi_item::REG_IV3);

    // COUNTER - 64 bits
    send_read(spi_item::REG_COUNTER_HI);
    send_read(spi_item::REG_COUNTER_LO);

    // Number of blocks
    send_read(spi_item::REG_NUM_BLOCKS);

    // Control registers
    send_read(spi_item::REG_AES_CONTROL);
    send_read(spi_item::REG_SYSTEM_CONTROL);

  endtask

endclass
