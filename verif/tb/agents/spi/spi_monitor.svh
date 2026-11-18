// class spi_monitor extends uvm_monitor;
//     `uvm_component_utils(spi_monitor)
    
//     // has-a
//     spi_cfg cfg;
//     virtual interface spi_if spi_vif;
//     uvm_analysis_port #(spi_item) ap;
    
//     // Constructor
//     function new(string name = "spi_monitor", uvm_component parent = null);
//         super.new(name, parent);
//         ap = new("mon_ap", this);
//     endfunction

//     // Build
//     function void build_phase(uvm_phase phase);
//         super.build_phase(phase);
//         if (!uvm_config_db#(spi_cfg)::get(this, "", "cfg", cfg))
//             `uvm_fatal("spi_CFG", "spi_cfg was not provided to spi_monitor")      
//         uvm_config_db#(virtual interface spi_if)::get(this, "", "vif", spi_vif);
//         if (spi_vif == null)
//             `uvm_fatal("spi_VIF", "spi_if was not provided to spi_monitor")
//     endfunction

//     // Run
//     task run_phase(uvm_phase phase);
//         spi_item item;      

//         forever begin
//             // Espera por uma borda de clock para capturar a transação
//             @(spi_vif.mon_cb);

//             item = spi_item::type_id::create("item");
//             item.period_ps = cfg.period_ps;
//             item.addr = spi_vif.mon_cb.spi_i_addr;
//             item.wr_en = spi_vif.mon_cb.spi_i_wr_en;

//             if (item.wr_en) begin
//                 // Write
//                 item.data = spi_vif.mon_cb.spi_i_data;
//                 `uvm_info("spi_MON",$sformatf( 
//                     "WRITE: addr=%0d data=%08h", item.addr, item.data), UVM_MEDIUM)
//             end
//             else begin
//                 item.data = spi_vif.mon_cb.spi_o_data;
//                 `uvm_info("spi_MON",$sformatf( 
//                     "READ: addr=%0d data=%08h", item.addr, item.data), UVM_MEDIUM)
//             end

//             ap.write(item);
//         end
//     endtask

// endclass

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
            // Espera por uma borda de clock para capturar a transação
            @(posedge spi_vif.spi_clk);

            item = spi_item::type_id::create("item");
            item.period_ps = cfg.period_ps;
            item.addr = spi_vif.spi_i_addr;
            item.wr_en = spi_vif.spi_i_wr_en;

            if (item.wr_en) begin
                // Write
                item.data = spi_vif.spi_i_data;
                `uvm_info("spi_MON",$sformatf( 
                    "WRITE: addr=%0d data=%08h", item.addr, item.data), UVM_MEDIUM)
            end
            else begin
                item.data = spi_vif.spi_o_data;
                `uvm_info("spi_MON",$sformatf( 
                    "READ: addr=%0d data=%08h", item.addr, item.data), UVM_MEDIUM)
            end

            ap.write(item);
        end
    endtask

endclass