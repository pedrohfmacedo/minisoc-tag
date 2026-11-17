class mem_read_sequence extends mem_sequence_base;
  `uvm_object_utils(mem_read_sequence)

  function new(string name = "mem_read_sequence");
    super.new(name);
  endfunction

  task body();
    for (int unsigned addr = 0; addr < 1024; addr++)
      send(1'b0, addr[9:0], '0);
  endtask
endclass
