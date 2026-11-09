class clk_coverage extends uvm_subscriber #(clk_item);

  `uvm_component_utils(clk_coverage)

  covergroup clk_cg with function sample(clk_item item);
    cp_period: coverpoint item.period_ps {
      //bins minimum = {100};
      bins nominal = {500};
      //bins maximum = {10000};
    }
  endgroup

  function new(string name = "clk_coverage",
               uvm_component parent = null);
    super.new(name, parent);
    clk_cg = new();
  endfunction

  function void write(clk_item t);
    clk_cg.sample(t);
  endfunction

endclass
