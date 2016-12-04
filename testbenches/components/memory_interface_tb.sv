
`include "../../utils.sv"
`include "../../components/wrapped/mem_interface_wr.sv"

module memory_interface_tb();

logic clk;

logic[ADDR_LENGTH:0] addr1; logic addr1_stop;
logic[MEM_ENTRY_LENGTH:0] in_data1; logic in_data1_stop;
logic[1:0] wren1; logic wren1_stop;
logic[MEM_ENTRY_LENGTH:0] out_data1; logic down_stop1;

logic[ADDR_LENGTH:0] addr2; logic addr2_stop;
logic[MEM_ENTRY_LENGTH:0] in_data2; logic in_data2_stop;
logic[1:0] wren2; logic wren2_stop;
logic[MEM_ENTRY_LENGTH:0] out_data2; logic down_stop2;

mem_interface_wr mi(.*);


initial begin
	clk = 0;
	forever begin
		#20ns clk = 1;
		#20ns clk = 0;
	end
end

	
initial begin
	
	repeat(1) @(posedge clk);
	addr1 = {1'b0, {ADDR_LENGTH{1'b0}}};
	in_data1 = {1'b0, {MEM_ENTRY_LENGTH{1'b0}}};
	wren1 = {1'b0, 1'b0};
	down_stop1 = 1'b0;
	addr2 = {1'b0, {ADDR_LENGTH{1'b0}}};
	in_data2 = {1'b0, {MEM_ENTRY_LENGTH{1'b0}}};
	wren2 = {1'b0, 1'b0};
	down_stop2 = 1'b0;
	
	repeat(1) @(posedge clk);
	addr1 = {1'b1, 5'd22};
	in_data1 = {1'b1, 16'hACDC};
	wren1 = {1'b1, 1'b1};
	
	repeat(1) @(posedge clk);
	addr1 = {1'b0, {ADDR_LENGTH{1'b0}}};
	in_data1 = {1'b0, {MEM_ENTRY_LENGTH{1'b0}}};
	wren1 = {1'b0, 1'b0};
	down_stop1 = 1'b0;
	
	repeat(1) @(posedge clk);
	addr2 = {1'b1, 5'd22};
	repeat(1) @(posedge clk);
	addr2 = {1'b0, 5'd22};
	in_data2 = {1'b1, 16'hACDC};
	repeat(1) @(posedge clk);
	in_data2 = {1'b0, 16'hACDC};
	repeat(3) @(posedge clk);
	wren2 = {1'b1, 1'b0};
	repeat(1) @(posedge clk);
	wren2 = {1'b0, 1'b0};
	

end


endmodule 