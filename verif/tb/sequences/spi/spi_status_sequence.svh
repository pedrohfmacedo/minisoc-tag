class spi_status_sequence extends spi_sequence_base;

  `uvm_object_utils(spi_status_sequence)

  function new(string name = "spi_status_sequence");
    super.new(name);
  endfunction

  task body();

    // Read AES_STATUS
    send_read(spi_item::REG_AES_STATUS);

    // Read SYSTEM_STATUS
    send_read(spi_item::REG_SYSTEM_STATUS);

    // Read AES_STATUS again
    send_read(spi_item::REG_AES_STATUS);

    // Read SYSTEM_STATUS again
    send_read(spi_item::REG_SYSTEM_STATUS);

  endtask

endclass