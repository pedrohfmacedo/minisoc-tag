class minisoc_test_base extends uvm_test;

  `uvm_component_utils(minisoc_test_base)

  minisoc_env     env;
  minisoc_env_cfg env_cfg;

  virtual interface clk_if.driver  clk_vif;
  virtual interface clk_if.monitor clk_mon_vif;
  virtual interface rst_if.driver  rst_drv_vif;
  virtual interface rst_if.monitor rst_mon_vif;

  function new(string name = "minisoc_test_base",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual interface clk_if.driver)::get(this, "", "clk_vif", clk_vif))
      `uvm_fatal("TEST_VIF", "clk_vif was not provided by top_tb")

    if (!uvm_config_db#(virtual interface clk_if.monitor)::get(this, "", "clk_mon_vif", clk_mon_vif))
      `uvm_fatal("TEST_VIF", "clk_mon_vif was not provided by top_tb")

    if (!uvm_config_db#(virtual interface rst_if.driver)::get(this, "", "rst_drv_vif", rst_drv_vif))
      `uvm_fatal("TEST_VIF", "rst_drv_vif was not provided by top_tb")

    if (!uvm_config_db#(virtual interface rst_if.monitor)::get(this, "", "rst_mon_vif", rst_mon_vif))
      `uvm_fatal("TEST_VIF", "rst_mon_vif was not provided by top_tb")

    env_cfg = minisoc_env_cfg::type_id::create("env_cfg");
    env_cfg.clk_cfg_h.drv_vif = clk_vif;
    env_cfg.clk_cfg_h.mon_vif = clk_mon_vif;
    env_cfg.rst_cfg_h.drv_vif = rst_drv_vif;
    env_cfg.rst_cfg_h.mon_vif = rst_mon_vif;

    uvm_config_db#(minisoc_env_cfg)::set(this, "env", "cfg", env_cfg);
    env = minisoc_env::type_id::create("env", this);
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction

endclass
