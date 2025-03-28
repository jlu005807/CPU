`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2024/11/28 16:16:10
// Design Name:
// Module Name: ALU
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


module ALU(
           input wire [7:0] ALU_ctrl,
           input wire [4:0] sa,
           input wire [31:0] OP1,
           input wire [31:0] OP2,
           output wire [31:0] ALU_OUT
       );
       reg[31:0] result;


       always @(*) begin
        case (ALU_ctrl)
          8'b0000_0001: result = OP1 + OP2;
          8'b0000_0010: result = OP1 - OP2;
          8'b0000_0100: result = $signed(OP1) * $signed(OP2);
          8'b0000_1000: result = OP1 & OP2;
          8'b0001_0000: result = OP1 | OP2;
          8'b0010_0000: result = OP1 ^ OP2;
          8'b0100_0000: result = OP2 << sa;
          8'b1000_0000: result = OP2 >> sa;
          default: result = 32'b0;
        endcase
       end   
       assign ALU_OUT = result;
endmodule
