class spi_control_sequence extends spi_sequence_base;

  `uvm_object_utils(spi_control_sequence)

function new(string name = "spi_control_sequence");
    super.new(name);
  endfunction

  task body();

// Encrypt, MODE = 000, START = 0
    send_write(
      spi_item::REG_AES_CONTROL,
      32'h00000000,
      40000
    );

send_read(
      spi_item::REG_AES_CONTROL,
      40000
    );

// Decrypt, MODE = 000, START = 0
    send_write(
      spi_item::REG_AES_CONTROL,
      32'h00000002,
      40000
    );

send_read(
      spi_item::REG_AES_CONTROL,
      40000
    );

// Encrypt, MODE = 001, START = 0
    send_write(
      spi_item::REG_AES_CONTROL,
      32'h00000004,
      40000
    );

send_read(
      spi_item::REG_AES_CONTROL,
      40000
    );

// Decrypt, MODE = 001, START = 0
    send_write(
      spi_item::REG_AES_CONTROL,
      32'h00000006,
      40000
    );

send_read(
      spi_item::REG_AES_CONTROL,
      40000
    );

// Encrypt, MODE = 010, START = 0
    send_write(
      spi_item::REG_AES_CONTROL,
      32'h00000008,
      40000
    );

send_read(
      spi_item::REG_AES_CONTROL,
      40000
    );

// Decrypt, MODE = 010, START = 0
    send_write(
      spi_item::REG_AES_CONTROL,
      32'h0000000A,
      40000
    );

send_read(
      spi_item::REG_AES_CONTROL,
      40000
    );

// START = 1, DECRYPT = 0, MODE = 000
    // START is a pulse, not a persistent bit
    send_write(
      spi_item::REG_AES_CONTROL,
      32'h00000001,
      40000
    );

// Read CONTROL to verify START returns to 0
    send_read(
      spi_item::REG_AES_CONTROL,
      40000
    );

  endtask

endclass