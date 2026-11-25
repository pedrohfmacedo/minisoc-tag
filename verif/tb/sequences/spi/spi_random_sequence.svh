class spi_random_sequence extends spi_sequence_base;

  `uvm_object_utils(spi_random_sequence)

  function new(string name = "spi_random_sequence");
    super.new(name);
  endfunction

  task body();

    spi_item req;

    `uvm_info("SPI_SEQ", "Starting SPI RANDOM sequence", UVM_LOW)

    repeat (100) begin

      req = spi_item::type_id::create("req");

      start_item(req);

      if (!req.randomize() with {

        // Random WRITE or READ
        is_read inside {
          spi_item::SPI_WRITE,
          spi_item::SPI_READ
        };

        // Valid register addresses
        addr inside {
          spi_item::REG_KEY0,
          spi_item::REG_KEY1,
          spi_item::REG_KEY2,
          spi_item::REG_KEY3,
          spi_item::REG_IV0,
          spi_item::REG_IV1,
          spi_item::REG_IV2,
          spi_item::REG_IV3,
          spi_item::REG_COUNTER_HI,
          spi_item::REG_COUNTER_LO,
          spi_item::REG_NUM_BLOCKS,
          spi_item::REG_AES_CONTROL,
          spi_item::REG_AES_STATUS,
          spi_item::REG_VERSION,
          spi_item::REG_SYSTEM_CONTROL,
          spi_item::REG_SYSTEM_STATUS
        };

        // WRITE only to writable registers
        if (is_read == spi_item::SPI_WRITE) {
          addr inside {
            spi_item::REG_KEY0,
            spi_item::REG_KEY1,
            spi_item::REG_KEY2,
            spi_item::REG_KEY3,
            spi_item::REG_IV0,
            spi_item::REG_IV1,
            spi_item::REG_IV2,
            spi_item::REG_IV3,
            spi_item::REG_COUNTER_HI,
            spi_item::REG_COUNTER_LO,
            spi_item::REG_NUM_BLOCKS,
            spi_item::REG_AES_CONTROL,
            spi_item::REG_SYSTEM_CONTROL
          };
        }

        // Avoid triggering AES START
        if (addr == spi_item::REG_AES_CONTROL &&
            is_read == spi_item::SPI_WRITE) {
          write_data[0] == 1'b0;
        }

        // SPI frequency: 10 MHz to 25 MHz
        period_ps inside {[40000:100000]};

      })
        `uvm_fatal("SPI_RANDOM_SEQ", "Randomization failed")

      finish_item(req);

    end

  endtask

endclass