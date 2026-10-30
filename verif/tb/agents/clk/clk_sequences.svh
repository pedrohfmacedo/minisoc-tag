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

  task body();
    int unsigned period_ps;
    int unsigned cycles;

    case (mode)
      CLK_FIXED_THEN_CHANGE: begin
        send_period(initial_period_ps, initial_cycles);
        send_period(changed_period_ps, changed_cycles);
      end

      CLK_RANDOM_TWO_OPTIONS: begin
        for (int unsigned i = 0; i < segment_count; i++) begin
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

      CLK_FULL_RANDOM: begin
        for (int unsigned i = 0; i < segment_count; i++)
          send_random_period();
      end
    endcase
  endtask

endclass
