
class rst_driver extends uvm_driver #(rst_item);

    `uvm_component_utils(rst_driver)

    // Configuracao e interface virtual
    virtual interface rst_if.driver vif;
    rst_cfg cfg;

    // Constructor
    function new(string name = "rst_driver",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(rst_cfg)::get(this, "", "cfg", cfg))
            `uvm_fatal("RST_DRV", "rst_cfg nao encontrada")

        vif = cfg.drv_vif;

        if (vif == null)
            `uvm_fatal("RST_DRV", "rst_if nao configurada")
    endfunction

    // Run phase
    task run_phase(uvm_phase phase);

        // Inicializa o reset em nivel ativo
        vif.rst_n = 1'b0;

        forever begin
            seq_item_port.get_next_item(req);

            // Modo assincrono: espera em ps
            if (req.sync_mode == rst_item::RST_ASYNC) begin
                #(req.duration * 1ps);
            end

            // Modo sincrono: espera por bordas do clock
            else begin
                if (req.edge_sel == rst_item::RST_POSEDGE)
                    repeat (req.cycles) @(posedge vif.clk);
                else
                    repeat (req.cycles) @(negedge vif.clk);
            end

            // Aplica o novo estado do reset
            vif.rst_n <= req.is_high;

            // Finaliza a transacao
            seq_item_port.item_done();
        end

    endtask

endclass
