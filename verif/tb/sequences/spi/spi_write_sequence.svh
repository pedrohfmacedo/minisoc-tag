
class spi_write_sequence extends spi_sequence_base;

  `uvm_object_utils(spi_write_sequence)

  function new(string name = "spi_write_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_info("SPI_SEQ", "Starting SPI WRITE sequence", UVM_LOW)
    // AES KEY - 128 bits
    send_write(spi_item::REG_KEY0, 32'h00112233);
    send_write(spi_item::REG_KEY1, 32'h44556677);
    send_write(spi_item::REG_KEY2, 32'h8899AABB);
    send_write(spi_item::REG_KEY3, 32'hCCDDEEFF);

    // AES IV - 128 bits
    send_write(spi_item::REG_IV0, 32'h01020304);
    send_write(spi_item::REG_IV1, 32'h05060708);
    send_write(spi_item::REG_IV2, 32'h090A0B0C);
    send_write(spi_item::REG_IV3, 32'h0D0E0F10);

    // COUNTER - 64 bits
    send_write(spi_item::REG_COUNTER_HI, 32'h00000000);
    send_write(spi_item::REG_COUNTER_LO, 32'h00000001);

    // Number of blocks
    send_write(spi_item::REG_NUM_BLOCKS, 32'h00000001);

    // Control registers
    send_write(spi_item::REG_AES_CONTROL, 32'h00000000);
    send_write(spi_item::REG_SYSTEM_CONTROL, 32'h00000000);

  endtask

endclass
