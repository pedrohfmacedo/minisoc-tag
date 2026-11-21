// O que checkar no spi?
//
// ====== Nível de transação ======
// ========== Procedural ==========
//  1.OK -  o bit [32] é sempre zero (rsv) (SPI_RESERVED_BIT) -> 
//  2.OK - read seguido de nop (SPI_READ_NOP)
//  3.OK - Endereço com frame valido (SPI_FRAME_LENGTH) -> monta no drive sempre 40
//  4.OK - verifica de de rwb pe valido (write or read.)
//  - cs_n desativado entre frames (SPI_NO_BURST)
//  - clk desativado com en=1 (SPI_CPOL)
//  - SCLK, CS_N e MOSI sem X/Z durante transferência (SPI_NO_X_CONTROL)
//  - Reconstrução correta dos bits transmitidos (SPI_MSB_FIRST)
//  - Não escrever nos registradores somente leitura (SPI_READ_ONLY)
//
// ====== Timing ======
// ========== Assertions ==========
// - spi_sclk = 0 quando CS_N está inativo
// - Comportamento durante reset conforme especificação



// class spi_checker extends uvm_subscriber #(spi_item);
//     `uvm_component_utils(spi_checker)

//     //has-a 
//     spi_cfg cfg;

//     //constructor
//     function new (string name = "spi_checker", uvm_component parent = null);
//         super.new(name,parent);
//     endfunction

//     // Build phase
//     function void build_phase(uvm_phase phase);
//         super.build_phase(phase);

//         if (!uvm_config_db#(spi_cfg)::get(this, "", "cfg", cfg))
//         `uvm_fatal("spi_CFG",
//             "spi_cfg was not provided to spi_checker")
//     endfunction

//     // Counters
//     int unsigned total_trans = 0;
//     int unsigned total_reads = 0;
//     int unsigned total_writes = 0;
//     int unsigned total_errors = 0;
//     bit reserved_bit;

//     // Check reserved bit
//     function void check_reserved_bit(spi_item item);

//         if (item.reserved_bit !== 1'b0) begin
//             total_errors++;
//             `uvm_error("SPI_RESERVED_BIT",  $sformatf(
//                     "Reserved bit must be zero, received: %b", item.reserved_bit ))
//         end
//         if (item.is_read == spi_item::SPI_READ &&
//              item.nop_reserved_bit !== 1'b0) begin
//             total_errors++;
//             `uvm_error("SPI_RESERVED_BIT", $sformatf(
//                     "NOP reserved bit must be zero, received: %b", item.nop_reserved_bit ))
//         end
//     endfunction

//     // Check SPI operation bit
//     function void check_invalid_operation(spi_item item);

//         if ($isunknown(item.rw_bit)) begin
//             total_errors++;

//             `uvm_error("SPI_INVALID_OPERATION", $sformatf(
//                     "Invalid SPI operation bit (RW): %b", item.rw_bit ))
//         end
//     endfunction
  
//     function void write(spi_item item);
//         total_trans++;
//         check_reserved_bit(item);
//         check_invalid_operation(item);
//     endfunction

//     function void report_phase(uvm_phase phase);
//         super.report_phase(phase);

//         `uvm_info("spi_CHECK_REPORT",
//         $sformatf( "Transactions=%0d Writes=%0d Reads=%0d Errors=%0d",
//             total_trans, total_writes, total_reads, total_errors ),
//             UVM_LOW)
//     endfunction

// endclass