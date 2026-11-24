class clk_standard_sequence extends clk_sequence;

  `uvm_object_utils(clk_standard_sequence)

  rand int unsigned cycles;

  constraint cycles_c {
    cycles inside {[1:100000]};
  }

  function new(string name = "clk_standard_sequence");
    super.new(name);
    cycles = 100;
  endfunction

  virtual task body();
    send_period(500, cycles);
  endtask

endclass