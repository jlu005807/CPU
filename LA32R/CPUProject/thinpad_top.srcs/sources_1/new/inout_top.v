`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2024/12/05 16:14:15
// Design Name:
// Module Name: inout_top
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


module inout_top(
           input[31:0] I_data_in,
           inout[31:0] IO_data,
           output[31:0] O_data_out,
           input wire control
       );

assign IO_data = (control==1'b1)? I_data_in : 32'bz;
assign O_data_out = IO_data;

endmodule
