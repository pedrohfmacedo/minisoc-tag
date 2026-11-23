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

    // Write KEY2
    send_write(
      spi_item::REG_KEY2,
      32'h11223344,
      40000
    );

    // Write KEY3
    send_write(
      spi_item::REG_KEY3,
      32'h55667788,
      40000
    );

    // Write IV0
    send_write(
      spi_item::REG_IV0,
      32'h11223344,
      40000
    );

    // Write IV1
    send_write(
      spi_item::REG_IV1,
      32'h55667788,
      40000
    );

    // Write IV2
    send_write(
      spi_item::REG_IV2,
      32'h99AABBCC,
      40000
    );

    // Write IV3
    send_write(
      spi_item::REG_IV3,
      32'hDDEEFF00,
      40000
    );

    // Write COUNTER_HI
    send_write(
      spi_item::REG_COUNTER_HI,
      32'h00000001,
      40000
    );

    // Write COUNTER_LO
    send_write(
      spi_item::REG_COUNTER_LO,
      32'h00000000,
      40000
    );

    // Write NUM_BLOCKS
    send_write(
      spi_item::REG_NUM_BLOCKS,
      32'd16,
      40000
    );

    // Write AES_CONTROL
    send_write(
      spi_item::REG_AES_CONTROL,
      32'h00000000,
      40000
    );

    // Write SYSTEM_CONTROL
    send_write(
      spi_item::REG_SYSTEM_CONTROL,
      32'h00000000,
      40000
    );

  endtask


  // task body();

  //   spi_item req;

  //   repeat (20) begin

  //     req = spi_item::type_id::create("req");

  //     if (!req.randomize() with {
  //       is_read == SPI_WRITE;
  //       addr inside {
  //         REG_KEY0,
  //         REG_KEY1,
  //         REG_KEY2,
  //         REG_KEY3,
  //         REG_IV0,
  //         REG_IV1,
  //         REG_IV2,
  //         REG_IV3,
  //         REG_COUNTER_HI,
  //         REG_COUNTER_LO,
  //         REG_NUM_BLOCKS,
  //         REG_AES_CONTROL,
  //         REG_SYSTEM_CONTROL
  //       };
  //     })
  //       `uvm_fatal("SPI_SEQ", "Randomization failed")

  //     send_write(
  //       req.addr,
  //       req.write_data,
  //       req.period_ps
  //     );

  //   end

  // endtask


endclass




