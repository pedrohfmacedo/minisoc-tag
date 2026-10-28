interface rst_if(input logic clk);
	logic rst_n;

	// driver altera apenas na borda de descida do clock
	clocking driver_cb @(negedge clk);
		output rst_n;
	endclocking

	// driver altera apenas na borda de subida do clock
	clocking monitor_cb @(posedge clk);
		input rst_n;
	endclocking

	modport driver (
		clocking driver_cb
	);

	modport monitor (
		clocking monitor_cb
	);
endinterface
