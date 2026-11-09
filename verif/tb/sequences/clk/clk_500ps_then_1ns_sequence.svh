class clk_500ps_then_1ns_sequence extends clk_sequence;

  `uvm_object_utils(clk_500ps_then_1ns_sequence)

  constraint clk_500ps_then_1ns_c {
    mode == clk_sequence::CLK_FIXED_THEN_CHANGE;
    initial_period_ps == 500;
    changed_period_ps == 1000;
    initial_cycles == 10;
    changed_cycles == 10;
  }

  function new(string name = "clk_500ps_then_1ns_sequence");
    super.new(name);
  endfunction

endclass
