class mem_item extends uvm_sequence_item;

  `uvm_object_utils(mem_item)

  // Fields
  rand int unsigned period_ps;
  rand bit [31:0] data;
  rand bit [9:0] addr;
  rand bit wr_en; //1 = write, 0 = read

  // Constraints
    constraint mem_c {
      data inside {[0:4294967295]};
      addr inside {[0:1023]};
    }

    constraint mem_timing_c {
      period_ps inside {[5000:100000]};
    }

  // Macro + fields
    `uvm_object_utils_begin(mem_item)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(wr_en, UVM_ALL_ON)
        `uvm_field_int(period_ps, UVM_ALL_ON)
    `uvm_object_utils_end

  // Constructor
  function new(string name = "mem_item");
    super.new(name);
  endfunction

endclass