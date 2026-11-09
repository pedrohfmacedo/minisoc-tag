class rst_sync_posedge_sequence extends rst_sequence;

  `uvm_object_utils(rst_sync_posedge_sequence)

  constraint rst_sync_posedge_c {
    assert_mode == rst_item::RST_SYNC;
    assert_edge == rst_item::RST_POSEDGE;
    deassert_mode == rst_item::RST_SYNC;
    deassert_edge == rst_item::RST_POSEDGE;
  }

  function new(string name = "rst_sync_posedge_sequence");
    super.new(name);
  endfunction

endclass
