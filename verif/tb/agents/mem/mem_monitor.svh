// class mem_monitor extends uvm_monitor;
//     `uvm_component_utils(mem_monitor)
    
//     // has-a
//     mem_cfg cfg;
//     virtual interface mem_if mem_vif;
//     uvm_analysis_port #(mem_item) ap;
    
//     // Constructor
//     function new(string name = "mem_monitor", uvm_component parent = null);
//         super.new(name, parent);
//         ap = new("mon_ap", this);
//     endfunction

//     // Build
//     function void build_phase(uvm_phase phase);
//         super.build_phase(phase);
//         if (!uvm_config_db#(mem_cfg)::get(this, "", "cfg", cfg))
//             `uvm_fatal("MEM_CFG", "mem_cfg was not provided to mem_monitor")      
//         uvm_config_db#(virtual interface mem_if)::get(this, "", "vif", mem_vif);
//         if (mem_vif == null)
//             `uvm_fatal("MEM_VIF", "mem_if was not provided to mem_monitor")
//     endfunction

//     // Run
//     task run_phase(uvm_phase phase);
//         mem_item item;      

//         forever begin
//             // Espera por uma borda de clock para capturar a transação
//             @(mem_vif.mon_cb);

//             item = mem_item::type_id::create("item");
//             item.period_ps = cfg.period_ps;
//             item.addr = mem_vif.mon_cb.mem_i_addr;
//             item.wr_en = mem_vif.mon_cb.mem_i_wr_en;

//             if (item.wr_en) begin
//                 // Write
//                 item.data = mem_vif.mon_cb.mem_i_data;
//                 `uvm_info("MEM_MON",$sformatf( 
//                     "WRITE: addr=%0d data=%08h", item.addr, item.data), UVM_MEDIUM)
//             end
//             else begin
//                 item.data = mem_vif.mon_cb.mem_o_data;
//                 `uvm_info("MEM_MON",$sformatf( 
//                     "READ: addr=%0d data=%08h", item.addr, item.data), UVM_MEDIUM)
//             end

//             ap.write(item);
//         end
//     endtask

// endclass

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

        forever begin
            // Espera por uma borda de clock para capturar a transação
            @(posedge mem_vif.mem_clk);

            item = mem_item::type_id::create("item");
            item.period_ps = cfg.period_ps;
            item.addr = mem_vif.mem_i_addr;
            item.wr_en = mem_vif.mem_i_wr_en;

            if (item.wr_en) begin
                // Write
                item.data = mem_vif.mem_i_data;
                `uvm_info("MEM_MON",$sformatf( 
                    "WRITE: addr=%0d data=%08h", item.addr, item.data), UVM_MEDIUM)
            end
            else begin
                item.data = mem_vif.mem_o_data;
                `uvm_info("MEM_MON",$sformatf( 
                    "READ: addr=%0d data=%08h", item.addr, item.data), UVM_MEDIUM)
            end

            ap.write(item);
        end
    endtask

endclass