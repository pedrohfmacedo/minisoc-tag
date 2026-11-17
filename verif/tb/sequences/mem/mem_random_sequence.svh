class mem_random_sequence extends mem_sequence_base;
  `uvm_object_utils(mem_random_sequence)

  int unsigned num_pairs = 100;

  function new(string name = "mem_random_sequence");
    super.new(name);
  endfunction

  task body();
    bit [9:0] addr;
    bit [31:0] data;

    repeat (num_pairs) begin
      addr = $urandom_range(0, 1023);
      data = $urandom;
      send(1'b1, addr, data);
      send(1'b0, addr, data);
    end
  endtask
endclass
