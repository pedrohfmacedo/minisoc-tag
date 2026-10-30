class clk_monitor extends uvm_monitor;
  `uvm_component_utils(clk_monitor)

  //has-a
  clk_cfg cfg;
  virtual interface clk_if.monitor vif;
  uvm_analysis_port #(clk_item) ap;

  // Constructor
  function new(string name = "clk_monitor",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Create analysis port
    ap = new("ap", this);

    // Se a configuração do clock não for fornecida = fatal
    if (!uvm_config_db#(clk_cfg)::get(this, "", "cfg", cfg))
      `uvm_fatal("CLK_CFG", "clk_cfg was not provided to clk_monitor")
    vif = cfg.mon_vif;

    // Se a interface do monitor não for fornecida = fatal
    if (vif == null)
      `uvm_fatal("CLK_VIF", "clk_if monitor modport was not provided")
  endfunction

  task run_phase(uvm_phase phase);
    time rise_time;
    time fall_time;
    time next_rise_time;
    clk_item item;

    forever begin
      @(posedge vif.clk);
      rise_time = $time;
      @(negedge vif.clk);
      fall_time = $time;
      @(posedge vif.clk);
      next_rise_time = $time;

      item = clk_item::type_id::create("item");
      item.period_ps = next_rise_time - rise_time;
      item.time_high_ps = fall_time - rise_time;
      item.time_low_ps = next_rise_time - fall_time;
      item.cycles = 1;
      ap.write(item);

      `uvm_info("CLK_MON",
        $sformatf("Observed period=%0d ps high=%0d ps low=%0d ps",
                  item.period_ps, item.time_high_ps, item.time_low_ps),
                  UVM_MEDIUM)
    end
  endtask

endclass
