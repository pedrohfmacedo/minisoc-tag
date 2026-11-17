class mem_mix_sequence extends mem_sequence_base;
  `uvm_object_utils(mem_mix_sequence)

  function new(string name = "mem_mix_sequence");
    super.new(name);
  endfunction

  task body();
    send(1'b1, 10'd3, 32'h1357_9BDF);
    send(1'b0, 10'd3, 32'h1357_9BDF);
    send(1'b1, 10'd1022, 32'h2468_ACE0);
    send(1'b0, 10'd1022, 32'h2468_ACE0);
  endtask
endclass
