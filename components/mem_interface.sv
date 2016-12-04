
`include "../utils.sv"
//`include "../memory_generated/mymem.v"

module mem_interface(
	input logic clk,
	
	input logic[ADDR_LENGTH:0] addr1, output logic addr1_stop,
	input logic[MEM_ENTRY_LENGTH:0] in_data1, output logic in_data1_stop,
	input logic[1:0] wren1, output logic wren1_stop,
	output logic[MEM_ENTRY_LENGTH:0] out_data1, input logic down_stop1,
	
	input logic[ADDR_LENGTH:0] addr2, output logic addr2_stop,
	input logic[MEM_ENTRY_LENGTH:0] in_data2, output logic in_data2_stop,
	input logic[1:0] wren2, output logic wren2_stop,
	output logic[MEM_ENTRY_LENGTH:0] out_data2, input logic down_stop2
);

logic working1, working2;
initial working1 = 1'b0;
initial working2 = 1'b0;

logic[15:0] rand_num_gen;
logic[3:0] delay1, counter1;
logic[3:0] delay2, counter2;

rand_num_generator rng(
	.clk(clk),
	.out(rand_num_gen)
);

logic[ADDR_LENGTH-1:0]  address_as;
logic[MEM_ENTRY_LENGTH-1:0]  data_as;
logic wren_as;
logic[MEM_ENTRY_LENGTH-1:0]  q_as;

logic[ADDR_LENGTH-1:0]  address_bs;
logic[MEM_ENTRY_LENGTH-1:0]  data_bs;
logic wren_bs;
logic[MEM_ENTRY_LENGTH-1:0]  q_bs;

small_mem	small_mem_inst (
	.address_a ( address_as ),
	.address_b ( address_bs ),
	.clock ( clk ),
	.data_a ( data_as ),
	.data_b ( data_bs ),
	.wren_a ( wren_as ),
	.wren_b ( wren_bs ),
	.q_a ( q_as ),
	.q_b ( q_bs )
);
	
logic backpressure1;
initial backpressure1 = 1'b0;
assign addr1_stop = backpressure1;
assign in_data1_stop = backpressure1;
assign wren1_stop = backpressure1;

logic backpressure2;
initial backpressure2 = 1'b0;
assign addr2_stop = backpressure2;
assign in_data2_stop = backpressure2;
assign wren2_stop = backpressure2;

//PROCESSING LOOP FOR PORT 1
always_ff @(posedge clk) begin
	if(!working1) begin // if we're idle
		out_data1[MEM_ENTRY_LENGTH] <= 1'b0;
		if(addr1[ADDR_LENGTH] && in_data1[MEM_ENTRY_LENGTH] && wren1[1]) begin
			//now we send data over to the memory
			//and await a response by moving to 
			//the working state :)
			working1 <= 1'b1;;
			address_as <= addr1[ADDR_LENGTH-1:0];
			data_as <= in_data1[MEM_ENTRY_LENGTH-1:0];
			wren_as <= wren1[0];
			backpressure1 <= 1'b0; //set backpressure down to tell upstream we got it
			delay1 <= 4'h3 + {1'b0, rand_num_gen[2:0]};
			counter1 <= 4'b0;
		end else begin
			backpressure1 <= 1'b1; //don't accept any inputs until all inputs are ready
		end	
	end else begin
		//now we're in the working state!
		backpressure1 <= 1'b1; //put backpressure back up to stop new inputs from coming!
		if(counter1 <= delay1) begin
			counter1 <= counter1 + 4'b0001;
		end else if(!down_stop1) begin
			//we have delayed enough! Output data and go back!
			out_data1[MEM_ENTRY_LENGTH] <= 1'b1;
			working1 <= 1'b0;
			out_data1[MEM_ENTRY_LENGTH-1:0] <= q_as;
		end
	end
end

//PROCESSING LOOP FOR PORT 2
always_ff @(posedge clk) begin
	if(!working2) begin // if we're idle
		out_data2[MEM_ENTRY_LENGTH] <= 1'b0;
		if(addr2[ADDR_LENGTH] && in_data2[MEM_ENTRY_LENGTH] && wren2[1]) begin
			//now we send data over to the memory
			//and await a response by moving to 
			//the working state :)
			working2 <= 1'b1;
			address_bs <= addr2[ADDR_LENGTH-1:0];
			data_bs <= in_data2[MEM_ENTRY_LENGTH-1:0];
			wren_bs <= wren2[0];
			backpressure2 <= 1'b0;
			delay2 <= 4'h3 + {1'b0, rand_num_gen[2:0]};
			counter2 <= 4'b0;
		end else begin
			backpressure2 <= 1'b1;
		end	
	end else begin
		//now we're in the working state!
		backpressure2 <= 1'b1;
		if(counter2 <= delay2) begin
			counter2 <= counter2 + 4'b0001;
		end else if(!down_stop2) begin
			//we have delayed enough! Output data and go back!
			out_data2[MEM_ENTRY_LENGTH] <= 1'b1;
			working2 <= 1'b0;
			out_data2[MEM_ENTRY_LENGTH-1:0] <= q_as;
		end
	end
end


endmodule