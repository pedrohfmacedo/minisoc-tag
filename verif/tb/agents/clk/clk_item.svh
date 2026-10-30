class clk_item extends uvm_sequence_item;

  // Caracateristicas do clk
  rand int unsigned period_ps;
  rand int unsigned time_low_ps;
  rand int unsigned time_high_ps;
  rand int unsigned cycles; //duracao

  // Constraints *
  constraint clk_timing_c {
    period_ps inside {[2:100000]};
    time_low_ps inside {[1:99999]};
    time_high_ps inside {[1:99999]};
    period_ps == time_low_ps + time_high_ps;
    cycles inside {[1:100000]};
  }

// Macro + fields
  `uvm_object_utils_begin(clk_item)
    `uvm_field_int(period_ps, UVM_ALL_ON)
    `uvm_field_int(time_low_ps, UVM_ALL_ON)
    `uvm_field_int(time_high_ps, UVM_ALL_ON)
    `uvm_field_int(cycles, UVM_ALL_ON)
  `uvm_object_utils_end

// Constructor
  function new(string name = "clk_item");
    super.new(name);
  endfunction

endclass
