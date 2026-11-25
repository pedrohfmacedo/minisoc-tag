class spi_agent extends uvm_agent;
  `uvm_component_utils(spi_agent)

  typedef spi_sequencer #(
    .SPI_PARAMS(spi_params_pkg::SPI_PARAMS),
    .seq_item_t(spi_item)
  )spi_sequencer_t;

  // has-a
  spi_cfg cfg;
  spi_driver spi_drv;
  spi_monitor spi_mon;
  spi_sequencer_t spi_seqr;
  virtual interface spi_if spi_vif;
  spi_coverage spi_cov;

  // Constructor
  function new(string name = "spi_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Se a configuração  não for fornecida = fatal
    if (!uvm_config_db#(spi_cfg)::get(this, "", "cfg", cfg))
      `uvm_fatal("spi_CFG", "spi_cfg was not provided to spi_agent")      

    spi_vif = cfg.vif;
    if (spi_vif == null)
      `uvm_fatal("spi_VIF", "spi_if was not provided in spi_cfg")

    uvm_config_db#(spi_cfg)::set(this, "spi_mon", "cfg", cfg);
    uvm_config_db#(virtual interface spi_if)::set(this, "spi_mon", "vif", spi_vif); //set
    spi_mon = spi_monitor::type_id::create("spi_mon", this);
    spi_cov = spi_coverage::type_id::create("spi_cov", this);
    // Se configurado na cfg como ativo
    if (cfg.is_active == UVM_ACTIVE) begin
      uvm_config_db#(spi_cfg)::set(this, "spi_drv", "cfg", cfg);
      uvm_config_db#(virtual interface spi_if)::set(
        this, "spi_drv", "vif", spi_vif
      );
      spi_drv = spi_driver::type_id::create("spi_drv", this);
      // spi_seqr = spi_sequencer::type_id::create("spi_seqr", this);
      spi_seqr = spi_sequencer_t::type_id::create("spi_seqr", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (cfg.is_active == UVM_ACTIVE) begin
      spi_drv.seq_item_port.connect(spi_seqr.seq_item_export);
    end
    spi_mon.ap.connect(spi_cov.analysis_export);
  endfunction

endclass
