class clk_cfg extends uvm_object;

  // Has-a
  virtual interface clk_if.driver  drv_vif;
  virtual interface clk_if.monitor mon_vif;
  // Agent ativo ou passivo?
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Definiçoes padrao do clk
  int unsigned period_ps = 500;
  int unsigned time_low_ps = 250;
  int unsigned time_high_ps = 250;
  int unsigned min_period_ps = 100;
  int unsigned max_period_ps = 10000;
  bit enable = 1'b1;

  // Macro + Fiedls
  `uvm_object_utils_begin(clk_cfg)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(period_ps, UVM_DEFAULT)
    `uvm_field_int(time_low_ps, UVM_DEFAULT)
    `uvm_field_int(time_high_ps, UVM_DEFAULT)
    `uvm_field_int(min_period_ps, UVM_DEFAULT)
    `uvm_field_int(max_period_ps, UVM_DEFAULT)
    `uvm_field_int(enable, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor
  function new(string name = "clk_cfg");
    super.new(name);
  endfunction

endclass
