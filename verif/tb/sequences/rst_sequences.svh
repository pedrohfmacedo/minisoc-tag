// Sequencia base de reset: rst_sequence.
// Suporta assert/deassert sincronos ou assincronos, selecao de borda,
// configuracao de duracao/ciclos e um ou mais pulsos.
// O cenario de minisoc_reset_test e especializado abaixo por heranca.
class rst_sequence extends uvm_sequence #(rst_item);

  `uvm_object_utils(rst_sequence)

  // Configuracao do assert de rst_n.
  rand rst_item::rst_sync_mode_e assert_mode;
  rand rst_item::rst_edge_e      assert_edge;
  rand int unsigned               assert_duration;
  rand int unsigned               assert_cycles;

  // Configuracao do deassert de rst_n.
  rand rst_item::rst_sync_mode_e deassert_mode;
  rand rst_item::rst_edge_e      deassert_edge;
  rand int unsigned               deassert_duration;
  rand int unsigned               deassert_cycles;

  // Configuracao dos pulsos.
  rand int unsigned num_pulses;
  rand int unsigned interval_ps;

  // 0: reutiliza uma configuracao; 1: randomiza cada pulso novamente.
  bit randomize_each_pulse = 1'b0;

  constraint rst_seq_c {
    num_pulses inside {[1:10]};
    interval_ps inside {[0:10000]};

    if (assert_mode == rst_item::RST_ASYNC) {
      assert_duration inside {[1:10000]};
      assert_cycles == 0;
    }
    else {
      assert_cycles inside {[1:1000]};
      assert_duration == 0;
    }

    if (deassert_mode == rst_item::RST_ASYNC) {
      deassert_duration inside {[1:10000]};
      deassert_cycles == 0;
    }
    else {
      deassert_cycles inside {[1:1000]};
      deassert_duration == 0;
    }
  }

  function new(string name = "rst_sequence");
    super.new(name);
  endfunction

  // Envia uma transicao ao driver.
  task send_reset(
    bit                        level,
    rst_item::rst_sync_mode_e  mode,
    rst_item::rst_edge_e       edge_sel,
    int unsigned               duration,
    int unsigned               cycles
  );
    rst_item item;

    item = rst_item::type_id::create("item");
    start_item(item);
    item.is_high   = level;
    item.sync_mode = mode;
    item.edge_sel  = edge_sel;
    item.duration  = duration;
    item.cycles    = cycles;
    finish_item(item);
  endtask

  // Envia uma sequencia de pulsos de reset ao driver. (Main)
  task body;
    int unsigned total_pulses;

    total_pulses = num_pulses;
    // Envia os pulsos de reset
    for (int i = 0; i < total_pulses; i++) begin
      if (randomize_each_pulse && i > 0) begin // Randomiza novamente os parametros do pulso, exceto o numero total de pulsos
        if (!this.randomize() with { num_pulses == total_pulses; }) // Mantem o mesmo numero de pulsos
          `uvm_fatal("RST_SEQ", "Falha ao randomizar o pulso de reset")
      end

      if (i > 0) // Aguarda o intervalo entre pulsos, se houver mais de um pulso
        #(interval_ps * 1ps);

      send_reset(1'b0, assert_mode, assert_edge,
                 assert_duration, assert_cycles);
      send_reset(1'b1, deassert_mode, deassert_edge,
                 deassert_duration, deassert_cycles);

      `uvm_info("RST_SEQ",
        $sformatf("Pulso %0d de %0d concluido", i + 1, total_pulses),
        UVM_MEDIUM)
    end
  endtask

endclass

// Case: fixa os modos e a borda do cenario,
// reutilizando o envio de pulsos implementado pela classe base.
class rst_async_assert_sync_deassert_sequence extends rst_sequence;

  `uvm_object_utils(rst_async_assert_sync_deassert_sequence)

  constraint rst_async_assert_sync_deassert_c {
    assert_mode == rst_item::RST_ASYNC;
    deassert_mode == rst_item::RST_SYNC;
    deassert_edge == rst_item::RST_NEGEDGE;
  }

  function new(string name = "rst_async_assert_sync_deassert_sequence");
    super.new(name);
  endfunction

endclass

class rst_fully_async_sequence extends rst_sequence;

  `uvm_object_utils(rst_fully_async_sequence)

  constraint rst_fully_async_c {
    assert_mode == rst_item::RST_ASYNC;
    deassert_mode == rst_item::RST_ASYNC;
  }

  function new(string name = "rst_fully_async_sequence");
    super.new(name);
  endfunction

endclass

class rst_sync_posedge_sequence extends rst_sequence;

  `uvm_object_utils(rst_sync_posedge_sequence)

  constraint rst_sync_posedge_c {
    assert_mode == rst_item::RST_SYNC;
    assert_edge == rst_item::RST_POSEDGE;
    deassert_mode == rst_item::RST_SYNC;
    deassert_edge == rst_item::RST_POSEDGE;
  }

  function new(string name = "rst_sync_posedge_sequence");
    super.new(name);
  endfunction

endclass

class rst_sync_negedge_sequence extends rst_sequence;

  `uvm_object_utils(rst_sync_negedge_sequence)

  constraint rst_sync_negedge_c {
    assert_mode == rst_item::RST_SYNC;
    assert_edge == rst_item::RST_NEGEDGE;
    deassert_mode == rst_item::RST_SYNC;
    deassert_edge == rst_item::RST_NEGEDGE;
  }

  function new(string name = "rst_sync_negedge_sequence");
    super.new(name);
  endfunction

endclass

class rst_async_pulse_train_sequence extends rst_sequence;

  `uvm_object_utils(rst_async_pulse_train_sequence)

  constraint rst_async_pulse_train_c {
    assert_mode == rst_item::RST_ASYNC;
    deassert_mode == rst_item::RST_ASYNC;
    num_pulses inside {[3:10]};
    interval_ps inside {[100:1000]};
  }

  function new(string name = "rst_async_pulse_train_sequence");
    super.new(name);
  endfunction

endclass

