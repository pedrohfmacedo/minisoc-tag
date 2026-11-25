class mem_ditl_sequence extends mem_sequence_base;

    `uvm_object_utils(mem_ditl_sequence)

    bit wr_en;
    bit [9:0] addr;
    bit [31:0] data;

    function new(string name = "mem_ditl_sequence");
        super.new(name);
    endfunction

    task body();

        send(wr_en, addr, data);

    endtask

endclass