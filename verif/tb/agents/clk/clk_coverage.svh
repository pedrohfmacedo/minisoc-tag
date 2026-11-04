class coverage_clk extends uvm_subscriber #(clk_item);

  `uvm_component_utils(coverage_clk)

  covergroup clk_cg with function sample(clk_item item);
    cp_period: coverpoint item.period_ps {
      //bins minimum = {100};
      bins nominal = {500};
      //bins maximum = {10000};
    }
  endgroup

  function new(string name = "coverage_clk",
               uvm_component parent = null);
    super.new(name, parent);
    clk_cg = new();
  endfunction

  function void write(clk_item t);
    clk_cg.sample(t);
  endfunction

endclass
