class minisoc_virtual_smoke_sequence extends
    minisoc_virtual_base_sequence;

    `uvm_object_utils(minisoc_virtual_smoke_sequence)

    // Constructor
    function new(
        string name = "minisoc_virtual_smoke_sequence"
    );
        super.new(name);
    endfunction

    // Body
    virtual task body();

        super.body();

        `uvm_info("VSEQ_SMOKE",
            "Starting Virtual Smoke Sequence",
            UVM_LOW)

        // Check sequencer handles
        if (p_sequencer == null)
            `uvm_fatal("VSEQ_SMOKE", "Virtual Sequencer is null")

        if (p_sequencer.clk_sqr == null)
            `uvm_fatal("VSEQ_SMOKE", "CLK Sequencer is null")

        if (p_sequencer.rst_sqr == null)
            `uvm_fatal("VSEQ_SMOKE", "RST Sequencer is null")

        if (p_sequencer.mem_sqr == null)
            `uvm_fatal("VSEQ_SMOKE", "MEM Sequencer is null")

        if (p_sequencer.spi_sqr == null)
            `uvm_fatal("VSEQ_SMOKE", "SPI Sequencer is null")

        `uvm_info("VSEQ_SMOKE",
            "All sequencer handles are valid",
            UVM_LOW)

        `uvm_info("VSEQ_SMOKE",
            "Virtual Smoke Sequence completed",
            UVM_LOW)

    endtask

endclass