class spi_monitor extends uvm_monitor;
    `uvm_component_utils(spi_monitor)
    
    // has-a
    spi_cfg cfg;
    virtual interface spi_if spi_vif;
    uvm_analysis_port #(spi_item) ap;
    
    // Constructor
    function new(string name = "spi_monitor", uvm_component parent = null);
        super.new(name, parent);
        ap = new("mon_ap", this);
    endfunction

    // Build
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(spi_cfg)::get(this, "", "cfg", cfg))
            `uvm_fatal("spi_CFG", "spi_cfg was not provided to spi_monitor")      
        uvm_config_db#(virtual interface spi_if)::get(this, "", "vif", spi_vif);
        if (spi_vif == null)
            `uvm_fatal("spi_VIF", "spi_if was not provided to spi_monitor")
    endfunction

    // Run
    task run_phase(uvm_phase phase);
        spi_item item;      

        forever begin
            
                item.data = spi_vif.spi_o_data;
                `uvm_info("",$sformatf( a), UVM_MEDIUM)

            ap.write(item);
        end
    endtask

endclass