class spi_cfg extends uvm_object;

  virtual interface spi_if vif;

  // Agent ativo ou passivo?
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Definiçoes padrao da
  time period_ps = 40ns; // 40ns = 25MHz

  // Macro + Fiedls
   `uvm_object_utils_begin(spi_cfg)
     `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
     `uvm_field_int(period_ps, UVM_DEFAULT)
   `uvm_object_utils_end

  // Constructor
  function new(string name = "spi_cfg");
    super.new(name);
  endfunction

endclass
