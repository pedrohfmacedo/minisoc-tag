class spi_back_to_back_sequence extends spi_sequence_base;

  `uvm_object_utils(spi_back_to_back_sequence)

  function new(string name = "spi_back_to_back_sequence");
    super.new(name);
  endfunction

  task body();

    spi_item req;

    `uvm_info("SPI_SEQ",
      "Starting SPI BACK-TO-BACK sequence",
      UVM_LOW)

    repeat (100) begin

      req = spi_item::type_id::create("req");

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

        // Do not start AES
        if (addr == spi_item::REG_AES_CONTROL &&
            is_read == spi_item::SPI_WRITE) {
          write_data[0] == 1'b0;
        }

        // Keep system control unchanged
        if (addr == spi_item::REG_SYSTEM_CONTROL &&
            is_read == spi_item::SPI_WRITE) {
          write_data == 32'h00000000;
        }

      })
        `uvm_fatal("SPI_B2B_SEQ", "Randomization failed")

      // No additional delay between transactions
      if (req.is_read == spi_item::SPI_WRITE) begin

        send_write(req.addr, req.write_data);

      end
      else begin

        send_read(req.addr);

      end

    end

    `uvm_info("SPI_SEQ",
      "SPI BACK-TO-BACK sequence completed",
      UVM_LOW)

  endtask

endclass