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
           input wire IS_JR, // 是否为JR指令
           input wire[5:0] OP_code, // 操作码
           output reg[2:0] RegDst, // 寄存器目标选择信号
           output reg RegWrite, // 寄存器写使能信号
           output reg[1:0] ALUsrc, // ALU源选择信号
           output reg[2:0] PCsrc, // 程序计数器源选择信号
           output reg MemRead, // 存储器读使能信号
           output reg MemWrite, // 存储器写使能信号
           output reg[1:0]MemtoReg, // 存储器数据送入寄存器选择信号
           output reg SaFrom,//sa字段来源
           output reg MemByte, // 字节选择信号
           output reg[1:0] Extension, // 扩展信号
           output reg[3:0] ALUop // ALU操作选择信号
       );

always @(*) begin
    if (IS_JR) begin //如果是JR指令
        RegDst = 2'b00; // 寄存器目标选择信号为00
        RegWrite = 1'b0; // 寄存器写使能信号为0
        ALUsrc = 2'b00; // ALU源选择信号为00
        PCsrc = 3'b101; // 程序计数器源选择信号为1
        MemRead = 1'b0; // 存储器读使能信号为0
        MemWrite = 1'b0; // 存储器写使能信号为0
        MemtoReg = 2'b00; // 存储器数据送入寄存器选择信号为00
        SaFrom = 1'b0; //sa字段来源为0
        MemByte = 1'b0; // 字节选择信号为0
        Extension = 2'b00; // 扩展信号为00
        ALUop = 4'b0000; // ALU操作选择信号为0000
    end else begin
        case (OP_code)
            `R_type: begin //R-type指令
                RegDst = 2'b01; // 寄存器目标选择信号为01
                RegWrite = 1'b1; // 寄存器写使能信号为1
                ALUsrc = 2'b00; // ALU源选择信号为00
                PCsrc = 3'b0; // 程序计数器源选择信号为0
                MemRead = 1'b0; // 存储器读使能信号为0
                MemWrite = 1'b0; // 存储器写使能信号为0
                MemtoReg = 2'b00; // 存储器数据送入寄存器选择信号为00
                SaFrom = 1'b0; //sa字段来源为0
                MemByte = 1'b0; // 字节选择信号为0
                Extension = 2'b00; // 扩展信号为00
                ALUop = 4'b1000;// ALU操作选择信号为1000
            end
            `ADDIU: begin //ADDIU指令
                RegDst = 2'b00; // 寄存器目标选择信号为00
                RegWrite = 1'b1; // 寄存器写使能信号为1
                ALUsrc = 2'b01; // ALU源选择信号为01
                PCsrc = 3'b0; // 程序计数器源选择信号为0
                MemRead = 1'b0; // 存储器读使能信号为0
                MemWrite = 1'b0; // 存储器写使能信号为0
                MemtoReg = 2'b00; // 存储器数据送入寄存器选择信号为00
                SaFrom = 1'b0; //sa字段来源为0
                MemByte = 1'b0; // 字节选择信号为0
                Extension = 2'b01; // 扩展信号为00
                ALUop = 4'b0001; // ALU操作选择信号为0001
            end
            `MUL: begin //MUL指令
                RegDst = 2'b01; // 寄存器目标选择信号为01
                RegWrite = 1'b1; // 寄存器写使能信号为1
                ALUsrc = 2'b00; // ALU源选择信号为00
                PCsrc = 3'b0; // 程序计数器源选择信号为0
                MemRead = 1'b0; // 存储器读使能信号为0
                MemWrite = 1'b0; // 存储器写使能信号为0
                MemtoReg = 2'b00; // 存储器数据送入寄存器选择信号为00
                SaFrom = 1'b0; //sa字段来源为0
                MemByte = 1'b0; // 字节选择信号为0
                Extension = 2'b00; // 扩展信号为00
                ALUop = 4'b0011; // ALU操作选择信号为0011
            end
            `ANDI: begin //ANDI指令
                RegDst = 2'b00; // 寄存器目标选择信号为00
                RegWrite = 1'b1; // 寄存器写使能信号为1
                ALUsrc = 2'b01; // ALU源选择信号为01
                PCsrc = 3'b0; // 程序计数器源选择信号为0
                MemRead = 1'b0; // 存储器读使能信号为0
                MemWrite = 1'b0; // 存储器写使能信号为0
                MemtoReg = 2'b00; // 存储器数据送入寄存器选择信号为00
                SaFrom = 1'b0; //sa字段来源为0
                MemByte = 1'b0; // 字节选择信号为0
                Extension = 2'b00; // 扩展信号为00
                ALUop = 4'b0100; // ALU操作选择信号为0100
            end
            `LUI: begin
                RegDst = 2'b00; // 寄存器目标选择信号为00
                RegWrite = 1'b1; // 寄存器写使能信号为1
                ALUsrc = 2'b01; // ALU源选择信号为00
                PCsrc = 3'b0; // 程序计数器源选择信号为0
                MemRead = 1'b0; // 存储器读使能信号为0
                MemWrite = 1'b0; // 存储器写使能信号为0
                MemtoReg = 2'b00; // 存储器数据送入寄存器选择信号为00
                SaFrom = 1'b1; //sa字段来源为1
                MemByte = 1'b0; // 字节选择信号为0
                Extension = 2'b00; // 扩展信号为00
                ALUop = 4'b0110;
            end
            `ORI: begin //ORI指令
                RegDst = 2'b00; // 寄存器目标选择信号为00
                RegWrite = 1'b1; // 寄存器写使能信号为1
                ALUsrc = 2'b01; // ALU源选择信号为01
                PCsrc = 3'b0; // 程序计数器源选择信号为0
                MemRead = 1'b0; // 存储器读使能信号为0
                MemWrite = 1'b0; // 存储器写使能信号为0
                MemtoReg = 2'b00; // 存储器数据送入寄存器选择信号为00
                SaFrom = 1'b0; //sa字段来源为0
                MemByte = 1'b0; // 字节选择信号为0
                Extension = 2'b00; // 扩展信号为00
                ALUop = 4'b0101;
            end
            `XORI: begin //XORI指令
                RegDst = 2'b00; // 寄存器目标选择信号为00
                RegWrite = 1'b1; // 寄存器写使能信号为1
                ALUsrc = 2'b01; // ALU源选择信号为01
                PCsrc = 3'b0; // 程序计数器源选择信号为0
                MemRead = 1'b0; // 存储器读使能信号为0
                MemWrite = 1'b0; // 存储器写使能信号为0
                MemtoReg = 2'b00; // 存储器数据送入寄存器选择信号为00
                SaFrom = 1'b0; //sa字段来源为0
                MemByte = 1'b0; // 字节选择信号为0
                Extension = 2'b00; // 扩展信号为00
                ALUop = 4'b0111;
            end
            `BEQ: begin //BEQ指令
                RegDst = 2'b00; // 寄存器目标选择信号为00
                RegWrite = 1'b0; // 寄存器写使能信号为0
                ALUsrc = 2'b00; // ALU源选择信号为00
                PCsrc = 3'b001; // 程序计数器源选择信号
                MemRead = 1'b0; // 存储器读使能信号为0
                MemWrite = 1'b0; // 存储器写使能信号为0
                MemtoReg = 2'b00; // 存储器数据送入寄存器选择信号为00
                SaFrom = 1'b0; //sa字段来源为0
                MemByte = 1'b0; // 字节选择信号为0
                Extension = 2'b10; // 扩展信号为00
                ALUop = 4'b0010; // ALU操作选择信号为0010
            end
            `BNE: begin //BNE指令
                RegDst = 2'b00; // 寄存器目标选择信号为00
                RegWrite = 1'b0; // 寄存器写使能信号为0
                ALUsrc = 2'b00; // ALU源选择信号为00
                PCsrc = 3'b010;// 程序计数器源选择信号
                MemRead = 1'b0; // 存储器读使能信号为0
                MemWrite = 1'b0; // 存储器写使能信号为0
                MemtoReg = 2'b00; // 存储器数据送入寄存器选择信号为00
                SaFrom = 1'b0; //sa字段来源为0
                MemByte = 1'b0; // 字节选择信号为0
                Extension = 2'b10; // 扩展信号为00
                ALUop = 4'b0010; // ALU操作选择信号为0011
            end
            `BGTZ: begin //BGTZ指令
                RegDst = 2'b00; // 寄存器目标选择信号为00
                RegWrite = 1'b0; // 寄存器写使能信号为0
                ALUsrc = 2'b00; // ALU源选择信号为00
                PCsrc = 3'b011; // 程序计数器源选择信号
                MemRead = 1'b0; // 存储器读使能信号为0
                MemWrite = 1'b0; // 存储器写使能信号为0
                MemtoReg = 2'b00; // 存储器数据送入寄存器选择信号为00
                SaFrom = 1'b0; //sa字段来源为0
                MemByte = 1'b0; // 字节选择信号为0
                Extension = 2'b10; // 扩展信号为00
                ALUop = 4'b0010; // ALU操作选择信号为0011
            end
            `J: begin //J指令
                RegDst = 2'b00; // 寄存器目标选择信号为00
                RegWrite = 1'b0; // 寄存器写使能信号为0
                ALUsrc = 2'b00; // ALU源选择信号为00
                PCsrc = 3'b100; // 程序计数器源选择信号
                MemRead = 1'b0; // 存储器读使能信号为0
                MemWrite = 1'b0; // 存储器写使能信号为0
                MemtoReg = 2'b00; // 存储器数据送入寄存器选择信号为00
                SaFrom = 1'b0; //sa字段来源为0
                MemByte = 1'b0; // 字节选择信号为0
                Extension = 2'b11; // 扩展信号为00
                ALUop = 4'b0000; // ALU操作选择信号为0000
            end
            `JAL: begin //JAL指令
                RegDst = 2'b10; // 寄存器目标选择信号为01
                RegWrite = 1'b1; // 寄存器写使能信号为1
                ALUsrc = 2'b00; // ALU源选择信号为00
                PCsrc = 3'b100; // 程序计数器源选择信号
                MemRead = 1'b0; // 存储器读使能信号为0
                MemWrite = 1'b0; // 存储器写使能信号为0
                MemtoReg = 2'b10; // 存储器数据送入寄存器选择信号为00
                SaFrom = 1'b0; //sa字段来源为0
                MemByte = 1'b0; // 字节选择信号为0
                Extension = 2'b11; // 扩展信号为00
                ALUop = 4'b0000; // ALU操作选择信号为0000
            end
            `LB: begin //LB指令
                RegDst = 2'b00; // 寄存器目标选择信号为00
                RegWrite = 1'b1; // 寄存器写使能信号为1
                ALUsrc = 2'b01; // ALU源选择信号为10
                PCsrc = 3'b0; // 程序计数器源选择信号为0
                MemRead = 1'b1; // 存储器读使能信号为1
                MemWrite = 1'b0; // 存储器写使能信号为0
                MemtoReg = 2'b01; // 存储器数据送入寄存器选择信号为00
                SaFrom = 1'b0; //sa字段来源为0
                MemByte = 1'b1; // 字节选择信号为1
                Extension = 2'b01; // 扩展信号为00
                ALUop = 4'b0001; // ALU操作选择信号为0000
            end
            `LW: begin //LW指令
                RegDst = 2'b00; // 寄存器目标选择信号为00
                RegWrite = 1'b1; // 寄存器写使能信号为1
                ALUsrc = 2'b01; // ALU源选择信号为10
                PCsrc = 3'b0; // 程序计数器源选择信号为0
                MemRead = 1'b1; // 存储器读使能信号为1
                MemWrite = 1'b0; // 存储器写使能信号为0
                MemtoReg = 2'b01; // 存储器数据送入寄存器选择信号为00
                SaFrom = 1'b0; //sa字段来源为0
                MemByte = 1'b0; // 字节选择信号为0
                Extension = 2'b01; // 扩展信号为00
                ALUop = 4'b0001; // ALU操作选择信号为0000
            end
            `SB: begin //SB指令
                RegDst = 2'b00; // 寄存器目标选择信号为00
                RegWrite = 1'b0; // 寄存器写使能信号为0
                ALUsrc = 2'b01; // ALU源选择信号为00
                PCsrc = 3'b0; // 程序计数器源选择信号为0
                MemRead = 1'b0; // 存储器读使能信号为0
                MemWrite = 1'b1; // 存储器写使能信号为1
                MemtoReg = 2'b00; // 存储器数据送入寄存器选择信号为00
                SaFrom = 1'b0; //sa字段来源为0
                MemByte = 1'b1; // 字节选择信号为1
                Extension = 2'b01; // 扩展信号为00
                ALUop = 4'b0001; // ALU操作选择信号为0000
            end
            `SW: begin //SW指令
                RegDst = 2'b00; // 寄存器目标选择信号为00
                RegWrite = 1'b0; // 寄存器写使能信号为0
                ALUsrc = 2'b01; // ALU源选择信号为00
                PCsrc = 3'b0; // 程序计数器源选择信号为0
                MemRead = 1'b0; // 存储器读使能信号为0
                MemWrite = 1'b1; // 存储器写使能信号为1
                MemtoReg = 2'b00; // 存储器数据送入寄存器选择信号为00
                SaFrom = 1'b0; //sa字段来源为0
                MemByte = 1'b0; // 字节选择信号为0
                Extension = 2'b01; // 扩展信号为00
                ALUop = 4'b0001; // ALU操作选择信号为0000
            end
        endcase
    end
end

endmodule
