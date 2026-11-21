// O que checkar na memória?
//
// ====== Nível de transação ======
// ========== Procedural ==========
//  - Endereço com tamanho válido - 10bits (MEM_ADDR_RANGE) -> nao faz muito snetido, ja que delcaro bit [9:0] (1 ou 0)
//  - Escrita somente com en = 1; (MEM_WRITE_ENABLE)
//  - sem X/Z durante opreação (MEM_NO_X_CONTROL) -> não usei pq declarei como bit 
//
// ====== Timing ======
// ========== Assertions ==========
// - Resposta de leitura no tempo especificado (MEM_READ_LATENCY)
// - Comportamento durante reset conforme especificação (MEM_DATA_STABILITY)

// Poderia fazer dentro do próprio montior, vamos colocar em um arquivo diferente para organização ou task, chamando dentro da run_phase
// Utilizar os sinais da mem_if para detectar X/Z e verificar as regras de leitura e escrita. 

class mem_checker extends uvm_subscriber #(mem_item);
    `uvm_component_utils(mem_checker)

    //has-a 
    mem_cfg cfg;

    //constructor
    function new (string name = "mem_checker", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(mem_cfg)::get(this, "", "cfg", cfg))
        `uvm_fatal("MEM_CFG",
            "mem_cfg was not provided to mem_checker")
  endfunction

    // Counters
    int unsigned total_trans = 0;
    int unsigned total_reads = 0;
    int unsigned total_writes = 0;
    int unsigned total_errors = 0;

    //  Check write transaction
  function void check_write(mem_item item);
    total_writes++;
    `uvm_info("MEM_CHECK",
        $sformatf( "WRITE addr=0x%03h data=0x%08h", item.addr, item.data), UVM_MEDIUM)
  endfunction

  // Check read transaction
  function void check_read(mem_item item);
    total_reads++;
    `uvm_info("MEM_CHECK",
      $sformatf( "READ addr=0x%03h data=0x%08h", item.addr, item.data ),UVM_MEDIUM)
  endfunction

  function void write(mem_item item);
    total_trans++;

    // Operation checks
    if (item.wr_en)
      check_write(item);
    else
      check_read(item);
      
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);

    `uvm_info("MEM_CHECK_REPORT",
      $sformatf( "Transactions=%0d Writes=%0d Reads=%0d Errors=%0d",
        total_trans, total_writes, total_reads, total_errors ),
         UVM_LOW)

  endfunction

endclass