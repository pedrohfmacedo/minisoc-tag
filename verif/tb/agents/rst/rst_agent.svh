class rst_agent extends uvm_agent;
    `uvm_component_utils(rst_agent)
    // has-a
    rst_cfg cfg;
    rst_driver rst_drv;
    rst_monitor rst_mon;
    rst_sequencer rst_seq;

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
        uvm_config_db#(rst_cfg)::set(this, "rst_mon", "cfg", cfg);
        rst_mon = rst_monitor::type_id::create("rst_mon", this);

        // No agente ativo, crie o driver e o sequencer.
        if (cfg.is_active == UVM_ACTIVE) begin
            uvm_config_db#(rst_cfg)::set(this, "rst_drv", "cfg", cfg);
            rst_drv = rst_driver::type_id::create("rst_drv", this);
            rst_seq = rst_sequencer::type_id::create("rst_seq", this);
        end
    endfunction

    // Connect Phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (cfg.is_active == UVM_ACTIVE)
            rst_drv.seq_item_port.connect(rst_seq.seq_item_export);
    endfunction


endclass
