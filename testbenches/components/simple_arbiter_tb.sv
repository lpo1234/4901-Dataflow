

module simple_arbiter_tb();
	
	logic clk;
	
	logic[8:0] left_data;
	/**/logic left_back_stop;
	logic[8:0] right_data;
	/**/logic right_back_stop;
	logic[1:0] choose_right;
	/**/logic choose_right_back_stop;
	
	logic[8:0] out_data;
	/**/logic down_stop;
	logic[1:0] chose_right;
	/**/logic chose_right_down_stop;
	
	simple_arbiter sa(.*);
	
	initial begin
		clk = 0;
		forever begin
			#20ns clk = 1;
			#20ns clk = 0;
		end
	end
	
	initial begin
		
		repeat(1) @(posedge clk); #7ns;	
		left_data[8:0] <= 9'b0xxxxxxxx;
		right_data[8:0] <= 9'b0;
		choose_right[1:0] <= 2'b0;
		down_stop <= 1'b0;
		chose_right_down_stop <= 1'b0;
		
		repeat(2) @(posedge clk);
		right_data[8:0] <= 9'h10F;
		choose_right[1:0] <= 2'b11;
		
		repeat(2) @(posedge clk);
		left_data[8:0] <= 9'b0xxxxxxxx;
		right_data[8:0] <= 9'b0;
		choose_right[1:0] <= 2'b11;
		
		repeat(1) @(posedge clk);
		right_data <= 9'h1AC;
		chose_right_down_stop <= 1'b1;
		
	end
	
	
	
endmodule 