class rst_fully_async_sequence extends rst_sequence;

  `uvm_object_utils(rst_fully_async_sequence)

  constraint rst_fully_async_c {
    assert_mode == rst_item::RST_ASYNC;
    deassert_mode == rst_item::RST_ASYNC;
  }

  function new(string name = "rst_fully_async_sequence");
    super.new(name);
  endfunction

endclass
