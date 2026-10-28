class rst_item extends uvm_sequence_item;

    // Tipos de sincronizacao
    typedef enum bit {
        RST_ASYNC,
        RST_SYNC
    } rst_sync_mode_e;

    // Selecao da borda do clock
    typedef enum bit {
        RST_POSEDGE,
        RST_NEGEDGE
    } rst_edge_e;
 
  rand bit is_high; // 0 or 1 
  rand int unsigned duration; // Duração em time // rand time ?
  rand int unsigned cycles; // Duração em ciclos (low)
  rand rst_sync_mode_e sync_mode;
  rand rst_edge_e edge_sel;

  // Evita duração nula
  // constraint c_duration {
  //   duration > 0;
  // }
  // constraint c2_duration {
  //   cycles > 0;
  // }
  constraint rst_c {
    if (sync_mode == RST_ASYNC) {
        duration inside {[0:10000]};
        cycles == 0;
        }

    if (sync_mode == RST_SYNC) {
        cycles inside {[1:1000]};
        duration == 0;
        }
    }
  
  // Factory + Macros
    `uvm_object_utils_begin(rst_item)
        `uvm_field_int(is_high, UVM_ALL_ON)
        `uvm_field_int(duration, UVM_ALL_ON)
        `uvm_field_enum(rst_sync_mode_e, sync_mode, UVM_ALL_ON)
        `uvm_field_enum(rst_edge_e, edge_sel, UVM_ALL_ON)
    `uvm_object_utils_end

  // Constructor
  function new(string name = "rst_item");
    super.new(name);
  endfunction

endclass