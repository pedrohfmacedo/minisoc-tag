class clk_sequence extends uvm_sequence #(clk_item);

  typedef enum bit [1:0] {
    CLK_FIXED_THEN_CHANGE,
    CLK_RANDOM_TWO_OPTIONS,
    CLK_FULL_RANDOM
  } clk_sequence_mode_e;

  `uvm_object_utils(clk_sequence)

  rand clk_sequence_mode_e mode;
  rand int unsigned initial_period_ps;
  rand int unsigned changed_period_ps;
  rand int unsigned initial_cycles;
  rand int unsigned changed_cycles;
  rand int unsigned segment_count;
  rand int unsigned min_period_ps;
  rand int unsigned max_period_ps;
  rand int unsigned min_cycles;
  rand int unsigned max_cycles;

  constraint clk_sequence_c {
    initial_period_ps inside {[2:100000]};
    changed_period_ps inside {[2:100000]};
    initial_cycles inside {[1:100000]};
    changed_cycles inside {[1:100000]};
    segment_count inside {[1:100]};
    min_period_ps inside {[2:100000]};
    max_period_ps inside {[min_period_ps:100000]};
    min_cycles inside {[1:100000]};
    max_cycles inside {[min_cycles:100000]};
  }

  function new(string name = "clk_sequence");
    super.new(name);
    mode = CLK_FIXED_THEN_CHANGE;
    initial_period_ps = 500;
    changed_period_ps = 1000;
    initial_cycles = 10;
    changed_cycles = 10;
    segment_count = 10;
    min_period_ps = 100;
    max_period_ps = 10000;
    min_cycles = 1;
    max_cycles = 100;
  endfunction

// Tarefa para enviar um segmento de clock com um período e um número de ciclos específicos
  task send_period(int unsigned period_ps, int unsigned cycles);
    clk_item item;
    if (period_ps < 2)
      `uvm_fatal("CLK_SEQ", "Clock period must be at least 2 ps")
    item = clk_item::type_id::create("item");
    start_item(item);
    item.period_ps = period_ps;
    item.time_low_ps = period_ps / 2;
    item.time_high_ps = period_ps - item.time_low_ps;
    item.cycles = cycles;
    finish_item(item);
  endtask

// Tarefa para enviar um segmento de clock com um período e um número de ciclos aleatórios, dentro de limites especificados
  task send_random_period();
    clk_item item;
    item = clk_item::type_id::create("item");
    start_item(item);
    if (!item.randomize() with {
      period_ps inside {[min_period_ps:max_period_ps]};
      time_low_ps inside {[1:period_ps - 1]};
      time_high_ps == period_ps - time_low_ps;
      cycles inside {[min_cycles:max_cycles]};
    })
      `uvm_fatal("CLK_SEQ", "Failed to randomize a clock segment")
    finish_item(item);
  endtask

  // Main task 
  task body();
    int unsigned period_ps;
    int unsigned cycles;
    // Determine o modo de sequência de clock
    case (mode)
      CLK_FIXED_THEN_CHANGE: begin
        send_period(initial_period_ps, initial_cycles);
        send_period(changed_period_ps, changed_cycles);
      end
      // Randomly select between two clock options
      CLK_RANDOM_TWO_OPTIONS: begin
        for (int unsigned i = 0; i < segment_count; i++) begin
          // Randomly select one of the two clock options
          if (!std::randomize(period_ps) with {
            period_ps == initial_period_ps ||
            period_ps == changed_period_ps;
          })
            `uvm_fatal("CLK_SEQ", "Failed to select a clock option")
          if (!std::randomize(cycles) with {
            cycles inside {[min_cycles:max_cycles]};
          })
            `uvm_fatal("CLK_SEQ", "Failed to randomize clock cycles")
          send_period(period_ps, cycles);
        end
      end
      // Generate fully random clock segments within specified limits
      CLK_FULL_RANDOM: begin
        for (int unsigned i = 0; i < segment_count; i++)
          send_random_period();
      end
    endcase
  endtask

endclass

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
