
`include "../../utils.sv"

`ifndef MEM_INTERFACE_WR
`define MEM_INTERFACE_WR

module mem_interface_wr(
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

wire[ADDR_LENGTH:0] addr1_b2m, addr2_b2m;
wire addr1_stop_m2b, addr2_stop_m2b;

wire[MEM_ENTRY_LENGTH:0] in_data1_b2m, in_data2_b2m;
wire in_data1_stop_m2b, in_data2_stop_m2b;

wire[1:0] wren1_b2m, wren2_b2m;
wire wren1_stop_m2b, wren2_stop_m2b;

wire[MEM_ENTRY_LENGTH:0] out_data1_m2b, out_data2_m2b;
wire down_stop1_b2m, down_stop2_b2m;

inbuf #(ADDR_LENGTH) addr_buf1(
	.clk(clk),
	.in_data(addr1),
	.back_stop(addr1_stop),
	.core_data(addr1_b2m),
	.core_stop(addr1_stop_m2b)
);

inbuf #(MEM_ENTRY_LENGTH) in_data_buf1(
	.clk(clk),
	.in_data(in_data1),
	.back_stop(in_data1_stop),
	.core_data(in_data1_b2m),
	.core_stop(in_data1_stop_m2b)
);

inbuf #(1) wren_buf1(
	.clk(clk),
	.in_data(wren1),
	.back_stop(wren1_stop),
	.core_data(wren1_b2m),
	.core_stop(wren1_stop_m2b)
);

outbuf #(MEM_ENTRY_LENGTH) out_data_buf1(
	.clk(clk),
	.core_data(out_data1_m2b),
	.core_stop(down_stop1_b2m),
	.out_data(out_data1),
	.out_stop(down_stop1)
);
	
/********************************
 ***   NOW FOR THE 2ND PORT   ***	
 ********************************/
inbuf #(ADDR_LENGTH) addr_buf2(
	.clk(clk),
	.in_data(addr2),
	.back_stop(addr2_stop),
	.core_data(addr2_b2m),
	.core_stop(addr2_stop_m2b)
);

inbuf #(MEM_ENTRY_LENGTH) in_data_buf2(
	.clk(clk),
	.in_data(in_data2),
	.back_stop(in_data2_stop),
	.core_data(in_data2_b2m),
	.core_stop(in_data2_stop_m2b)
);

inbuf #(1) wren_buf2(
	.clk(clk),
	.in_data(wren2),
	.back_stop(wren2_stop),
	.core_data(wren2_b2m),
	.core_stop(wren2_stop_m2b)
);

outbuf #(MEM_ENTRY_LENGTH) out_data_buf2(
	.clk(clk),
	.core_data(out_data2_m2b),
	.core_stop(down_stop2_b2m),
	.out_data(out_data2),
	.out_stop(down_stop2)
);	

/********************************
 * NOW FOR THE ACTUAL INTERFACE *	
 ********************************/
mem_interface interf(
	.clk(clk),
	
	.addr1(addr1_b2m),
	.addr1_stop(addr1_stop_m2b),
	.in_data1(in_data1_b2m),
	.in_data1_stop(in_data1_stop_m2b),
	.wren1(wren1_b2m),
	.wren1_stop(wren1_stop_m2b),
	.out_data1(out_data1_m2b),
	.down_stop1(down_stop1_b2m),
	
	.addr2(addr2_b2m),
	.addr2_stop(addr2_stop_m2b),
	.in_data2(in_data2_b2m),
	.in_data2_stop(in_data2_stop_m2b),
	.wren2(wren2_b2m),
	.wren2_stop(wren2_stop_m2b),
	.out_data2(out_data2_m2b),
	.down_stop2(down_stop2_b2m)
);


endmodule

`endif