class mem_monitor extends uvm_monitor;
    `uvm_component_utils(mem_monitor)
    
    // has-a
    mem_cfg cfg;
    virtual interface mem_if mem_vif;
    uvm_analysis_port #(mem_item) ap;
    
    // Constructor
    function new(string name = "mem_monitor", uvm_component parent = null);
        super.new(name, parent);
        ap = new("mon_ap", this);
    endfunction

    // Build
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(mem_cfg)::get(this, "", "cfg", cfg))
            `uvm_fatal("MEM_CFG", "mem_cfg was not provided to mem_monitor")      
        uvm_config_db#(virtual interface mem_if)::get(this, "", "vif", mem_vif);
        if (mem_vif == null)
            `uvm_fatal("MEM_VIF", "mem_if was not provided to mem_monitor")
    endfunction

    // Run
    task run_phase(uvm_phase phase);
        mem_item item;      
    endtask

endclass