class minisoc_test_base extends uvm_test;
    `uvm_component_utils(minisoc_test_base)

    // Has-a
    minisoc_env env;
    minisoc_virtual_base_sequence vseq; // Declaração da Virtual Base Sequence
    // Constructor
    function new(string name = "minisoc_test_base", uvm_component parent = null );
        super.new(name, parent);
    endfunction

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = minisoc_env::type_id::create("env", this);
    endfunction

    // End of Elaboration phase
    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction

    // Run phase
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        vseq = minisoc_virtual_base_sequence::type_id::create("vseq"); // Criação através da Factory
        vseq.start(env.vseqr); // a virtual sequence runs in a sequencer. para acesse p_sequencer.etc
        phase.drop_objection(this);

    endtask

endclass
// class minisoc_test_base extends uvm_test;
//   `uvm_component_utils(minisoc_test_base)
  
//   // has-a
//   minisoc_env     env;

//   // Constrcutor
//   function new(string name = "minisoc_test_base",
//                uvm_component parent = null);
//     super.new(name, parent);
//   endfunction

//   // Build phase
//   function void build_phase(uvm_phase phase);
//     super.build_phase(phase);
//     env = minisoc_env::type_id::create("env", this);
//   endfunction

//   // End of Elaboration phase
//   function void end_of_elaboration_phase(uvm_phase phase);
//     super.end_of_elaboration_phase(phase);
//     uvm_top.print_topology();
//   endfunction

// endclass
