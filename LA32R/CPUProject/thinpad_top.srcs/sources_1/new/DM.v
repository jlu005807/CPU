`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/05 14:29:21
// Design Name: 
// Module Name: DM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DM(
    input wire Address,
    input wire Write_data,
    input wire MemRead,
    input wire MemWrite,
    output reg [31:0] Read_data
    );
endmodule
