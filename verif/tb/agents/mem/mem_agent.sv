class mem_agent extends uvm_agent;
  `uvm_component_utils(mem_agent)

  // has-a
  mem_cfg cfg;
  mem_driver mem_drv;
  mem_monitor mem_mon;
  mem_sequencer mem_seqr;
  virtual interface mem_if mem_vif;
  mem_coverage mem_cov;

  // Constructor
  function new(string name = "mem_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Se a configuração  não for fornecida = fatal
    if (!uvm_config_db#(mem_cfg)::get(this, "", "cfg", cfg))
      `uvm_fatal("MEM_CFG", "mem_cfg was not provided to mem_agent")      

    mem_vif = cfg.vif;
    if (mem_vif == null)
      `uvm_fatal("MEM_VIF", "mem_if was not provided in mem_cfg")

    uvm_config_db#(virtual interface mem_if)::set(this, "mem_mon", "vif", mem_vif); //set
    mem_mon = mem_monitor::type_id::create("mem_mon", this);
    mem_cov = mem_coverage::type_id::create("mem_cov", this);
    // Se configurado na cfg como ativo
    if (cfg.is_active == UVM_ACTIVE) begin
      uvm_config_db#(mem_cfg)::set(this, "mem_drv", "cfg", cfg);
      uvm_config_db#(virtual interface mem_if.driver)::set(
        this, "mem_drv", "vif", mem_vif
      );
      mem_drv = mem_driver::type_id::create("mem_drv", this);
      mem_seqr = mem_sequencer::type_id::create("mem_seqr", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (cfg.is_active == UVM_ACTIVE) begin
      mem_drv.seq_item_port.connect(mem_seqr.seq_item_export);
    end
    mem_mon.ap.connect(mem_cov.analysis_export);
  endfunction

endclass
