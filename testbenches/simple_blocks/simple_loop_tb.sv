`include "../../utils.sv"
`include "../../components/wrapped/simple_arbiter_wr.sv"
`include "../../components/wrapped/simple_demux_wr.sv"
`include "../../components/simple_demux.sv"


module simple_loop_tb();


logic clk;
int failed;

//MUX	
logic[GO_LENGTH:0] left_data_in; logic left_back_stop;
logic[GO_LENGTH:0] right_data_in; logic right_back_stop;
logic[1:0] choose_right; logic choose_right_back_stop;
logic[GO_LENGTH:0] out_data_from_mx; logic down_stop_to_mx;
logic[1:0] chose_right; logic chose_right_down_stop;


//DEMUX
//logic[GO_LENGTH:0] in_data; logic back_stop;
logic[1:0] go_right; logic go_right_back_stop;
//logic[GO_LENGTH:0] left_path; logic left_path_back_stop;
logic[GO_LENGTH:0] right_path; logic right_path_back_stop;


simple_arbiter_wr #(GO_LENGTH) saw(
	.clk(clk),
	.left_data(left_data_in),
	.left_back_stop(left_back_stop),
	.right_data(right_data_in),
	.right_back_stop(right_back_stop),
	.choose_right(choose_right),
	.choose_right_back_stop(choose_right_back_stop),
	.out_data(out_data_from_mx),
	.down_stop(down_stop_to_mx),
	.chose_right(chose_right),
	.chose_right_down_stop(chose_right_down_stop)
);

simple_demux_wr #(GO_LENGTH) dmxw(
	.clk(clk),
	.in_data(out_data_from_mx),
	.back_stop(down_stop_to_mx),
	.go_right(go_right),
	.go_right_back_stop(go_right_back_stop),
	.left_path(left_data_in),
	.left_path_back_stop(left_back_stop),
	.right_path(right_path),
	.right_path_back_stop(right_path_back_stop)
);

initial begin
	clk = 0;
	failed = 0;
	forever begin
		#20ns clk = 1;
		#20ns clk = 0;
	end
end

initial begin

	repeat(1) @(posedge clk); #7ns;
	right_data_in = {1'b0, {GO_LENGTH{1'b0}}};; 
	choose_right = {1'b0, 1'b0}; 
	go_right = {1'b0, 1'b0}; 
	right_path_back_stop = 1'b0;
	chose_right_down_stop = 1'b0;

	repeat(4) @(posedge clk); #7ns;
	choose_right = 2'b11;
	repeat(1) @(posedge clk); #7ns;
	choose_right = 2'b10;
	
	repeat(1) @(posedge clk); #7ns;
	right_data_in = {1'b1, GO_SIGNAL};
	
	repeat(1) @(posedge clk); #7ns;
	right_data_in = {1'b0, GO_SIGNAL};
	
	repeat(3) @(posedge clk); #7ns;
	go_right = {1'b1, 1'b0};
	
end




endmodule