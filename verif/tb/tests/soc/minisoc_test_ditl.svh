class minisoc_test_ditl extends minisoc_test_base;
  `uvm_component_utils(minisoc_test_ditl)

  localparam int unsigned MAX_PLL_POLLS = 20;
  localparam int unsigned MAX_AES_POLLS = 100;

  function new(string name = "minisoc_test_ditl",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task spi_write(spi_item::spi_addr addr, bit [31:0] data);
    spi_ditl_sequence seq;
    seq = spi_ditl_sequence::type_id::create("spi_wr");
    seq.op = spi_item::SPI_WRITE;
    seq.addr = addr;
    seq.data = data;
    seq.start(env.spi_agt.spi_seqr);
  endtask

  task spi_read(spi_item::spi_addr addr, output logic [31:0] data);
    spi_ditl_sequence seq;
    seq = spi_ditl_sequence::type_id::create("spi_rd");
    seq.op = spi_item::SPI_READ;
    seq.addr = addr;
    seq.data = '0;
    seq.start(env.spi_agt.spi_seqr);
    data = seq.response;
  endtask

  task mem_write(bit [9:0] addr, bit [31:0] data);
    mem_ditl_sequence seq;
    seq = mem_ditl_sequence::type_id::create("mem_wr");
    seq.wr_en = 1;
    seq.addr = addr;
    seq.data = data;
    seq.start(env.mem_agt.mem_seqr);
  endtask

  task mem_read_check(bit [9:0] addr, logic [31:0] expected);
    mem_ditl_sequence seq;
    logic [31:0] actual;
    seq = mem_ditl_sequence::type_id::create("mem_rd");
    seq.wr_en = 0;
    seq.addr = addr;
    seq.data = '0;
    seq.start(env.mem_agt.mem_seqr);
    // Driver completes the full memory clock pulse before item_done().
    // Sample the real four-state output, not the monitor's pre-NBA item.
    actual = env.mem_agt.mem_vif.mem_o_data;
    if (actual !== expected)
      `uvm_fatal("DITL_MEM", $sformatf("addr=%03h expected=%08h actual=%08h", addr, expected, actual))
    `uvm_info("DITL_MEM", $sformatf("PASS addr=%03h data=%08h", addr, actual), UVM_LOW)
  endtask

  task wait_pll_locked();
    logic [31:0] status;
    repeat (MAX_PLL_POLLS) begin
      spi_read(spi_item::REG_SYSTEM_STATUS, status);
      if (status[0] === 1'b1) return;
    end
    `uvm_fatal("DITL_PLL", "Timeout waiting for PLL lock")
  endtask

  task wait_aes_done();
    logic [31:0] status;
    repeat (MAX_AES_POLLS) begin
      spi_read(spi_item::REG_AES_STATUS, status);
      if (status[2] !== 1'b0)
        `uvm_fatal("DITL_AES", $sformatf("AES error or unknown status: %08h", status))
      if (status[1] === 1'b1) begin
        if (status[11:3] !== 9'd1)
          `uvm_fatal("DITL_AES", "Expected exactly one completed block")
        return;
      end
    end
    `uvm_fatal("DITL_AES", "Timeout waiting for AES DONE")
  endtask

  task scenario();
    clk_sequence clk_seq;
    rst_sequence rst_seq;
    logic [31:0] rd;

    // 1. Reference clock: 2 GHz. The driver keeps generating clock
    // after the two fixed segments finish.
    clk_seq = clk_sequence::type_id::create("clk_seq");
    clk_seq.mode = clk_sequence::CLK_FIXED_THEN_CHANGE;
    clk_seq.initial_period_ps = 500;
    clk_seq.changed_period_ps = 500;
    clk_seq.initial_cycles = 10;
    clk_seq.changed_cycles = 10;
    clk_seq.start(env.clk_agt.clk_seqr);

    // 2. Reset: asynchronous assertion, synchronous release.
    rst_seq = rst_sequence::type_id::create("rst_seq");
    rst_seq.num_pulses = 1;
    rst_seq.interval_ps = 0;
    rst_seq.assert_mode = rst_item::RST_ASYNC;
    rst_seq.assert_edge = rst_item::RST_POSEDGE;
    rst_seq.assert_duration = 10000;
    rst_seq.assert_cycles = 0;
    rst_seq.deassert_mode = rst_item::RST_SYNC;
    rst_seq.deassert_edge = rst_item::RST_POSEDGE;
    rst_seq.deassert_duration = 0;
    rst_seq.deassert_cycles = 2;
    rst_seq.start(env.rst_agt.rst_seq);
    #1ps;

    `uvm_info("DITL", "01 - Verify initial SPI state", UVM_LOW)
    spi_read(spi_item::REG_VERSION, rd);
    if (rd !== 32'h00010100) `uvm_fatal("DITL_SPI", "VERSION mismatch")
    spi_read(spi_item::REG_SYSTEM_STATUS, rd);
    if (rd[0] !== 1'b0) `uvm_fatal("DITL_PLL", "PLL must start unlocked")

    `uvm_info("DITL", "02 - Load and verify plaintext", UVM_LOW)
    mem_write(0, 32'h00112233);
    mem_write(1, 32'h44556677);
    mem_write(2, 32'h8899AABB);
    mem_write(3, 32'hCCDDEEFF);
    mem_read_check(0, 32'h00112233);
    mem_read_check(1, 32'h44556677);
    mem_read_check(2, 32'h8899AABB);
    mem_read_check(3, 32'hCCDDEEFF);

    `uvm_info("DITL", "03 - Configure AES-128 ECB", UVM_LOW)
    spi_write(spi_item::REG_KEY0, 32'h00010203);
    spi_write(spi_item::REG_KEY1, 32'h04050607);
    spi_write(spi_item::REG_KEY2, 32'h08090A0B);
    spi_write(spi_item::REG_KEY3, 32'h0C0D0E0F);
    spi_write(spi_item::REG_IV0, 0);
    spi_write(spi_item::REG_IV1, 0);
    spi_write(spi_item::REG_IV2, 0);
    spi_write(spi_item::REG_IV3, 0);
    spi_write(spi_item::REG_COUNTER_HI, 0);
    spi_write(spi_item::REG_COUNTER_LO, 0);
    spi_write(spi_item::REG_NUM_BLOCKS, 1);
    spi_write(spi_item::REG_AES_CONTROL, 0);

    `uvm_info("DITL", "04 - Enable PLL /8 and wait for lock", UVM_LOW)
    spi_write(spi_item::REG_SYSTEM_CONTROL, 32'hE);
    wait_pll_locked();
    #12ns; // Three nominal 250 MHz system-clock periods.

    `uvm_info("DITL", "05 - Transfer memory ownership to AES", UVM_LOW)
    // The existing checker tracks USER writes only. AES writes make
    // those reference entries stale; invalidate before ownership changes.
    foreach (env.mem_agt.mem_chk.valid_addr[i])
      env.mem_agt.mem_chk.valid_addr[i] = 0;
    spi_write(spi_item::REG_SYSTEM_CONTROL, 32'hF);
    spi_read(spi_item::REG_SYSTEM_CONTROL, rd);
    if (rd[3:0] !== 4'hF) `uvm_fatal("DITL_SPI", "Ownership readback mismatch")

    `uvm_info("DITL", "06 - Start AES and wait for DONE", UVM_LOW)
    spi_write(spi_item::REG_AES_CONTROL, 1);
    wait_aes_done();

    `uvm_info("DITL", "07 - Return memory to USER and verify ciphertext", UVM_LOW)
    spi_write(spi_item::REG_SYSTEM_CONTROL, 32'hE);
    mem_read_check(0, 32'h69C4E0D8);
    mem_read_check(1, 32'h6A7B0430);
    mem_read_check(2, 32'hD8CDB780);
    mem_read_check(3, 32'h70B4C55A);

    `uvm_info("DITL", "08 - Disable PLL", UVM_LOW)
    spi_write(spi_item::REG_SYSTEM_CONTROL, 0);
    spi_read(spi_item::REG_SYSTEM_STATUS, rd);
    if (rd[0] !== 1'b0) `uvm_fatal("DITL_PLL", "PLL still locked")
  endtask

  task run_phase(uvm_phase phase);
    uvm_report_server server;
    phase.raise_objection(this);
    fork : bounded_ditl
      begin
        scenario();
      end
      begin
        #2ms;
        `uvm_fatal("DITL_TIMEOUT", "Global DITL timeout")
      end
    join_any
    disable bounded_ditl;
    server = uvm_report_server::get_server();
    if (server.get_severity_count(UVM_ERROR) != 0 ||
        server.get_severity_count(UVM_FATAL) != 0)
      `uvm_fatal("DITL", "Scenario completed with UVM errors")
    `uvm_info("DITL", "PASS: SPI -> PLL -> AES -> MEMORY", UVM_NONE)
    phase.drop_objection(this);
  endtask
endclass
