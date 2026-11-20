class spi_monitor extends uvm_monitor;
    `uvm_component_utils(spi_monitor)
    
    // has-a
    spi_cfg cfg;
    virtual interface spi_if spi_vif;
    uvm_analysis_port #(spi_item) ap;
    
    // Constructor
    function new(string name = "spi_monitor", uvm_component parent = null);
        super.new(name, parent);
        ap = new("mon_ap", this);
    endfunction

    // Build
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(spi_cfg)::get(this, "", "cfg", cfg))
            `uvm_fatal("spi_CFG", "spi_cfg was not provided to spi_monitor")      
        uvm_config_db#(virtual interface spi_if)::get(this, "", "vif", spi_vif);
        if (spi_vif == null)
            `uvm_fatal("spi_VIF", "spi_if was not provided to spi_monitor")
    endfunction

    // Run
 // Run phase
    task run_phase(uvm_phase phase);

        logic [39:0] mosi_frame;
        logic [39:0] miso_frame;
        bit complete;
        spi_item item;
        pending_read = 1'b0;

        forever begin

            capture_frame(
                mosi_frame,
                miso_frame,
                complete
            );

            if (!complete)
                continue;

            // Check reserved bit
            if (mosi_frame[32] !== 1'b0) begin
                `uvm_error("SPI_MON",
                    "RSV bit must be zero")
                continue;
            end

            // READ REQUEST
            if (mosi_frame[39] === 1'b1) begin

                pending_addr =
                    spi_item::spi_addr'(mosi_frame[38:33]);

                pending_read = 1'b1;

                `uvm_info("SPI_MON",
                    $sformatf("READ REQUEST addr=0x%02h",
                              pending_addr),
                    UVM_MEDIUM)

            end

            // WRITE or NOP
            else if (mosi_frame[39] === 1'b0) begin

                // NOP following READ REQUEST
                if (mosi_frame[38:33] == spi_item::REG_NOP
                    && pending_read) begin

                    item = spi_item::type_id::create("item");

                    item.is_read = spi_item::SPI_READ;
                    item.addr = pending_addr;
                    item.write_data = '0;
                    item.read_data = miso_frame[31:0];

                    ap.write(item);

                    `uvm_info("SPI_MON",
                        $sformatf(
                            "READ addr=0x%02h data=0x%08h",
                            item.addr,
                            item.read_data),
                        UVM_MEDIUM)

                    pending_read = 1'b0;

                end

                // Normal WRITE
                else begin

                    item = spi_item::type_id::create("item");

                    item.is_read = spi_item::SPI_WRITE;
                    item.addr = spi_item::spi_addr'(
                        mosi_frame[38:33]);

                    item.write_data = mosi_frame[31:0];

                    ap.write(item);

                    `uvm_info("SPI_MON",
                        $sformatf(
                            "WRITE addr=0x%02h data=0x%08h",
                            item.addr,
                            item.write_data),
                        UVM_MEDIUM)

                end
            end
            else begin
                `uvm_error("SPI_MON",
                    "Unknown RWb value")
            end

        end

    endtask


    // Capture a physical SPI frame
    task capture_frame(
        output logic [39:0] mosi_frame,
        output logic [39:0] miso_frame,
        output bit complete
    );

        mosi_frame = '0;
        miso_frame = '0;
        complete = 1'b0;

        // Wait for CS_N assertion
        @(negedge vif.spi_cs_n);

        // Capture 40 bits, MSB first
        for (int i = 39; i >= 0; i--) begin

            // Capture on SCLK rising edge, but also
            // detect CS_N deasserted before completion.
            fork
                begin
                    @(posedge vif.spi_sclk);
                end
                begin
                    @(posedge vif.spi_cs_n);
                end
            join_any
            disable fork;

            if (vif.spi_cs_n !== 1'b0) begin
                `uvm_error("SPI_MON",
                    "Incomplete SPI frame")
                return;
            end
            mosi_frame[i] = vif.spi_mosi;
            miso_frame[i] = vif.spi_miso;
        end
        complete = 1'b1;

        // Wait until CS_N is deasserted
        @(posedge vif.spi_cs_n);

    endtask


endclass