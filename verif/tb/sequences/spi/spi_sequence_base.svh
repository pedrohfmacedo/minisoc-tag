
class spi_sequence_base extends uvm_sequence #(spi_item);

  `uvm_object_utils(spi_sequence_base)

  // Constructor
  function new(string name = "spi_sequence_base");
    super.new(name);
  endfunction

  // SPI WRITE
  task send_write(
    input bit [5:0] addr,
    input bit [31:0] write_data,
    input int unsigned period_ps = 40000
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

  // SPI READ
  task send_read(
    input bit [5:0] addr,
    input int unsigned period_ps = 40000
  );

    spi_item req;

    req = spi_item::type_id::create("req");

    start_item(req);

    req.is_read    = spi_item::SPI_READ;
    req.addr       = spi_item::spi_addr'(addr);
    req.write_data = 32'b0;
    req.period_ps  = period_ps;

    finish_item(req);

  endtask

endclass
