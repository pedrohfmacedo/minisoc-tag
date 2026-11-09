class rst_sync_negedge_sequence extends rst_sequence;

  `uvm_object_utils(rst_sync_negedge_sequence)

  constraint rst_sync_negedge_c {
    assert_mode == rst_item::RST_SYNC;
    assert_edge == rst_item::RST_NEGEDGE;
    deassert_mode == rst_item::RST_SYNC;
    deassert_edge == rst_item::RST_NEGEDGE;
  }

  function new(string name = "rst_sync_negedge_sequence");
    super.new(name);
  endfunction

endclass
