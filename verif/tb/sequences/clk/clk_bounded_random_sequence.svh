class clk_bounded_random_sequence extends clk_sequence;

  `uvm_object_utils(clk_bounded_random_sequence)

  constraint clk_bounded_random_c {
    mode == clk_sequence::CLK_FULL_RANDOM;
    segment_count == 10;
    min_period_ps == 100;
    max_period_ps == 5000;
    min_cycles == 1;
    max_cycles == 20;
  }

  function new(string name = "clk_bounded_random_sequence");
    super.new(name);
  endfunction

endclass
