class rst_random_constrained_sequence extends rst_sequence;

  `uvm_object_utils(rst_random_constrained_sequence)

  // Constrained-random reset sequence aligned with the CI-Expert Fase 2
  // legal/random space: both async and sync reset behaviors are allowed,
  // but driven by valid duration/cycle bounds already enforced by rst_sequence.
  constraint rst_random_constrained_c {
    assert_mode inside {rst_item::RST_ASYNC, rst_item::RST_SYNC};
    deassert_mode inside {rst_item::RST_ASYNC, rst_item::RST_SYNC};
    assert_edge inside {rst_item::RST_POSEDGE, rst_item::RST_NEGEDGE};
    deassert_edge inside {rst_item::RST_POSEDGE, rst_item::RST_NEGEDGE};

    num_pulses inside {[1:10]};
    interval_ps inside {[0:10000]};

    if (assert_mode == rst_item::RST_ASYNC) {
      assert_duration inside {[1:10000]};
      assert_cycles == 0;
    }
    else {
      assert_cycles inside {[1:1000]};
      assert_duration == 0;
    }

    if (deassert_mode == rst_item::RST_ASYNC) {
      deassert_duration inside {[1:10000]};
      deassert_cycles == 0;
    }
    else {
      deassert_cycles inside {[1:1000]};
      deassert_duration == 0;
    }
  }

  function new(string name = "rst_random_constrained_sequence");
    super.new(name);
  endfunction

endclass
