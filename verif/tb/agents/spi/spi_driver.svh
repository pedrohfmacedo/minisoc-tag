
class spi_driver extends uvm_driver #(spi_item);
  `uvm_component_utils(spi_driver)

  // has-a
  spi_cfg cfg;
  virtual interface spi_if vif;

  // Constructor
  function new(string name = "spi_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Se a configuração não for fornecida = fatal
    if (!uvm_config_db#(spi_cfg)::get(this, "", "cfg", cfg))
      `uvm_fatal("spi_CFG", "spi_cfg was not provided to spi_driver")

    uvm_config_db#(virtual spi_if)::get(this, "", "vif", vif);
    if (vif == null)
      `uvm_fatal("spi_VIF", "spi_if was not provided to spi_driver")
  endfunction

  time current_period;

  // Run
  task run_phase(uvm_phase phase);
    spi_item req;

    current_period = cfg.period_ps;
    vif.spi_sclk  = 1'b0;
    vif.spi_cs_n  = 1'b1;
    vif.spi_mosi  = 1'b0;

    forever begin
      seq_item_port.get_next_item(req);

      if (req == null)
        `uvm_fatal("SPI_DRV", "Received null spi_item from sequencer")

      if (req.period_ps > 0)
        current_period = req.period_ps;
      else
        current_period = cfg.period_ps;

      if (req.is_read == spi_item::SPI_READ) begin // escopo para acessar enum do item
        spi_read(req);
      end else begin
        spi_write(req);
      end
      
      `uvm_info("SPI_DRV", $sformatf("SPI transaction completed: %s", req.convert2string()), UVM_MEDIUM);
      seq_item_port.item_done();
    end
  endtask

  task spi_write(spi_item req);
    bit [39:0] tx_frame; // só pode ser 1 or 0
    logic [39:0] rx_frame; // pode ser x...

    tx_frame = {
      1'b0,             // WRITE
      req.addr,         // 6 bits
      1'b0,             // RSV
      req.write_data    // 32 bits
    };

    transfer_frame(tx_frame, rx_frame, current_period); 

  endtask

  task spi_read(spi_item req);
    bit [39:0] tx_frame;
    logic [39:0] rx_frame;

    // READ REQUEST
    tx_frame = {
      1'b1,             // READ
      req.addr,         // 6 bits
      1'b0,             // RSV  
      32'b0};           // 32 bits of dummy data

    transfer_frame(tx_frame, rx_frame, current_period);

    // NOP
    tx_frame = {
      1'b0,             // NOP
      spi_item::REG_NOP,// NOP  
      1'b0,             // RSV
      32'b0};           // 32 bits of dummy data

    transfer_frame(tx_frame, rx_frame, current_period);

    req.read_data = rx_frame[31:0];

  endtask

task transfer_frame(
    input  bit [39:0] tx_frame,
    output logic [39:0] rx_frame,
    input time current_period
);

    // Start
    rx_frame = '0;
    vif.spi_sclk = 1'b0;
    vif.spi_cs_n = 1'b0;
    #(current_period * 2);
    // Transmitir o bit
    for (int i = 39; i >= 0; i--) begin
        vif.spi_mosi = tx_frame[i];
        #(current_period / 2);
        vif.spi_sclk = 1'b1;
        #(current_period -(current_period-1));
        rx_frame[i] = vif.spi_miso;
        #((current_period / 2)-1);
        vif.spi_sclk = 1'b0;
        #(current_period * 2);
    end

    // Finaliza o frame
    vif.spi_cs_n = 1'b1;
    vif.spi_mosi = 1'b0;
    vif.spi_sclk = 1'b0;

    // Mantém CS_N desativado antes do próximo frame
    #(current_period * 2);

endtask
endclass

// class spi_driver extends uvm_driver #(spi_item);

//   `uvm_component_utils(spi_driver)

//   spi_cfg cfg;
//   virtual spi_if vif;

//   // Constructor
//   function new(string name = "spi_driver",
//                uvm_component parent = null);
//     super.new(name, parent);
//   endfunction

//   // Build phase
//   function void build_phase(uvm_phase phase);
//     super.build_phase(phase);

//     if (!uvm_config_db#(spi_cfg)::get(this, "", "cfg", cfg))
//       `uvm_fatal("SPI_CFG", "spi_cfg not provided")

//     if (!uvm_config_db#(virtual spi_if)::get(this, "", "vif", vif))
//       `uvm_fatal("SPI_VIF", "spi_if not provided")
//   endfunction

//   // Reset SPI signals
//   task reset_signals();
//     vif.spi_sclk = 1'b0;
//     vif.spi_cs_n = 1'b1;
//     vif.spi_mosi = 1'b0;
//   endtask

//   // Transfer one 40-bit SPI frame
    
//   task transfer_frame(
//     input  bit [39:0] tx_frame,
//     output logic [39:0] rx_frame,
//     input  int unsigned current_period
//   );

//     rx_frame = '0;

//     if (current_period < 40000)
//       `uvm_fatal("SPI_TIMING",
//         "SPI period must be >= 40000 ps")

//     // SPI Mode 0
//     vif.spi_sclk = 1'b0;
//     vif.spi_cs_n = 1'b0;

//     // CS setup time
//     #(current_period / 2 * 1ps);

//     for (int i = 39; i >= 0; i--) begin

//       // Set MOSI while SCLK is low
//       vif.spi_mosi = tx_frame[i];

//       #(current_period / 2 * 1ps);

//       // Rising edge
//       vif.spi_sclk = 1'b1;

//       // Capture MISO
//       #1ps;
//       rx_frame[i] = vif.spi_miso;

//       // Complete high half-period
//       #((current_period / 2 - 1) * 1ps);

//       // Falling edge
//       vif.spi_sclk = 1'b0;

//     end

//     // CS hold time
//     #(current_period / 2 * 1ps);

//     vif.spi_cs_n = 1'b1;
//     vif.spi_mosi = 1'b0;

//     // Inter-frame intervals
//     #(current_period * 2 * 1ps);

//   endtask


//   // SPI WRITE
//   task spi_write(spi_item req);

//     bit   [39:0] tx_frame;
//     logic [39:0] rx_frame;

//     tx_frame = {
//       1'b0,
//       req.addr,
//       1'b0,
//       req.write_data
//     };

//     transfer_frame(
//       tx_frame,
//       rx_frame,
//       req.period_ps
//     );

//   endtask

//   // SPI READ
//   task spi_read(spi_item req);

//     bit   [39:0] tx_frame;
//     logic [39:0] rx_frame;

//     // READ REQUEST
//     tx_frame = {
//       1'b1,
//       req.addr,
//       1'b0,
//       32'b0
//     };

//     transfer_frame(
//       tx_frame,
//       rx_frame,
//       req.period_ps
//     );

//     // NOP frame
//     tx_frame = {
//       1'b0,
//       spi_item::REG_NOP,
//       1'b0,
//       32'b0
//     };

//     transfer_frame(
//       tx_frame,
//       rx_frame,
//       req.period_ps
//     );

//     // Capture read data
//     req.read_data = rx_frame[31:0];

//   endtask

//   // Run phase
//   task run_phase(uvm_phase phase);

//     spi_item req;

//     reset_signals();

//     forever begin

//       seq_item_port.get_next_item(req);

//       if (req.is_read == spi_item::SPI_WRITE)
//         spi_write(req);
//       else
//         spi_read(req);

//       `uvm_info("SPI_DRIVER",
//         $sformatf("Transaction completed: %s",
//                   req.convert2string()),
//         UVM_MEDIUM)

//       seq_item_port.item_done();

//     end

//   endtask

// endclass
