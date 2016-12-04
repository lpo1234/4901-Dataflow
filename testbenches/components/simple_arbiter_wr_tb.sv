

module simple_arbiter_wr_tb();
	parameter F=8;
	logic clk;
	
	logic[F:0] left_data;
	/**/logic left_back_stop;
	logic[F:0] right_data;
	/**/logic right_back_stop;
	logic[1:0] choose_right;
	/**/logic choose_right_back_stop;
	
	logic[F:0] out_data;
	/**/logic down_stop;
	logic[1:0] chose_right;
	/**/logic chose_right_down_stop;
	
	simple_arbiter_wr saw(
		.clk,
		.left_data(left_data),
		.left_back_stop(left_back_stop),
		.right_data(right_data),
		.right_back_stop(right_back_stop),
		.choose_right(choose_right),
		.choose_right_back_stop(choose_right_back_stop),
		.out_data(out_data),
		.down_stop(down_stop),
		.chose_right(chose_right),
		.chose_right_down_stop(chose_right_down_stop)
	);

	initial begin
		clk = 0;
		forever begin
			#20ns clk = 1;
			#20ns clk = 0;
		end
	end
	
	initial begin
		
		repeat(1) @(posedge clk); #7ns;	
		down_stop = 1'b0;
		chose_right_down_stop = 1'b0;
		left_data = {1'b1, {F{1'bx}}};
		right_data = {1'b0, {F{1'b0}}};
		choose_right = 2'b0;
		
		repeat(1) @(posedge clk); #7ns;	
		choose_right = 2'b11;
		right_data = {1'b1, {F{1'b1}}};
		
		repeat(2) @(posedge clk); #7ns;	
		down_stop = 1'b0;
		chose_right_down_stop = 1'b0;
		left_data = {1'bx, {F{1'bx}}};
		right_data = {1'b0, {F{1'b0}}};
		choose_right = 2'b0;
		
		repeat(1) @(posedge clk); #7ns;	
		choose_right = 2'b11;
		left_data = 9'b110100101;
		right_data = {1'b0, {F{1'b0}}};
		chose_right_down_stop = 1'b1;
	
	end
	

endmodule 