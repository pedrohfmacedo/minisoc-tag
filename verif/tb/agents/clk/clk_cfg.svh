class clk_cfg extends uvm_object;
  // Configuracoes de clock.
  virtual interface clk_if.driver vif;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuracoes de clock em picosegundos.
  int unsigned period    = 500;
  int unsigned time_low  = 250;
  int unsigned time_high = 250;
  bit enable = 1'b1;

  // Os campos devem ser declarados antes deste macro.
  `uvm_object_utils_begin(clk_cfg)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(period,    UVM_DEFAULT)
    `uvm_field_int(time_low,  UVM_DEFAULT)
    `uvm_field_int(time_high, UVM_DEFAULT)
    `uvm_field_int(enable,    UVM_DEFAULT)
  `uvm_object_utils_end

    // Construtor
    function new(string name = "clk_cfg");
        super.new(name);
    endfunction

endclass
