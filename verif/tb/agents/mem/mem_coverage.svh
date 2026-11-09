class mem_coverage extends uvm_subscriber #(mem_item);

  `uvm_component_utils(mem_coverage)

// covergroups....
covergroup mem_cg with function sample(mem_item item); 
    option.per_instance = 1; 
    cp_operation: coverpoint item.wr_en {
      bins write = {1};
      bins read = {0};
    }
endgroup

covergroup addr_cg with function sample(mem_item item);
    option.per_instance = 1;
    cp_addr: coverpoint item.addr {
        bins addr_first = {10'd0};
        bins addr_low   = {[10'd1:10'd255]};
        bins addr_mid1  = {[10'd256:10'd511]};
        bins addr_mid2  = {[10'd512:10'd767]};
        bins addr_high  = {[10'd768:10'd1022]};
        bins addr_last  = {10'd1023};
    }
endgroup

covergroup data_cg with function sample(mem_item item);
    option.per_instance = 1;
    cp_data: coverpoint item.data {
        bins data_first = {32'd0};
        bins data_low   = {[32'd1:32'd1073741823]};
        bins data_mid1  = {[32'd1073741824:32'd2147483647]};
        bins data_mid2  = {[32'd2147483648:32'd3221225471]};
        bins data_high  = {[32'd3221225472:32'd4294967294]};
        bins data_last  = {32'd4294967295};
    }
endgroup

covergroup period_cg with function sample(mem_item item);
    cp_period: coverpoint item.period_ps {
      bins max = {5000};
    }
  endgroup
  
  function new(string name = "mem_coverage",
               uvm_component parent = null);
    super.new(name, parent);
    mem_cg = new();
  endfunction

  function void write(mem_item t);
    mem_cg.sample(t);
  endfunction

endclass
