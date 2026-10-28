interface clk_if;
	timeunit 1ps; timeprecision 1ps;
	// iniciando um clock em um estado conhecido...
	logic clk;

	modport driver (
		output clk
	);

	modport monitor (
		input clk
	);
	
endinterface
