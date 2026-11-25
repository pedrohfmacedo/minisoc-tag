class minisoc_test_smoke extends minisoc_test_base;
    `uvm_component_utils(minisoc_test_smoke)

    // Constructor
    function new( string name = "minisoc_test_smoke", uvm_component parent = null );
        super.new(name, parent);
    endfunction

    // Build phase
    function void build_phase(uvm_phase phase);
        minisoc_virtual_base_sequence::type_id::set_type_override(minisoc_virtual_smoke_sequence::get_type()); // Factory Override
        super.build_phase(phase);
    endfunction

endclass