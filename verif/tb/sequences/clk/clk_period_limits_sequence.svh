class clk_period_limits_sequence extends clk_sequence;

  `uvm_object_utils(clk_period_limits_sequence)

  constraint clk_period_limits_c {
    mode == clk_sequence::CLK_FIXED_THEN_CHANGE;
    initial_period_ps == 100;
    changed_period_ps == 10000;
    initial_cycles == 1;
    changed_cycles == 1;
  }

  function new(string name = "clk_period_limits_sequence");
    super.new(name);
  endfunction

endclass
