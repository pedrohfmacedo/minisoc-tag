class mem_write_sequence extends mem_sequence_base;
  `uvm_object_utils(mem_write_sequence)

  function new(string name = "mem_write_sequence");
    super.new(name);
  endfunction

  task body();
    for (int unsigned addr = 0; addr < 1024; addr++)
      send(1'b1, addr[9:0], 32'hA5A5_0000 ^ addr);
  endtask
endclass
