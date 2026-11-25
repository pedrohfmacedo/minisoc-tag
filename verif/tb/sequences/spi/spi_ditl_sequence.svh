// Deterministic single-operation sequences for the DITL test.
class spi_ditl_sequence extends spi_sequence_base;
  `uvm_object_utils(spi_ditl_sequence)
  spi_item::spi_op op;
  spi_item::spi_addr addr;
  bit [31:0] data;
  logic [31:0] response;

  function new(string name = "spi_ditl_sequence");
    super.new(name);
  endfunction

  task body();
    spi_item req;
    req = spi_item::type_id::create("req");
    start_item(req);
    req.is_read = op;
    req.addr = addr;
    req.write_data = data;
    req.period_ps = 50000;
    finish_item(req);
    // The existing driver fills read_data before item_done().
    response = req.read_data;
  endtask
endclass