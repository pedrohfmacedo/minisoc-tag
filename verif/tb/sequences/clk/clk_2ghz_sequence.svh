class clk_2ghz_sequence extends clk_sequence;

  `uvm_object_utils(clk_2ghz_sequence)

  constraint clk_2ghz_c {
    mode == clk_sequence::CLK_FIXED_THEN_CHANGE;
    initial_period_ps == 500;
    changed_period_ps == 500;
    initial_cycles == 10;
    changed_cycles == 10;
  }

  function new(string name = "clk_2ghz_sequence");
    super.new(name);
  endfunction

endclass