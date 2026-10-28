class rst_cfg extends uvm_object;
    // Macros UVM
  `uvm_object_utils_begin(rst_cfg)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_object_utils_end

    // Interface e Agent
    virtual rst_if.driver drv_vif;
    virtual rst_if.monitor mon_vif; 
    uvm_active_passive_enum is_active = UVM_ACTIVE;

    // Construtor
    function new(string name = "rst_cfg");
        super.new(name);
    endfunction

endclass