class spi_control_sequence extends spi_sequence_base;

  `uvm_object_utils(spi_control_sequence)

  function new(string name = "spi_control_sequence");
    super.new(name);
  endfunction

  task body();

    `uvm_info("SPI_SEQ", "Starting SPI CONTROL sequence", UVM_LOW)

    // Encrypt, MODE = 000, START = 0
    send_write(spi_item::REG_AES_CONTROL, 32'h00000000);
    send_read(spi_item::REG_AES_CONTROL);

    // Decrypt, MODE = 000, START = 0
    send_write(spi_item::REG_AES_CONTROL, 32'h00000002);
    send_read(spi_item::REG_AES_CONTROL);

    // Encrypt, MODE = 001, START = 0
    send_write(spi_item::REG_AES_CONTROL, 32'h00000004);
    send_read(spi_item::REG_AES_CONTROL);

    // Decrypt, MODE = 001, START = 0
    send_write(spi_item::REG_AES_CONTROL, 32'h00000006);
    send_read(spi_item::REG_AES_CONTROL);

    // Encrypt, MODE = 010, START = 0
    send_write(spi_item::REG_AES_CONTROL, 32'h00000008);
    send_read(spi_item::REG_AES_CONTROL);

    // Decrypt, MODE = 010, START = 0
    send_write(spi_item::REG_AES_CONTROL, 32'h0000000A);
    send_read(spi_item::REG_AES_CONTROL);

    // START = 1, DECRYPT = 0, MODE = 000
    // START is a pulse, not a persistent bit
    send_write(spi_item::REG_AES_CONTROL, 32'h00000001);

    // Read CONTROL to verify START returns to 0
    send_read(spi_item::REG_AES_CONTROL);

  endtask

endclass