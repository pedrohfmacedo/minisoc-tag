class minisoc_env_cfg extends uvm_object;

  `uvm_object_utils(minisoc_env_cfg)

  // Configuracoes estaticas dos agentes presentes no ambiente.
  clk_cfg clk_cfg_h;
  rst_cfg rst_cfg_h;

  function new(string name = "minisoc_env_cfg");
    super.new(name);
    clk_cfg_h = clk_cfg::type_id::create("clk_cfg_h");
    rst_cfg_h = rst_cfg::type_id::create("rst_cfg_h");
  endfunction

endclass
