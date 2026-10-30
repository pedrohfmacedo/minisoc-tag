
class rst_monitor extends uvm_monitor;

    `uvm_component_utils(rst_monitor)

    // Configuracao, interface e porta TLM
    rst_cfg cfg;
    virtual interface rst_if.monitor vif;
    uvm_analysis_port #(rst_item) ap;

    // Constructor
    function new(string name = "rst_monitor",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        ap = new("ap", this);

        if (!uvm_config_db#(rst_cfg)::get(this, "", "cfg", cfg))
            `uvm_fatal("RST_MON", "rst_cfg nao encontrada")

        vif = cfg.mon_vif;

        if (vif == null)
            `uvm_fatal("RST_MON", "rst_if nao configurada")
    endfunction

    // Run phase
    task run_phase(uvm_phase phase);

        rst_item item;

        wait (!$isunknown(vif.rst_n));
        item = rst_item::type_id::create("initial_reset");
        item.is_high = vif.rst_n;
        ap.write(item);

        `uvm_info("RST_MON",
            $sformatf("Reset inicial observado: rst_n = %0b",
                      item.is_high),
            UVM_MEDIUM)

        forever begin

            // Aguarda assert ou deassert do reset
            @(posedge vif.rst_n or negedge vif.rst_n);

            // Ignora estados desconhecidos
            if ($isunknown(vif.rst_n))
                continue;

            // Cria uma transacao observada
            item = rst_item::type_id::create("item");

            // Registra o estado observado
            item.is_high = vif.rst_n;

            // Publica a transacao
            ap.write(item);

            `uvm_info("RST_MON",
                $sformatf("Reset observado: rst_n = %0b",
                          item.is_high),
                UVM_MEDIUM)

        end

    endtask

endclass
