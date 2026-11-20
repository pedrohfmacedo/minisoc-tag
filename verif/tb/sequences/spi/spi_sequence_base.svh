
class spi_sequence_base extends uvm_sequence #(spi_item);

  `uvm_object_utils(spi_sequence_base)

  function new(string name = "spi_sequence_base");
    super.new(name);
  endfunction

  task send_write(
    bit [5:0] addr,
    bit [31:0] write_data,
    int unsigned period_ps = 40000
  );

    spi_item req;

    req = spi_item::type_id::create("req");

    start_item(req);

    req.is_read    = spi_item::SPI_WRITE;
    req.addr       = spi_item::spi_addr'(addr);
    req.write_data = write_data;
    req.period_ps  = period_ps;

    finish_item(req);

  endtask

  task send_read(
    bit [5:0] addr,
    int unsigned period_ps = 40000
  );

    spi_item req;

    req = spi_item::type_id::create("req");

    start_item(req);

    req.is_read    = spi_item::SPI_READ;
    req.addr       = spi_item::spi_addr'(addr);
    req.write_data = '0;
    req.period_ps  = period_ps;

    finish_item(req);

  endtask

endclass
