module outbuf #(parameter W=8) (
	input clk,
	input logic[W:0] core_data, output logic core_stop,
	output reg[W:0] out_data, input logic out_stop
);

	initial out_data = {1'b0, {W{1'b0}}};
	
//	assign core_stop = out_data[W] && out_stop;
	
	always_comb
		if(out_data[W] && out_stop)
			core_stop = 1'b1;
		else 
			core_stop = 1'b0;
	
	always @(posedge clk)
		if(!core_stop)
			out_data <= core_data;
			
endmodule