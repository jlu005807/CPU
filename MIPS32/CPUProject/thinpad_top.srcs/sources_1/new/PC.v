`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/05 14:09:35
// Design Name: 
// Module Name: PC
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


module PC(
    input wire clk,
    input wire flush,
    input wire STALL,
    input wire reset,
    input wire [31:0] npc,
    input wire[31:0] correct_pc,
    output wire [31:0] PC
    );
reg [31:0]temp_pc;
always @(posedge clk) begin
    if(reset)
      temp_pc<=32'h80400000;
    else if(flush)
      temp_pc<=correct_pc;
    else if(STALL)
      temp_pc<=temp_pc;
    else 
      temp_pc<=npc;
end
    
assign PC = temp_pc;
endmodule
