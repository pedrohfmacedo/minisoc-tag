class rst_cfg extends uvm_object;
  // Interface e Agent
  virtual interface rst_if.driver drv_vif;
  virtual interface rst_if.monitor mon_vif;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  `uvm_object_utils_begin(rst_cfg)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_object_utils_end

    // Construtor
    function new(string name = "rst_cfg");
        super.new(name);
    endfunction

endclass
