class mem_sequence_base extends uvm_sequence #(mem_item);
  `uvm_object_utils(mem_sequence_base)

  function new(string name = "mem_sequence_base");
    super.new(name);
  endfunction

  task send(bit wr_en, bit [9:0] addr, bit [31:0] data);
    mem_item item;

    item = mem_item::type_id::create("item");
    start_item(item);
    item.wr_en = wr_en;
    item.addr = addr;
    item.data = data;
    item.period_ps = 0;
    finish_item(item);
  endtask
endclass
