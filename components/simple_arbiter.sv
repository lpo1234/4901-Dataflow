`ifndef SIMPLE_ARBITER
`define SIMPLE_ARBITER

module simple_arbiter #(parameter W=8)(
	input logic[W:0] left_data, output logic left_back_stop,
	input logic[W:0] right_data, output logic right_back_stop,
	input logic[1:0] choose_right, output logic choose_right_back_stop,
	
	output logic[W:0] out_data, input logic down_stop,
	output logic[1:0] chose_right, input logic chose_right_down_stop
);

logic valid_out, cstop;
assign valid_out = choose_right[1] && !down_stop && !chose_right_down_stop &&
						((choose_right[0]&&right_data[W]) || (!choose_right[0]&&left_data[0]));
assign cstop = !valid_out;

assign out_data[W] = valid_out;
assign chose_right[1] = valid_out;

assign out_data[W-1:0] = choose_right[0] ? right_data[W-1:0] : left_data[W-1:0];
assign chose_right[0] = choose_right[0];

assign left_back_stop = cstop;
assign right_back_stop = cstop;
assign choose_right_back_stop = cstop;

endmodule

`endif