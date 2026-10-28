class rst_cfg extends uvm_object;
    // Macros UVM
    `uvm_object_utils_begin(rst_cfg)

    // Configurações de reset
    virtual rst_if.driver vif; // Interface virtual do reset
    uvm_active_passive_enum is_active = UVM_ACTIVE;

    // Configurações de reset em picosegundos
    int unsigned time_low  = 1000;
    int unsigned time_high = 1000;
    int unsigned duration = 1000;
    // Macros UVM
        `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
        `uvm_field_int(time_low,  UVM_DEFAULT)
        `uvm_field_int(time_high, UVM_DEFAULT)
        `uvm_field_int(duration, UVM_DEFAULT)
    `uvm_object_utils_end

    // Construtor
    function new(string name = "rst_cfg");
        super.new(name);
    endfunction

endclass