interface clk_if;
	// iniciando um clock em um estado conhecido...
	logic clk;

	modport driver (
		output clk
	);

	modport monitor (
		input clk
	);
	
endinterface
