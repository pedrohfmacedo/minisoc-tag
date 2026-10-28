class rst_agent extens uvm_agent;
    `uvm_component_utils(rst_agent)
    // has-a
    rst_cfg cfg;
    rst_driver rst_drv;

    // Construtor
    function new(string name = "rst_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Se a configuração do reset não for fornecida = fatal
        if (!uvm_config_db#(rst_cfg)::get(this, "", "cfg", cfg))
            `uvm_fatal("RST_CFG", "rst_cfg was not provided to rst_agent")
        // Se a configuração do reset for ativa, crie o driver
        if (cfg.is_active == UVM_ACTIVE) begin
            uvm_config_db#(rst_cfg)::set(this, "rst_drv", "cfg", cfg);
            rst_drv = rst_driver::type_id::create("rst_drv", this);
        end
        if
    endfunction

    // Run phase
    task run_phase(uvm_phase phase);
        if (cfg.is_active == UVM_ACTIVE) begin
            phase.raise_objection(this);
            rst_drv.start_reset();
            phase.drop_objection(this);
        end
    endtask 

endclass