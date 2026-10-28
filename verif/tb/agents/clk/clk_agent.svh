class clk_agent extends uvm_agent;
    // Macros UVM
    `uvm_component_utils(clk_agent)
    // has-a
    clk_cfg cfg;
    clk_driver clk_drv;
    // Construtor
    function new(string name = "clk_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Se a configuração do clock não for fornecida = fatal
        if (!uvm_config_db#(clk_cfg)::get(this, "", "cfg", cfg))
            `uvm_fatal("CLK_CFG", "clk_cfg was not provided to clk_agent")
        // Se a configuração do clock for ativa, crie o driver
        if (cfg.is_active == UVM_ACTIVE) begin
            uvm_config_db#(clk_cfg)::set(this, "clk_drv", "cfg", cfg);
            clk_drv = clk_driver::type_id::create("clk_drv", this);
        end
    endfunction

endclass