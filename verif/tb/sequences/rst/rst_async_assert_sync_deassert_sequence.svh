class rst_async_assert_sync_deassert_sequence extends rst_sequence;

  `uvm_object_utils(rst_async_assert_sync_deassert_sequence)

  constraint rst_async_assert_sync_deassert_c {
    assert_mode == rst_item::RST_ASYNC;
    deassert_mode == rst_item::RST_SYNC;
    deassert_edge == rst_item::RST_NEGEDGE;
  }

  function new(string name = "rst_async_assert_sync_deassert_sequence");
    super.new(name);
  endfunction

endclass
