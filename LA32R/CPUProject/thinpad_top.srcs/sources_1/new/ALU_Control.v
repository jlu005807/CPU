`timescale 1ns / 1ps

module ALU_Control(
           input wire [3:0] ALU_op,
           input wire [4:0] funct,//其实为OP_CODE截取出来的字段
           output reg [3:0] ALU_ctrl
       );

always @(*) begin
    if(ALU_op == 4'b0000) begin//3R-type
        case(funct)
            5'b00000: ALU_ctrl = 4'b0001; //ADD
            5'b00010: ALU_ctrl = 4'b0010; //SUB
            5'b11000: ALU_ctrl = 4'b0011; //MUL
            5'b01001: ALU_ctrl = 4'b0100; //AND
            5'b01010: ALU_ctrl = 4'b0101; //OR
            5'b01000: ALU_ctrl = 4'b0110; //NOR
            5'b01011: ALU_ctrl = 4'b0111; //XOR
            5'b01110: ALU_ctrl = 4'b1000; //SLL
            5'b01111: ALU_ctrl = 4'b1001; //SRL
            5'b10000: ALU_ctrl = 4'b1010; //SRA
        endcase
    end
    else ALU_ctrl = ALU_op;
end
endmodule
