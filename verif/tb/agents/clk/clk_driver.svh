class clk_driver extends uvm_driver #(clk_item);
  `uvm_component_utils(clk_driver)

  //has-a
  clk_cfg cfg;
  virtual interface clk_if.driver vif;
  int unsigned time_low_ps;
  int unsigned time_high_ps;
  
  //constructor
  function new(string name = "clk_driver",uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Se a configuração do clock não for fornecida = fatal
    if (!uvm_config_db#(clk_cfg)::get(this, "", "cfg", cfg))
      `uvm_fatal("CLK_CFG", "clk_cfg was not provided to clk_driver")

    vif = cfg.drv_vif;

    // Se a interface virtual do clock não for fornecida = fatal
    if (vif == null)
      `uvm_fatal("CLK_VIF", "clk_if driver modport was not provided")

    // Se a cfg ofercer o clk inicial de periodo e duty_cycle fora do referencial = fatal
    if (cfg.min_period_ps < 2 || cfg.min_period_ps > cfg.period_ps || cfg.period_ps > cfg.max_period_ps || cfg.time_low_ps == 0 || cfg.time_high_ps == 0 ||
        cfg.time_low_ps + cfg.time_high_ps != cfg.period_ps)
      `uvm_fatal("CLK_TIMING", "Invalid initial clock period or duty cycle")
    time_low_ps = cfg.time_low_ps;
    time_high_ps = cfg.time_high_ps;
  endfunction

  // Run phase
  task run_phase(uvm_phase phase);
    vif.clk = 1'b0; // Iniciando o clock em valor ocnhecido, poderia ser um 
    fork
      generate_clock();
      process_items();
    join
  endtask

  task generate_clock();
    forever begin
      if (!cfg.enable) begin
        vif.clk = 1'b0;
        wait (cfg.enable);
      end
      #(time_low_ps);
      vif.clk = 1'b1;
      #(time_high_ps);
      vif.clk = 1'b0;
    end
  endtask

  task process_items();
    clk_item req;

    forever begin
      seq_item_port.get_next_item(req);

      if (req.period_ps < cfg.min_period_ps ||
          req.period_ps > cfg.max_period_ps ||
          req.time_low_ps == 0 ||
          req.time_high_ps == 0 ||
          req.time_low_ps + req.time_high_ps != req.period_ps) begin
        `uvm_fatal("CLK_ITEM", "Clock item has an invalid period or duty cycle")
      end

      @(negedge vif.clk);
      time_low_ps = req.time_low_ps;
      time_high_ps = req.time_high_ps;
      repeat (req.cycles) @(posedge vif.clk);
      @(negedge vif.clk);

      seq_item_port.item_done();
      `uvm_info("CLK_DRV",
        $sformatf("Applied %0d ps period for %0d cycles",
                  req.period_ps, req.cycles),
        UVM_MEDIUM)
    end
  endtask

endclass
