class clk_driver extends uvm_component;
	`uvm_component_utils(clk_driver)

    // has-a
	clk_cfg cfg;
	virtual clk_if.driver vif;

	function new(string name = "clk_driver", uvm_component parent = null);
		super.new(name, parent);
	endfunction

    // Obs: questao do jitter adiciona posteriomente.
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

        // Se a configuração do clock não for fornecida = fatal
		if (!uvm_config_db#(clk_cfg)::get(this, "", "cfg", cfg))
			`uvm_fatal("CLK_CFG", "clk_cfg was not provided to clk_driver")

        // Se a interface virtual do clock não for fornecida = fatal
		if (cfg.vif == null)
			`uvm_fatal("CLK_VIF", "clk_if was not provided in clk_cfg")
		vif = cfg.vif;

        // Se o período do clock for inválido = fatal, ou seja  time_low + time_high != period ou time_low == 0 ou time_high == 0
		if (cfg.time_low == 0 || cfg.time_high == 0 || cfg.time_low + cfg.time_high != cfg.period)
			`uvm_fatal("CLK_TIMING", "period must equal non-zero time_low + time_high")
	endfunction

    task run_phase(uvm_phase phase);
        vif.clk = 1'b0; // Iniciando o clk em low

        forever begin
            // Se o clock estiver desabilitado, aguarde até que seja habilitado    
            if (!cfg.enable) begin
                vif.clk = 1'b0;
                wait(cfg.enable);
            end

            // Gerando o clock confome cfg.
            #(cfg.time_low * 1ps);
            vif.clk = 1'b1;

            #(cfg.time_high * 1ps);
            vif.clk = 1'b0;
        end
    endtask

endclass
