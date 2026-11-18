
class spi_driver extends uvm_driver #(spi_item);
  `uvm_component_utils(spi_driver)

  // has-a
  spi_cfg cfg;
  virtual interface spi_if vif;

  // Constructor
  function new(string name = "spi_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Se a configuração não for fornecida = fatal
    if (!uvm_config_db#(spi_cfg)::get(this, "", "cfg", cfg))
      `uvm_fatal("spi_CFG", "spi_cfg was not provided to spi_driver")

    uvm_config_db#(virtual spi_if)::get(this, "", "vif", vif);
    if (vif == null)
      `uvm_fatal("spi_VIF", "spi_if was not provided to spi_driver")
  endfunction

  time current_period;

  // Run
  task run_phase(uvm_phase phase);
    spi_item req;

    current_period = cfg.period_ps;
    vif.spi_sclk  = 1'b0;

    forever begin

    end
  endtask

endclass
