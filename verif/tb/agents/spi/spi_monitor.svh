
class spi_monitor extends uvm_monitor;
  `uvm_component_utils(spi_monitor)

  spi_cfg cfg;
  virtual spi_if vif;
  uvm_analysis_port #(spi_item) ap;
  bit pending_read;
  spi_item::spi_addr pending_addr;

  function new(string name = "spi_monitor", uvm_component parent = null);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  // BUILD PHASE
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(spi_cfg)::get(this, "", "cfg", cfg))
      `uvm_fatal("SPI_CFG",
        "spi_cfg was not provided to spi_monitor")
    if (!uvm_config_db#(virtual spi_if)::get(this, "", "vif", vif))
      `uvm_fatal("SPI_VIF",
        "spi_if was not provided to spi_monitor")
  endfunction

  // RUN PHASE
  task run_phase(uvm_phase phase);

    logic [39:0] mosi_frame;
    logic [39:0] miso_frame;
    bit complete;
    spi_item item;
    pending_read = 1'b0;

    fork
      monitor_cpol();
    join_none

    forever begin
      // Capture physical SPI frame
      capture_frame( mosi_frame, miso_frame, complete);

      if (!complete) begin
        pending_read = 1'b0;
        continue;
      end

      if (!check_reserved_bit(mosi_frame)) begin
        pending_read = 1'b0;
        continue;
      end

      if (mosi_frame[39] === 1'b1) begin
        // CHECK: SPI_READ_NOP
        if (pending_read) begin
          check_read_sequence("New READ REQUEST before pending READ NOP");
        end
        pending_addr = spi_item::spi_addr'(mosi_frame[38:33]);
        pending_read = 1'b1;

        `uvm_info("SPI_MON", $sformatf( "READ REQUEST addr=0x%02h", pending_addr), UVM_MEDIUM)
      end


      // WRITE OR NOP
      else if (mosi_frame[39] === 1'b0) begin

        // NOP FRAME
        if (mosi_frame[38:33] == spi_item::REG_NOP) begin

          if (pending_read) begin

            // Complete logical READ
            item = spi_item::type_id::create("item");
            item.is_read = spi_item::SPI_READ;
            item.addr = pending_addr;
            item.write_data = '0;
            item.read_data = miso_frame[31:0];

            ap.write(item);

            `uvm_info("SPI_MON",$sformatf( "READ addr=0x%02h data=0x%08h",item.addr, item.read_data), UVM_MEDIUM)
            pending_read = 1'b0;
          end
          else begin
            // CHECK: SPI_READ_NOP
            check_read_sequence("NOP received without pending READ REQUEST", 1'b1);
          end
        end


        // NORMAL WRITE
        else begin
          // CHECK: SPI_READ_NOP
          if (pending_read) begin
            check_read_sequence( "WRITE received before pending READ NOP");
            pending_read = 1'b0;
          end

        // CHECK: SPI_READ_ONLY
         check_read_only(mosi_frame[38:33]);
          item = spi_item::type_id::create("item");
          item.is_read = spi_item::SPI_WRITE;
          item.addr = spi_item::spi_addr'(mosi_frame[38:33]);
          item.write_data = mosi_frame[31:0];
          item.read_data = '0;

          ap.write(item);

          `uvm_info("SPI_MON", $sformatf( "WRITE addr=0x%02h data=0x%08h", item.addr, item.write_data), UVM_MEDIUM)
        end
      end

      // UNKNOWN OPERATION
      else begin
        // CHECK: SPI_INVALID_OPERATION
        check_invalid_operation();
        pending_read = 1'b0;
      end
    end

  endtask

  // CAPTURE SPI FRAME

  task capture_frame(
    output logic [39:0] mosi_frame,
    output logic [39:0] miso_frame,
    output bit complete
  );

    int unsigned bit_count;
    bit frame_overflow;
    mosi_frame = '0;
    miso_frame = '0;
    complete = 1'b0;
    bit_count = 0;
    frame_overflow = 1'b0;

    // Wait for CS_N assertion
    @(negedge vif.spi_cs_n);

    // Capture while CS_N is active
    while (vif.spi_cs_n === 1'b0) begin
      // Wait for SPI sampling edge
      @(vif.mon_cb);
      if (vif.spi_cs_n === 1'b0) begin
        // CHECK: SPI_NO_X_CONTROL
        check_no_x_control();
        // CHECK: SPI_FRAME_LENGTH (overflow)
        if (bit_count >= 40) begin
          if (!frame_overflow)
            check_frame_overflow(bit_count);
          frame_overflow = 1'b1;
        end
        else begin
          // Sample SPI Mode 0 signals
          mosi_frame[39-bit_count] = vif.mon_cb.spi_mosi;
          miso_frame[39-bit_count] = vif.mon_cb.spi_miso;
        end
        bit_count++;
      end
    end

    // CHECK: SPI_FRAME_LENGTH
    if (!frame_overflow)
      complete = check_frame_length(bit_count);

  endtask

  // ------------------------------------------------------------
  // SPI PROTOCOL CHECKS
  // ------------------------------------------------------------

  // 1.SPI_RESERVED_BIT
  function bit check_reserved_bit(logic [39:0] mosi_frame);
    if (mosi_frame[32] !== 1'b0) begin
      `uvm_error("SPI_RESERVED_BIT", "Reserved bit must be zero")
      return 0;
    end
    return 1;
  endfunction

  // 2.SPI_READ_NOP - Validate READ REQUEST / NOP sequence
  function void check_read_sequence(string message, bit warning_only = 0);
    if (warning_only) begin
      `uvm_warning("SPI_READ_NOP", message)
    end
    else begin
      `uvm_error("SPI_READ_NOP", message)
    end
  endfunction

  // 3.SPI_FRAME_LENGTH - Detect frames containing more than 40 bits
  function bit check_frame_overflow(int unsigned bit_count);
    if (bit_count >= 40) begin
      `uvm_error("SPI_FRAME_LENGTH", "SPI frame contains more than 40 bits")
      return 0;
    end
    return 1;
  endfunction

  function bit check_frame_length(int unsigned bit_count);
    if (bit_count != 40) begin
      `uvm_error("SPI_FRAME_LENGTH",
        $sformatf("SPI frame must contain 40 bits, received %0d", bit_count))
      return 0;
    end
    return 1;
  endfunction

  // 4.SPI_INVALID_OPERATION - Detect unknown RW bit
  function void check_invalid_operation();
    `uvm_error("SPI_INVALID_OPERATION", "Unknown SPI operation (RWb)")
  endfunction

  // 6. SPI_CPOL
  function void check_cpol();
    if (vif.spi_cs_n === 1'b1 && vif.spi_sclk !== 1'b0)
      `uvm_error("SPI_CPOL", "SCLK must be LOW when CS_N is inactive")
  endfunction

  // 9. SPI_READ_ONLY
  function void check_read_only(logic [5:0] addr);

    // Replace with the actual read-only registers from the specification
    case (addr)

      // spi_item::REG_...:
      //   `uvm_error("SPI_READ_ONLY",
      //     "WRITE to read-only register")

      default: ;

    endcase
  endfunction

    // 7. SPI_NO_X_CONTROL
  function void check_no_x_control();

    if ($isunknown(vif.spi_sclk))
      `uvm_error("SPI_NO_X_CONTROL",
        "SCLK contains X/Z")

    if ($isunknown(vif.spi_cs_n))
      `uvm_error("SPI_NO_X_CONTROL",
        "CS_N contains X/Z")

    if ($isunknown(vif.spi_mosi))
      `uvm_error("SPI_NO_X_CONTROL",
        "MOSI contains X/Z")
  endfunction

  task monitor_cpol();

    // Check initial idle state
    check_cpol();

    forever begin
      @(vif.spi_cs_n or vif.spi_sclk);
      check_cpol();
    end
  endtask 

endclass


//

// class spi_monitor extends uvm_monitor;

//   `uvm_component_utils(spi_monitor)

//   // Configuration and interface
//   spi_cfg cfg;
//   virtual spi_if vif;

//   // Analysis port
//   uvm_analysis_port #(spi_item) ap;

//   // Pending READ information
//   bit pending_read;
//   spi_item::spi_addr pending_addr;

//   // Constructor
//   function new(string name = "spi_monitor",
//                uvm_component parent = null);
//     super.new(name, parent);
//     ap = new("ap", this);
//   endfunction

//   // Build phase
//   function void build_phase(uvm_phase phase);
//     super.build_phase(phase);

//     if (!uvm_config_db#(spi_cfg)::get(this, "", "cfg", cfg))
//       `uvm_fatal("SPI_CFG", "spi_cfg was not provided to spi_monitor")

//     if (!uvm_config_db#(virtual spi_if)::get(this, "", "vif", vif))
//       `uvm_fatal("SPI_VIF", "spi_if was not provided to spi_monitor")
//   endfunction

//   // Capture one SPI frame
//   task capture_frame(
//     output logic [39:0] mosi_frame,
//     output logic [39:0] miso_frame,
//     output bit complete
//   );

//     int unsigned bit_count;

//     mosi_frame = '0;
//     miso_frame = '0;
//     complete = 1'b0;
//     bit_count = 0;

//     // Wait for CS_N assertion
//     @(negedge vif.spi_cs_n);

//     // Capture while CS_N is active
//     forever begin

//       // Wait for SCLK rising edge or CS_N deassertion
//       fork
//         begin
//           @(vif.mon_cb);
//         end

//         begin
//           @(posedge vif.spi_cs_n);
//         end
//       join_any

//       disable fork;

//       // End of frame
//       if (vif.spi_cs_n !== 1'b0)
//         break;

//       // Frame overflow
//       if (bit_count >= 40) begin
//         `uvm_error("SPI_MON",
//           "SPI frame contains more than 40 bits")
//         continue;
//       end

//       // Sample SPI Mode 0 signals
//       mosi_frame[39-bit_count] = vif.mon_cb.spi_mosi;
//       miso_frame[39-bit_count] = vif.mon_cb.spi_miso;

//       bit_count++;

//     end

//     // Validate frame length
//     if (bit_count == 40) begin
//       complete = 1'b1;
//     end
//     else begin
//       `uvm_error("SPI_MON",
//         $sformatf(
//           "Incomplete SPI frame: captured %0d of 40 bits",
//           bit_count))
//     end

//   endtask

//   // Run phase
//   task run_phase(uvm_phase phase);

//     logic [39:0] mosi_frame;
//     logic [39:0] miso_frame;
//     bit complete;

//     spi_item item;

//     pending_read = 1'b0;

//     forever begin

//       // Capture physical SPI frame
//       capture_frame(
//         mosi_frame,
//         miso_frame,
//         complete
//       );

//       if (!complete) begin
//         pending_read = 1'b0;
//         continue;
//       end

//       // Reserved bit must be zero
//       if (mosi_frame[32] !== 1'b0) begin
//         `uvm_error("SPI_MON",
//           "Reserved bit must be zero")
//         pending_read = 1'b0;
//         continue;
//       end

//       // READ REQUEST
//       if (mosi_frame[39] === 1'b1) begin

//         if (pending_read) begin
//           `uvm_error("SPI_MON",
//             "New READ REQUEST before pending READ NOP")
//         end

//         pending_addr =
//           spi_item::spi_addr'(mosi_frame[38:33]);

//         pending_read = 1'b1;

//         `uvm_info("SPI_MON",
//           $sformatf(
//             "READ REQUEST addr=0x%02h",
//             pending_addr),
//           UVM_MEDIUM)

//       end

//       // WRITE or NOP
//       else if (mosi_frame[39] === 1'b0) begin

//         // NOP frame
//         if (mosi_frame[38:33] == spi_item::REG_NOP) begin

//           if (pending_read) begin

//             // Complete logical READ
//             item = spi_item::type_id::create("item");

//             item.is_read = spi_item::SPI_READ;
//             item.addr = pending_addr;
//             item.write_data = '0;
//             item.read_data = miso_frame[31:0];

//             ap.write(item);

//             `uvm_info("SPI_MON",
//               $sformatf(
//                 "READ addr=0x%02h data=0x%08h",
//                 item.addr,
//                 item.read_data),
//               UVM_MEDIUM)

//             pending_read = 1'b0;

//           end
//           else begin

//             `uvm_warning("SPI_MON",
//               "NOP received without pending READ REQUEST")

//           end

//         end

//         // Normal WRITE
//         else begin

//           if (pending_read) begin
//             `uvm_error("SPI_MON",
//               "WRITE received before pending READ NOP")
//             pending_read = 1'b0;
//           end

//           item = spi_item::type_id::create("item");

//           item.is_read = spi_item::SPI_WRITE;

//           item.addr =
//             spi_item::spi_addr'(mosi_frame[38:33]);

//           item.write_data = mosi_frame[31:0];
//           item.read_data = '0;

//           ap.write(item);

//           `uvm_info("SPI_MON",
//             $sformatf(
//               "WRITE addr=0x%02h data=0x%08h",
//               item.addr,
//               item.write_data),
//             UVM_MEDIUM)

//         end

//       end

//       // Unknown operation
//       else begin

//         `uvm_error("SPI_MON",
//           "Unknown SPI operation (RWb)")

//         pending_read = 1'b0;

//       end

//     end

//   endtask

// endclass

// //