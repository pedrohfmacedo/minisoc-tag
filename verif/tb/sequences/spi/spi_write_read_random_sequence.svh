
class spi_write_read_random_sequence extends spi_sequence_base;

  `uvm_object_utils(spi_write_read_random_sequence)

  // Constructor
  function new(string name = "spi_write_read_random_sequence");
    super.new(name);
  endfunction

  // Main sequence
  task body();

    spi_item req;

    repeat (100) begin

      req = spi_item::type_id::create("req");

      if (!req.randomize() with {

        // Random WRITE or READ
        is_read inside {
          SPI_WRITE,
          SPI_READ
        };

        // Valid register addresses
        addr inside {
          REG_KEY0,
          REG_KEY1,
          REG_KEY2,
          REG_KEY3,
          REG_IV0,
          REG_IV1,
          REG_IV2,
          REG_IV3,
          REG_COUNTER_HI,
          REG_COUNTER_LO,
          REG_NUM_BLOCKS,
          REG_AES_CONTROL,
          REG_AES_STATUS,
          REG_VERSION,
          REG_SYSTEM_CONTROL,
          REG_SYSTEM_STATUS
        };

        // Restrict WRITE to writable registers
        if (is_read == SPI_WRITE) {
          addr inside {
            REG_KEY0,
            REG_KEY1,
            REG_KEY2,
            REG_KEY3,
            REG_IV0,
            REG_IV1,
            REG_IV2,
            REG_IV3,
            REG_COUNTER_HI,
            REG_COUNTER_LO,
            REG_NUM_BLOCKS,
            REG_AES_CONTROL,
            REG_SYSTEM_CONTROL
          };
        }

        // Avoid triggering AES during random tests
        if (is_read == SPI_WRITE &&
            addr == REG_AES_CONTROL) {
          write_data[0] == 1'b0;
        }

        // SPI period: 40 ns to 100 ns
        period_ps inside {[40000:100000]};

      }) begin

        `uvm_fatal("SPI_RANDOM",
          "Failed to randomize SPI transaction")

      end

      // Send randomized transaction
      if (req.is_read == spi_item::SPI_WRITE) begin

        send_write(
          req.addr,
          req.write_data,
          req.period_ps
        );

      end
      else begin

        send_read(
          req.addr,
          req.period_ps
        );

      end

    end

  endtask

endclass
