class mem_sequence extends uvm_sequence #(mem_item);
  `uvm_object_utils(mem_sequence)

  rand int unsigned num_trans = 1;

  constraint num_trans_c {
    num_trans inside {[1:100]};
  }

  function new(string name = "mem_sequence");
    super.new(name);
  endfunction

  virtual task body();
    mem_item item;

    repeat (num_trans) begin
      item = mem_item::type_id::create("item");
      start_item(item);
      if (!item.randomize())
        `uvm_fatal("MEM_SEQ", "Failed to randomize mem_item")
      finish_item(item);
    end
  endtask

endclass