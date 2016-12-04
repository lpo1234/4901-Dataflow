//Code originally implemented by Cao, Ross, Kim, Edwards

module inbuf #(parameter W=8) (
	input clk,
	input logic[W:0] in_data, output logic back_stop,
	output logic[W:0] core_data, input logic core_stop
);

	logic[W:0] storage = {1'b0, {W{1'bx}}};
	
//	assign back_stop = storage[W];
//	assign core_data = back_stop ? storage : in_data;
	
	always_comb
		if(storage[W] == 1'b1)
			back_stop = 1'b1;
		else 
			back_stop = 1'b0;
	
	always_comb
		if(storage[W] == 1'b1)
			core_data <= storage;
		else
			core_data <= in_data;
	
	
	
	
	always @(posedge clk)
		if(!core_stop && storage[W])
			storage <= {1'b0, {W{1'bx}}};
		else if (core_stop && !storage[W])
			storage <= in_data;
			
endmodule