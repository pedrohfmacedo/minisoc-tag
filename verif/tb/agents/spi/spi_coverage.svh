class spi_coverage extends uvm_subscriber #(spi_item);
  `uvm_component_utils(spi_coverage)

  covergroup spi_cg with function sample(spi_item item);
    option.per_instance = 1;

  cp_operation: coverpoint item.is_read {
    bins write = {spi_item::SPI_WRITE};
    bins read  = {spi_item::SPI_READ};
  }
  
  cp_addr: coverpoint item.addr {
    bins key0 = {spi_item::REG_KEY0};
    bins key1 = {spi_item::REG_KEY1};
    bins key2 = {spi_item::REG_KEY2};
    bins key3 = {spi_item::REG_KEY3};
    bins iv   = {spi_item::REG_IV0, spi_item::REG_IV1,
                  spi_item::REG_IV2, spi_item::REG_IV3};
    bins counter = {spi_item::REG_COUNTER_HI,
                      spi_item::REG_COUNTER_LO};
    bins num_blocks     = {spi_item::REG_NUM_BLOCKS};
    bins aes_control    = {spi_item::REG_AES_CONTROL};
    bins aes_status     = {spi_item::REG_AES_STATUS};
    bins version        = {spi_item::REG_VERSION};
    bins system_control = {spi_item::REG_SYSTEM_CONTROL};
    bins system_status  = {spi_item::REG_SYSTEM_STATUS};
  }

  cp_num_blocks: coverpoint item.write_data
    iff (item.is_read == spi_item::SPI_WRITE &&
         item.addr == spi_item::REG_NUM_BLOCKS) {
    bins min_value = {32'd1};
    bins lower     = {[32'd2:32'd127]};
    bins upper     = {[32'd128:32'd255]};
    bins max_value = {32'd256};
  }

  cp_period: coverpoint item.period_ps {
    bins max_frequency = {40000};
    bins near_max      = {[40001:50000]};
  }
  endgroup

  // Constructor  
  function new(string name = "spi_coverage",
               uvm_component parent = null);
    super.new(name, parent);
    spi_cg = new();
  endfunction

  // Sample function to collect coverage data
  function void write(spi_item t);
    spi_cg.sample(t);
  endfunction

endclass
