//R-type
`define R_type 6'b000000

//`sepcial R-type instructions
`define MUL 6'b011100


//I-type
`define ADDIU 6'b001001
`define ANDI 6'b001100
`define LUI 6'b001111
`define ORI 6'b001101
`define XORI 6'b001110
`define BEQ 6'b000100
`define BNE 6'b000101
`define BGTZ 6'b000111
`define LB 6'b100000
`define LW 6'b100011
`define SB 6'b101000
`define SW 6'b101011

//J-type
`define J 6'b000010
`define JAL 6'b000011