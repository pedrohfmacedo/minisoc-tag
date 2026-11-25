// O que checkar na memória?
//
// ====== Nível de transação ======
// ========== Procedural ==========
//  - Endereço com tamanho válido - 10bits (MEM_ADDR_RANGE) -> nao faz muito snetido, ja que delcaro bit [9:0] (1 ou 0)
//  - Escrita somente com en = 1; (MEM_WRITE_ENABLE)
//  - sem X/Z durante opreação (MEM_NO_X_CONTROL) -> não usei pq declarei como bit 
//  - sem X/Z durante operaçoa (MEM_NO_X_ADDR)
//
// ====== Timing ======
// ========== Assertions ==========
// - Resposta de leitura no tempo especificado (MEM_READ_LATENCY)
// - Comportamento durante reset conforme especificação (MEM_DATA_STABILITY)

// Poderia fazer dentro do próprio montior, vamos colocar em um arquivo diferente para organização ou task, chamando dentro da run_phase
// Utilizar os sinais da mem_if para detectar X/Z e verificar as regras de leitura e escrita. 

class mem_checker extends uvm_subscriber #(mem_item);

    `uvm_component_utils(mem_checker)

    // Has-a
    mem_cfg cfg;
    virtual interface mem_if mem_vif;

    // Counters
    int unsigned total_trans  = 0;
    int unsigned total_reads  = 0;
    int unsigned total_writes = 0;
    int unsigned total_errors = 0;

    // Reference memory: 1024 addresses of 32 bits
    logic [31:0] ref_mem [0:1023];

    // Indicates whether an address has already been written
    bit valid_addr [0:1023];

    // Constructor
    function new(string name = "mem_checker",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(mem_cfg)::get(this, "", "cfg", cfg))
            `uvm_fatal("MEM_CFG",
                "mem_cfg was not provided to mem_checker")

        if (!uvm_config_db#(virtual interface mem_if)::get(
            this, "", "vif", mem_vif))
            `uvm_fatal("MEM_VIF",
                "mem_if was not provided to mem_checker")

        if (mem_vif == null)
            `uvm_fatal("MEM_VIF",
                "mem_if is null in mem_checker")

    endfunction


    // ==================================================
    // TRANSACTION LEVEL
    // ==================================================

    // Check write transaction
    function void check_write(mem_item item);

        total_writes++;

        `uvm_info("MEM_CHECK",
            $sformatf("WRITE addr=0x%03h data=0x%08h",
                      item.addr, item.data), UVM_MEDIUM)

    endfunction

    // Check read transaction
    function void check_read(mem_item item);

        total_reads++;

        `uvm_info("MEM_CHECK",
            $sformatf("READ addr=0x%03h data=0x%08h",
                      item.addr, item.data), UVM_MEDIUM)

    endfunction

    // Receive transactions from mem_monitor
    function void write(mem_item item);

        total_trans++;

        if (item.wr_en)
            check_write(item);
        else
            check_read(item);

    endfunction


    // ==================================================
    // SIGNAL LEVEL CHECKS
    // ==================================================

    // MEM_DATA_STABILITY
    // Checks whether the output remains stable during
    // a write operation.
    //
    // Enable only if required by the specification.
    // Reset stability cannot be checked because mem_if
    // does not provide a reset signal.

    function void check_data_stability(
        logic [31:0] previous_data
    );

        MEM_DATA_STABILITY: assert (
            mem_vif.mem_o_data === previous_data
        )
        else begin

            total_errors++;

            `uvm_error("MEM_DATA_STABILITY",
                $sformatf(
                    "Output changed during write: previous=0x%08h current=0x%08h",
                    previous_data,
                    mem_vif.mem_o_data
                ))

        end

    endfunction


    // MEM_READ_LATENCY
    // Checks whether the expected read data is available
    // at the expected response cycle.
    //
    // Only previously written addresses are checked,
    // since the initial memory contents are unknown.

    function void check_read_latency(
        logic [9:0] addr,
        logic [31:0] expected_data
    );

        MEM_READ_LATENCY: assert (
            mem_vif.mem_o_data === expected_data
        )
        else begin

            total_errors++;

            `uvm_error("MEM_READ_LATENCY",
                $sformatf(
                    "addr=0x%03h expected=0x%08h received=0x%08h",
                    addr,
                    expected_data,
                    mem_vif.mem_o_data
                ))

        end

    endfunction


    // ==================================================
    // RUN PHASE
    // ==================================================

    task run_phase(uvm_phase phase);

        logic [9:0] sampled_addr;
        logic [31:0] sampled_data;
        logic [31:0] previous_data;
        logic [31:0] expected_data;
        logic sampled_wr_en;

        bit check_read_valid;

        super.run_phase(phase);

        forever begin

            // Sample inputs at the rising clock edge
            @(posedge mem_vif.mem_clk);

            sampled_addr  = mem_vif.mem_i_addr;
            sampled_data  = mem_vif.mem_i_data;
            sampled_wr_en = mem_vif.mem_i_wr_en;
            previous_data = mem_vif.mem_o_data;

            check_read_valid = 0;

            // Write operation
            if (sampled_wr_en === 1'b1) begin

                // Update reference memory
                ref_mem[sampled_addr] = sampled_data;
                valid_addr[sampled_addr] = 1'b1;

            end

            // Read operation
            else if (sampled_wr_en === 1'b0) begin

                // Check only initialized addresses
                if (valid_addr[sampled_addr]) begin

                    expected_data = ref_mem[sampled_addr];
                    check_read_valid = 1'b1;

                end

            end

            // Wait for DUT output updates after the
            // rising clock edge (NBA region).
            #1ps;

            // MEM_DATA_STABILITY
            // Uncomment if output must remain stable
            // during write operations.

            // if (sampled_wr_en === 1'b1)
            //     check_data_stability(previous_data);

            // MEM_READ_LATENCY
            // Assumes synchronous read data is updated
            // after the same rising clock edge.

            if (check_read_valid)
                check_read_latency(
                    sampled_addr,
                    expected_data
                );

        end

    endtask


    // ==================================================
    // REPORT PHASE
    // ==================================================

    function void report_phase(uvm_phase phase);

        super.report_phase(phase);

        `uvm_info("MEM_CHECK_REPORT",
            $sformatf(
                "Transactions=%0d Writes=%0d Reads=%0d Errors=%0d",
                total_trans,
                total_writes,
                total_reads,
                total_errors
            ), UVM_LOW)

    endfunction

endclass