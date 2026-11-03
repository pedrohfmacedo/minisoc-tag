class minisoc_env extends uvm_env;

  `uvm_component_utils(minisoc_env)

  minisoc_env_cfg cfg;
  clk_agent       clk_agt;
  rst_agent       rst_agt;
  coverage_clk    clk_cov;

  function new(string name = "minisoc_env",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(minisoc_env_cfg)::get(this, "", "cfg", cfg))
      `uvm_fatal("ENV_CFG", "minisoc_env_cfg was not provided to minisoc_env")

    uvm_config_db#(clk_cfg)::set(this, "clk_agt", "cfg", cfg.clk_cfg_h);
    uvm_config_db#(rst_cfg)::set(this, "rst_agt", "cfg", cfg.rst_cfg_h);

    clk_agt = clk_agent::type_id::create("clk_agt", this);
    rst_agt = rst_agent::type_id::create("rst_agt", this);
    clk_cov = coverage_clk::type_id::create("clk_cov", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    clk_agt.clk_mon.ap.connect(clk_cov.analysis_export);
  endfunction

endclass
