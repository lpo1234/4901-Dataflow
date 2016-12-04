`include "../../utils.sv"
`include "../../components/simple_arbiter.sv"

`ifndef SIMPLE_ARBITER_WR
`define SIMPLE_ARBITER_WR

module simple_arbiter_wr #(parameter W=8)(
	input logic clk,
	
	input logic[W:0] left_data, output logic left_back_stop,
	input logic[W:0] right_data, output logic right_back_stop,
	input logic[1:0] choose_right, output logic choose_right_back_stop,
	
	output logic[W:0] out_data, input logic down_stop,
	output logic[1:0] chose_right, input logic chose_right_down_stop
);

	wire[W:0] left_data_ib2a;
	wire left_back_stop_a2ib;

	wire[W:0] right_data_ib2a;
	wire right_back_stop_a2ib;

	wire[1:0] choose_right_ib2a;
	wire choose_right_back_stop_a2ib;
	
	wire[W:0] out_data_a2ob;
	wire down_stop_ob2a;
	
	wire[1:0] chose_right_a2ob;
	wire chose_right_down_stop_ob2a;
	
	inbuf #(W) right_data_buf(
		.clk(clk),
		.in_data(right_data),
		.back_stop(right_back_stop),
		.core_data(right_data_ib2a),
		.core_stop(right_back_stop_a2ib)
	);
	
	inbuf #(W) left_data_buf(
		.clk(clk),
		.in_data(left_data),
		.back_stop(left_back_stop),
		.core_data(left_data_ib2a),
		.core_stop(left_back_stop_a2ib)
	);
	
	inbuf #(1) choose_right_buf(
		.clk(clk),
		.in_data(choose_right),
		.back_stop(choose_right_back_stop),
		.core_data(choose_right_ib2a),
		.core_stop(choose_right_back_stop_a2ib)
	);
	
	simple_arbiter #(W) arb(
		.left_data(left_data_ib2a),
		.left_back_stop(left_back_stop_a2ib),
		.right_data(right_data_ib2a),
		.right_back_stop(right_back_stop_a2ib),
		.choose_right(choose_right_ib2a),
		.choose_right_back_stop(choose_right_back_stop_a2ib),
	
		.out_data(out_data_a2ob),
		.down_stop(down_stop_ob2a),
		.chose_right(chose_right_a2ob),
		.chose_right_down_stop(chose_right_down_stop_ob2a)
	);
	
	outbuf #(W) out_data_buf(
		.clk(clk),
		.core_data(out_data_a2ob),
		.core_stop(down_stop_ob2a),
		.out_data(out_data),
		.out_stop(down_stop)
	);
	
	outbuf #(1) chose_right_buf(
		.clk(clk),
		.core_data(chose_right_a2ob),
		.core_stop(chose_right_down_stop_ob2a),
		.out_data(chose_right),
		.out_stop(chose_right_down_stop)
	);

endmodule
	
`endif