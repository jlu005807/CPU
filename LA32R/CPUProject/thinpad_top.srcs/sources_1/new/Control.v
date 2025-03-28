`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2024/11/30 13:35:39
// Design Name:
// Module Name: Control
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

`include"define.vh"


module Control( // 控制单元模块
           input wire[31:15] OP_code,
           output reg RegRead, // 寄存器读源选择信号
           output reg RegDst, // 寄存器目标选择信号
           output reg RegWrite, // 寄存器写使能信号
           output reg ALUsrc, // ALU源选择信号
           output reg[2:0] PCsrc, // 程序计数器源选择信号
           output reg MemRead, // 存储器读使能信号
           output reg MemWrite, // 存储器写使能信号
           output reg[1:0]MemtoReg, // 存储器数据送入寄存器选择信号
           output reg[1:0] ui5From,//sa字段来源
           output reg MemByte, // 字节选择信号
           output reg[1:0] Extension, // 扩展信号
           output reg[3:0] ALUop // ALU操作选择信号
       );

//利用组合逻辑
always @(*) begin
    //3R-type
    if(OP_code[31:20]==`R_type)begin
        RegRead = 1'b0;
        RegDst = 1'b0;
        RegWrite = 1'b1;
        ALUsrc = 1'b0;
        PCsrc = 3'b000;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        MemtoReg = 2'b00;
        ui5From = 2'b00;
        MemByte = 1'b0;
        Extension = 2'b00;
        ALUop = 4'b0000;
    end
    //I-type
    else if(OP_code[31:25]==`I_type)begin
        RegRead=1'b0;
        RegDst = 1'b0;
        RegWrite = 1'b1;
        ALUsrc = 1'b1;
        PCsrc = 3'b000;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        MemtoReg = 2'b00;
        ui5From = 2'b00;
        MemByte = 1'b0;
        Extension = 2'b00;
        case(OP_code[24:22])
            `SLTI:begin
                Extension = 2'b01;
                ALUop = 4'b1100;
            end
            `SLTUI:begin
                ALUop = 4'b1011;
            end
            `ADDI_W:begin
                Extension = 2'b01;
                ALUop = 4'b0001;
            end
            `ANDI:begin
                ALUop = 4'b0100;
            end
            `ORI:begin
                ALUop = 4'b0101;
            end
            `XORI:begin
                ALUop = 4'b0111;
            end
        endcase
    end
    //Load and Store
    else if(OP_code[31:25]==`LOS)begin
        case(OP_code[24:22])
            `LD_B:begin
                RegRead=1'b0;
                RegDst = 1'b0;
                RegWrite = 1'b1;
                ALUsrc = 1'b1;
                PCsrc = 3'b000;
                MemRead = 1'b1;
                MemWrite = 1'b0;
                MemtoReg = 2'b01;
                ui5From = 2'b00;
                MemByte = 1'b1;
                Extension = 2'b00;
                ALUop = 4'b0001;
            end
            `LD_W:begin
                RegRead=1'b0;
                RegDst = 1'b0;
                RegWrite = 1'b1;
                ALUsrc = 1'b1;
                PCsrc = 3'b000;
                MemRead = 1'b1;
                MemWrite = 1'b0;
                MemtoReg = 2'b01;
                ui5From = 2'b00;
                MemByte = 1'b0;
                Extension = 2'b00;
                ALUop = 4'b0001;
            end
            `ST_B:begin
                RegRead=1'b1;
                RegDst = 1'b0;
                RegWrite = 1'b0;
                ALUsrc = 1'b1;
                PCsrc = 3'b000;
                MemRead = 1'b0;
                MemWrite = 1'b1;
                MemtoReg = 2'b00;
                ui5From = 2'b00;
                MemByte = 1'b1;
                Extension = 2'b00;
                ALUop = 4'b0001;
            end
            `ST_W:begin
                RegRead=1'b1;
                RegDst = 1'b0;
                RegWrite = 1'b0;
                ALUsrc = 1'b1;
                PCsrc = 3'b000;
                MemRead = 1'b0;
                MemWrite = 1'b1;
                MemtoReg = 2'b00;
                ui5From = 2'b00;
                MemByte = 1'b0;
                Extension = 2'b00;
                ALUop = 4'b0001;
            end
        endcase
    end
    //移位指令
    else if(OP_code[31:20]==`PRE && OP_code[17:15]==`POST)begin
        RegRead=1'b0;
        RegDst = 1'b0;
        RegWrite = 1'b1;
        ALUsrc = 1'b1;
        PCsrc = 3'b000;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        MemtoReg = 2'b00;
        ui5From = 2'b01;
        MemByte = 1'b0;
        Extension = 2'b00;
        case(OP_code[19:18])
            `SLLI_W:ALUop=4'b1000;
            `SRLI_W:ALUop=4'b1001;
            `SRAI_W:ALUop=4'b1010;
        endcase
    end
    //LU12I
    else if(OP_code[31:25]==`LU12I)begin
        RegRead=1'b0;
        RegDst = 1'b0;
        RegWrite = 1'b1;
        ALUsrc = 1'b1;
        PCsrc = 3'b000;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        MemtoReg = 2'b00;
        ui5From = 2'b10;
        MemByte = 1'b0;
        Extension = 2'b11;
        ALUop = 4'b1000;
    end
    //NOP
    else if(OP_code == 17'b0) begin
        RegRead=1'b0;
        RegDst = 1'b0;
        RegWrite = 1'b0;
        ALUsrc = 1'b0;
        PCsrc = 3'b000;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        MemtoReg = 2'b00;
        ui5From = 2'b00;
        MemByte = 1'b0;
        Extension = 2'b00;
        ALUop = 4'b0000;       
    end
    //转移指令
    else begin
        RegRead=1'b1;
        RegDst = 1'b0;
        RegWrite = 1'b0;
        ALUsrc = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        MemtoReg = 2'b00;
        ui5From = 2'b00;
        MemByte = 1'b0;
        Extension = 2'b10;
        ALUop = 4'b0010;
        case(OP_code[31:26])
            `JIRL:begin
                RegRead=1'b0;
                RegDst = 1'b0;
                RegWrite = 1'b1;
                ALUsrc = 1'b1;
                PCsrc = 3'b111;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                MemtoReg = 2'b10;
                ui5From = 2'b00;
                MemByte = 1'b0;
                Extension = 2'b10;
                ALUop = 4'b0001;
            end
            `BL:begin
                RegRead=1'b0;
                RegDst = 1'b1;
                RegWrite = 1'b1;
                ALUsrc = 1'b0;
                PCsrc = 3'b000;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                MemtoReg = 2'b10;
                ui5From = 2'b00;
                MemByte = 1'b0;
                Extension = 2'b00;
                ALUop = 4'b0000;
            end
            `B:begin
                RegRead=1'b0;
                RegDst = 1'b0;
                RegWrite = 1'b0;
                ALUsrc = 1'b0;
                PCsrc = 3'b000;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                MemtoReg = 2'b00;
                ui5From = 2'b00;
                MemByte = 1'b0;
                Extension = 2'b00;
                ALUop = 4'b0000;
            end
            `BEQ:begin
                PCsrc = 3'b001;
            end
            `BNE:begin
                PCsrc = 3'b010;
            end
            `BLT:begin
                PCsrc = 3'b011;
            end
            `BGE:begin
                PCsrc = 3'b100;
            end
            `BLTU:begin
                PCsrc = 3'b101;
            end
            `BGEU:begin
                PCsrc = 3'b101;
            end
        endcase
    end
end

endmodule
