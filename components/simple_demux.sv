`ifndef SIMPLE_DEMUX
`define SIMPLE_DEMUX

module simple_demux #(parameter W=8)(
	input logic[W:0] in_data, output logic back_stop,
	input logic[1:0] go_right, output logic go_right_back_stop,
	
	output logic[W:0] left_path, input logic left_path_back_stop,
	output logic[W:0] right_path, input logic right_path_back_stop
);

logic cstop;
assign left_path[W]  = go_right[1] && !go_right[0] && in_data[W] && !left_path_back_stop;
assign right_path[W] = go_right[1] &&  go_right[0] && in_data[W] && !right_path_back_stop;
assign cstop = !(left_path[W] || right_path[W]);

assign back_stop = cstop;
assign go_right_back_stop = cstop;

assign left_path[W-1:0]  = in_data[W-1:0];
assign right_path[W-1:0] = in_data[W-1:0];

endmodule

`endif