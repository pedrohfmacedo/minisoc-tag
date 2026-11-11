class clk_monitor extends uvm_monitor;
  `uvm_component_utils(clk_monitor)

  //has-a
  virtual interface clk_if vif;
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

    if (!uvm_config_db#(virtual interface clk_if)::get(this, "", "vif", vif))
      `uvm_fatal("CLK_VIF", "clk_if was not provided to clk_monitor")
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

      // `uvm_info("CLK_MON",
      //   $sformatf("Observed period=%0d ps high=%0d ps low=%0d ps",
      //             item.period_ps, item.time_high_ps, item.time_low_ps),
      //             UVM_MEDIUM)
    end
  endtask

endclass
