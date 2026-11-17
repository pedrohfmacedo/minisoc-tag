class mem_corners_sequence extends mem_sequence_base;
  `uvm_object_utils(mem_corners_sequence)

  function new(string name = "mem_corners_sequence");
    super.new(name);
  endfunction

  task body();
    bit [9:0] corner_addrs[7] = '{10'd0, 10'd1, 10'd2, 10'd3,
                                 10'd1021, 10'd1022, 10'd1023};

    foreach (corner_addrs[i])
      send(1'b1, corner_addrs[i], 32'hC0DE_0000 | corner_addrs[i]);

    foreach (corner_addrs[i])
      send(1'b0, corner_addrs[i], '0);
  endtask
endclass
