class clk_random_constrained_sequence extends clk_sequence;

  `uvm_object_utils(clk_random_constrained_sequence)

  // Constrained-random clock generator aligned with the legal/random space
  // described in the CI-Expert Fase 2 plan: random periods and cycle counts,
  // while staying inside the valid timing envelope already accepted by clk_sequence.
  constraint clk_random_constrained_c {
    mode == clk_sequence::CLK_FULL_RANDOM;
    segment_count inside {[1:25]};
    min_period_ps inside {[100:5000]};
    max_period_ps inside {[min_period_ps:10000]};
    min_cycles inside {[1:50]};
    max_cycles inside {[min_cycles:100]};
  }

  function new(string name = "clk_random_constrained_sequence");
    super.new(name);
  endfunction

endclass
