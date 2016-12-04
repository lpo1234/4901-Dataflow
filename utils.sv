`ifndef UTILS
`define UTILS


parameter GO_LENGTH = 8;
parameter GO_SIGNAL = 8'hFF;

/*
	MEMORY ENTRY:
	16 bits. First 3 are encoding. Next 5 are pointer to next data. Next 8 are data.

	E  E  E  P  P  P  P  W  W  W  W  W  W  W  W  W
	15 14 13 12 11 10 9  8  7  6  5  4  3  2  1  0

 */
parameter ENCODING_LENGTH = 3;
parameter ADDR_LENGTH = 5;
parameter WORD_LENGTH = 8;
parameter MEM_ENTRY_LENGTH = 16;



`endif