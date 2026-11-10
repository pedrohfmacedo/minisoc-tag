class mem_driver extends uvm_driver #(mem_item);
  `uvm_component_utils(mem_driver)

 //has-a
  mem_cfg cfg;
  virtual interface mem_if vif;

  // Constructor
  function new(string name = "mem_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Se a configuração  não for fornecida = fatal
    if (!uvm_config_db#(mem_cfg)::get(this, "", "cfg", cfg))
      `uvm_fatal("MEM_CFG", "mem_cfg was not provided to mem_driver")      

    uvm_config_db#(virtual interface mem_if)::get(this, "", "vif", vif);
    if (vif == null)
      `uvm_fatal("MEM_VIF", "mem_if was not provided to mem_driver")
  endfunction

  time current_period;

  // Run 
  task run_phase(uvm_phase phase);

    current_period = cfg.period_ps;
    vif.mem_clk = 1'b0;
    vif.drv_cb.mem_i_data <= '0;
    vif.drv_cb.mem_i_addr <= '0;
    vif.drv_cb.mem_i_wr_en <= 1'b0;

    fork
      generate_clock();
      drive_items();
    join

  endtask

  task generate_clock();
    vif.mem_clk = 1'b0;
    forever begin
        #(current_period / 2);
        vif.mem_clk = ~vif.mem_clk;
    end
  endtask

  task drive_items();
    mem_item req;

    forever begin
      seq_item_port.get_next_item(req);

      if (req == null)
        `uvm_fatal("MEM_DRV", "Received null mem_item from sequencer")

      if (req.period_ps > 0)
        current_period = req.period_ps;
      else
        current_period = cfg.period_ps;

      @(vif.drv_cb);
      vif.drv_cb.mem_i_data <= req.data;
      vif.drv_cb.mem_i_addr <= req.addr;
      vif.drv_cb.mem_i_wr_en <= req.wr_en;
      @(posedge vif.mem_clk);

      `uvm_info("MEM_DRV", $sformatf(
        "Applied mem_item: data=0x%0h, addr=0x%0h, wr_en=%0b", req.data, req.addr, req.wr_en), UVM_MEDIUM)

      seq_item_port.item_done();
    end
  endtask

endclass
