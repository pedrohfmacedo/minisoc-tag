class mem_sequence extends mem_sequence_base;
  `uvm_object_utils(mem_sequence)

  function new(string name = "mem_sequence");
    super.new(name);
  endfunction

  task body();
    mem_write_sequence write_seq;
    mem_read_sequence read_seq;
    mem_random_sequence random_seq;
    mem_corners_sequence corners_seq;
    mem_mix_sequence mix_seq;

    write_seq = mem_write_sequence::type_id::create("write_seq");
    read_seq = mem_read_sequence::type_id::create("read_seq");
    random_seq = mem_random_sequence::type_id::create("random_seq");
    corners_seq = mem_corners_sequence::type_id::create("corners_seq");
    mix_seq = mem_mix_sequence::type_id::create("mix_seq");

    write_seq.start(m_sequencer, this);
    read_seq.start(m_sequencer, this);
    random_seq.start(m_sequencer, this);
    corners_seq.start(m_sequencer, this);
    mix_seq.start(m_sequencer, this);
  endtask
endclass

/* Versao anterior do smoke test:
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
    item.addr = 10'h010;
    finish_item(item);

    start_item(item);
    item.wr_en = 1'b0;
    item.addr = 10'h010;
    finish_item(item);

    start_item(item);
    item.wr_en = 1'b0;
    item.addr = 10'h010;
    finish_item(item);
  endtask
endclass
*/