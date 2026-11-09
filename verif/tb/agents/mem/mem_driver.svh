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

    uvm_config_db#(virtual interface mem_if.driver)::get(this, "", "vif", vif);
    if (vif == null)
      `uvm_fatal("MEM_VIF", "mem_if was not provided to mem_driver")
  endfunction

  // Run 
  task run_phase(uvm_phase phase);
    mem_item req;
    forever begin
      seq_item_port.get_next_item(req);
      vif.mem_i_data <= req.data;
      vif.mem_i_addr <= req.addr;
      vif.mem_i_wr_en <= req.wr_en;
      @(posedge vif.mem_clk);
      seq_item_port.item_done();
    end
  endtask
  endclass