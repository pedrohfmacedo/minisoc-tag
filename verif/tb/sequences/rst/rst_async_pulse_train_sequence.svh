class rst_async_pulse_train_sequence extends rst_sequence;

  `uvm_object_utils(rst_async_pulse_train_sequence)

  constraint rst_async_pulse_train_c {
    assert_mode == rst_item::RST_ASYNC;
    deassert_mode == rst_item::RST_ASYNC;
    num_pulses inside {[3:10]};
    interval_ps inside {[100:1000]};
  }

  function new(string name = "rst_async_pulse_train_sequence");
    super.new(name);
  endfunction

endclass
