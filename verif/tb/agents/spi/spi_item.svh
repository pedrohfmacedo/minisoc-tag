
class spi_item extends uvm_sequence_item;

  // SPI operation
  typedef enum bit {
    SPI_WRITE = 1'b0,
    SPI_READ  = 1'b1
  } spi_op;

  // SPI register addresses
  typedef enum bit [5:0] {
    REG_KEY0           = 6'h00,
    REG_KEY1           = 6'h01,
    REG_KEY2           = 6'h02,
    REG_KEY3           = 6'h03,
    REG_IV0            = 6'h04,
    REG_IV1            = 6'h05,
    REG_IV2            = 6'h06,
    REG_IV3            = 6'h07,
    REG_COUNTER_HI     = 6'h08,
    REG_COUNTER_LO     = 6'h09,
    REG_NUM_BLOCKS     = 6'h0A,
    REG_AES_CONTROL    = 6'h0B,
    REG_AES_STATUS     = 6'h0C,
    REG_VERSION        = 6'h0D,
    REG_SYSTEM_CONTROL = 6'h0E,
    REG_SYSTEM_STATUS  = 6'h0F,
    REG_NOP            = 6'h3F
  } spi_addr;

  // SPI transaction fields
  rand spi_op       is_read;
  rand spi_addr     addr;
  rand bit [31:0]   write_data;
  rand int unsigned period_ps = 0;
  rand bit [31:0]   read_data;
  // Data constraints
  constraint spi_c {
    if (is_read == SPI_READ) {
      write_data == 32'd0;
    }
    else if (addr == REG_NUM_BLOCKS) {
      write_data inside {[32'd1:32'd256]};
    }
  }
  
  // SPI timing constraint (maximum 25 MHz)
  constraint spi_timing_c {
    period_ps >= 40000;
  }

  // UVM factory registration and field automation
  `uvm_object_utils_begin(spi_item)
    `uvm_field_enum(spi_op, is_read, UVM_ALL_ON)
    `uvm_field_enum(spi_addr, addr, UVM_ALL_ON)
    `uvm_field_int(write_data, UVM_ALL_ON)
    `uvm_field_int(period_ps, UVM_ALL_ON)
    `uvm_field_int(read_data, UVM_ALL_ON)
  `uvm_object_utils_end

  // Constructor
  function new(string name = "spi_item");
    super.new(name);
  endfunction

endclass
