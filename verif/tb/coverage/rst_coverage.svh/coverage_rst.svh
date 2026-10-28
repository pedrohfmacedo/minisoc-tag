class rst_coverage extends uvm_subscriber #(rst_item);

  `uvm_component_utils(rst_coverage)

  covergroup rst_cg with function sample(rst_item item);
    cp_rst_n: coverpoint item.is_high {
      bins asserted   = {0}; // rst_n = 0
      bins deasserted = {1}; // rst_n = 1
    }
  endgroup

  function new(string name = "rst_coverage",
               uvm_component parent = null);
    super.new(name, parent);
    rst_cg = new();
  endfunction

  function void write(rst_item t);
    rst_cg.sample(t);
  endfunction

endclass
