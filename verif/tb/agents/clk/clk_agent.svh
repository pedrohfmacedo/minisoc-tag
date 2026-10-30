class clk_agent extends uvm_agent;
  `uvm_component_utils(clk_agent)

  // has-a
  clk_cfg cfg;
  clk_driver clk_drv;
  clk_monitor clk_mon;
  clk_sequencer clk_seqr;

  // Constructor
  function new(string name = "clk_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Se a configuração do clock não for fornecida = fatal
    if (!uvm_config_db#(clk_cfg)::get(this, "", "cfg", cfg))
      `uvm_fatal("CLK_CFG", "clk_cfg was not provided to clk_agent")      
    uvm_config_db#(clk_cfg)::set(this, "clk_mon", "cfg", cfg);
    clk_mon = clk_monitor::type_id::create("clk_mon", this);

    // Se configurado na cfg como ativo
    if (cfg.is_active == UVM_ACTIVE) begin
      uvm_config_db#(clk_cfg)::set(this, "clk_drv", "cfg", cfg);
      clk_drv = clk_driver::type_id::create("clk_drv", this);
      clk_seqr = clk_sequencer::type_id::create("clk_seqr", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (cfg.is_active == UVM_ACTIVE)
      clk_drv.seq_item_port.connect(clk_seqr.seq_item_export);
  endfunction

endclass
