class minisoc_virtual_base_sequence extends uvm_sequence;
    `uvm_object_utils(minisoc_virtual_base_sequence)
     //A macro declara um handle tipado chamado p_sequencer e implementa a conversão de tipo a partir do m_sequencer interno da UVM.
    `uvm_declare_p_sequencer(minisoc_virtual_sequencer)
    // ============================================================
    // CLK sequences
    // ============================================================
    clk_sequence                     clk_seq;
    clk_2ghz_sequence                clk_2ghz_seq;
    clk_500ps_then_1ns_sequence       clk_500ps_then_1ns_seq;
    clk_period_limits_sequence       clk_period_limits_seq;
    clk_bounded_random_sequence      clk_bounded_random_seq;
    clk_random_constrained_sequence  clk_random_constrained_seq;

    // ============================================================
    // RST sequences
    // ============================================================
    rst_sequence                            rst_seq;
    rst_async_assert_sync_deassert_sequence  rst_async_sync_seq;
    rst_fully_async_sequence                rst_fully_async_seq;
    rst_sync_posedge_sequence               rst_sync_posedge_seq;
    rst_sync_negedge_sequence               rst_sync_negedge_seq;
    rst_async_pulse_train_sequence          rst_async_pulse_train_seq;
    rst_random_constrained_sequence         rst_random_constrained_seq;

    // ============================================================
    // MEM sequences
    // ============================================================
    mem_sequence          mem_seq;
    mem_write_sequence    mem_write_seq;
    mem_read_sequence     mem_read_seq;
    mem_random_sequence   mem_random_seq;
    mem_corners_sequence  mem_corners_seq;
    mem_mix_sequence      mem_mix_seq;

    // ============================================================
    // SPI sequences
    // ============================================================
    spi_sequence                    spi_seq;
    spi_write_sequence              spi_write_seq;
    spi_read_sequence               spi_read_seq;
    spi_control_sequence            spi_control_seq;
    spi_status_sequence             spi_status_seq;
    spi_num_blocks_sequence         spi_num_blocks_seq;
    spi_random_sequence             spi_random_seq;
    spi_back_to_back_sequence       spi_back_to_back_seq;
    spi_write_read_sequence         spi_write_read_seq;
    spi_write_read_random_sequence  spi_write_read_random_seq;

    function new(string name = "minisoc_virtual_base_sequence");
        super.new(name);
    endfunction

    // Inicialmente, esses handles possuem valor null. A criação será feita pela Factory quando a Virtual Sequence derivada precisar utilizar determinado estímulo.
    virtual task body();
// ========================================================
        // CLK sequences creation
        // ========================================================

        clk_seq =
            clk_sequence::type_id::create("clk_seq");

        clk_2ghz_seq =
            clk_2ghz_sequence::type_id::create("clk_2ghz_seq");

        clk_500ps_then_1ns_seq =
            clk_500ps_then_1ns_sequence::type_id::create(
                "clk_500ps_then_1ns_seq");

        clk_period_limits_seq =
            clk_period_limits_sequence::type_id::create(
                "clk_period_limits_seq");

        clk_bounded_random_seq =
            clk_bounded_random_sequence::type_id::create(
                "clk_bounded_random_seq");

        clk_random_constrained_seq =
            clk_random_constrained_sequence::type_id::create(
                "clk_random_constrained_seq");

        // ========================================================
        // RST sequences creation
        // ========================================================

        rst_seq =
            rst_sequence::type_id::create("rst_seq");

        rst_async_sync_seq =
            rst_async_assert_sync_deassert_sequence::type_id::create(
                "rst_async_sync_seq");

        rst_fully_async_seq =
            rst_fully_async_sequence::type_id::create(
                "rst_fully_async_seq");

        rst_sync_posedge_seq =
            rst_sync_posedge_sequence::type_id::create(
                "rst_sync_posedge_seq");

        rst_sync_negedge_seq =
            rst_sync_negedge_sequence::type_id::create(
                "rst_sync_negedge_seq");

        rst_async_pulse_train_seq =
            rst_async_pulse_train_sequence::type_id::create(
                "rst_async_pulse_train_seq");

        rst_random_constrained_seq =
            rst_random_constrained_sequence::type_id::create(
                "rst_random_constrained_seq");

        // ========================================================
        // MEM sequences creation
        // ========================================================

        mem_seq =
            mem_sequence::type_id::create("mem_seq");

        mem_write_seq =
            mem_write_sequence::type_id::create("mem_write_seq");

        mem_read_seq =
            mem_read_sequence::type_id::create("mem_read_seq");

        mem_random_seq =
            mem_random_sequence::type_id::create("mem_random_seq");

        mem_corners_seq =
            mem_corners_sequence::type_id::create("mem_corners_seq");

        mem_mix_seq =
            mem_mix_sequence::type_id::create("mem_mix_seq");

        // ========================================================
        // SPI sequences creation
        // ========================================================

        spi_seq =
            spi_sequence::type_id::create("spi_seq");

        spi_write_seq =
            spi_write_sequence::type_id::create("spi_write_seq");

        spi_read_seq =
            spi_read_sequence::type_id::create("spi_read_seq");

        spi_control_seq =
            spi_control_sequence::type_id::create("spi_control_seq");

        spi_status_seq =
            spi_status_sequence::type_id::create("spi_status_seq");

        spi_num_blocks_seq =
            spi_num_blocks_sequence::type_id::create(
                "spi_num_blocks_seq");

        spi_random_seq =
            spi_random_sequence::type_id::create("spi_random_seq");

        spi_back_to_back_seq =
            spi_back_to_back_sequence::type_id::create(
                "spi_back_to_back_seq");

        spi_write_read_seq =
            spi_write_read_sequence::type_id::create(
                "spi_write_read_seq");

        spi_write_read_random_seq =
            spi_write_read_random_sequence::type_id::create(
                "spi_write_read_random_seq");

    endtask
endclass