class clk_cfg extends uvm_object;
    // Macros UVM
    `uvm_object_utils_begin(clk_cfg)

    // Configurações de clock
    virtual clk_if.driver vif; // Interface virtual do clock
    uvm_active_passive_enum is_active = UVM_ACTIVE;

    // Configurações de clock em picosegundos
    int unsigned period    = 500;
    int unsigned time_low  = 250;
    int unsigned time_high = 250;
    // int unsigned jitter    = 0;
    bit enable = 1'b1; // geração do clock começa em high

    // Macros UVM
        `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
        `uvm_field_int(period,    UVM_DEFAULT)
        `uvm_field_int(time_low,  UVM_DEFAULT)
        `uvm_field_int(time_high, UVM_DEFAULT)
        `uvm_field_int(jitter,    UVM_DEFAULT)
        `uvm_field_int(enable,    UVM_DEFAULT)
    `uvm_object_utils_end

    // Construtor
    function new(string name = "clk_cfg");
        super.new(name);
    endfunction

endclass
