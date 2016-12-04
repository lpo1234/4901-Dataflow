`include "../../utils.sv"
//`include "../simple_demux.sv"

`ifndef SIMPLE_DEMUX_WR
`define SIMPLE_DEMUX_WR

module simple_demux_wr #(parameter W=GO_LENGTH)(
	input logic clk,
	input logic[W:0] in_data, output logic back_stop,
	input logic[1:0] go_right, output logic go_right_back_stop,
	
	output logic[W:0] left_path, input logic left_path_back_stop,
	output logic[W:0] right_path, input logic right_path_back_stop
);

//incoming data wires
wire[W:0] in_data_b2d;
wire back_stop_d2b;

//incoming select wires
wire[1:0] go_right_b2d;
wire go_right_back_stop_d2b;

//going down left path
wire[W:0] left_path_d2b;
wire left_path_back_stop_b2d;

//going down right path
wire[W:0] right_path_d2b;
wire right_path_back_stop_b2d;

inbuf #(W) data_buf(
	.clk(clk),
	.in_data(in_data),
	.back_stop(back_stop),
	.core_data(in_data_b2d),
	.core_stop(back_stop_d2b)
);

inbuf #(1) go_right_buf(
	.clk(clk),
	.in_data(go_right),
	.back_stop(go_right_back_stop),
	.core_data(go_right_b2d),
	.core_stop(go_right_back_stop_d2b)
);

simple_demux #(W) sdmx(
	.in_data(in_data_b2d),
	.back_stop(back_stop_d2b),
	.go_right(go_right_b2d),
	.go_right_back_stop(go_right_back_stop_d2b),
	.left_path(left_path_d2b),
	.left_path_back_stop(left_path_back_stop_b2d),
	.right_path(right_path_d2b),
	.right_path_back_stop(right_path_back_stop_b2d)
);

outbuf #(W) right_buf(
	.clk(clk),
	.core_data(right_path_d2b),
	.core_stop(right_path_back_stop_b2d),
	.out_data(right_path),
	.out_stop(right_path_back_stop)
);

outbuf #(W) left_buf(
	.clk(clk),
	.core_data(left_path_d2b),
	.core_stop(left_path_back_stop_b2d),
	.out_data(left_path),
	.out_stop(left_path_back_stop)
);	
	
endmodule

`endif