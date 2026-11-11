class mem_sequence extends uvm_sequence #(mem_item);
  `uvm_object_utils(mem_sequence)

  rand int unsigned num_trans = 1;

  constraint num_trans_c {
    num_trans inside {[1:100]};
  }

  function new(string name = "mem_sequence");
    super.new(name);
  endfunction


  task body();
    mem_item item;
      item = mem_item::type_id::create("item");
      start_item(item);
      item.wr_en = 1'b1;     
      item.data = 32'hAAAA_BBBB;
      item.addr = 10'h0000_0010; 
      finish_item(item);
      start_item(item);
      item.wr_en = 1'b0;   
      item.addr = 10'h0000_0010;   
      finish_item(item);
      start_item(item);
      item.wr_en = 1'b0;   
      item.addr = 10'h0000_0010;   
      finish_item(item);
  endtask

endclass