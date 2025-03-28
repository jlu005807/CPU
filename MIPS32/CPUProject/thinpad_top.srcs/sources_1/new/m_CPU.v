`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2024/12/05 14:29:21
// Design Name:
// Module Name: m_CPU
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


module m_CPU(
           input wire clk,
           input wire rst,
           input wire[31:0] base_ram_data,
           output wire[19:0] base_ram_addr,
           output wire[3:0] base_ram_be_n,
           output wire base_ram_ce_n,
           output wire base_ram_oe_n,
           output wire base_ram_we_n,
           inout wire[31:0] ext_ram_data,
           output wire[19:0] ext_ram_addr,
           output wire[3:0] ext_ram_be_n,
           output wire ext_ram_ce_n,
           output wire ext_ram_oe_n,
           output wire ext_ram_we_n
       );

//IM
assign base_ram_be_n=4'b0000;
assign base_ram_ce_n=1'b0;
assign base_ram_oe_n=1'b0;
assign base_ram_we_n=1'b1;

// integer i;
// initial begin
//     i=-1;
// end

//PC
wire[31:0] PC_out;



//Control
wire [31:0] instruction;
assign instruction = base_ram_data;

wire RegDst;
wire RegWrite;
wire ALUsrc;
wire[1:0] PCsrc;
wire MemRead;
wire MemWrite;
wire MemtoReg;
wire [3:0] ALUop;

Control ctrl(
            .OP_code(instruction[31:26]),
            .RegDst(RegDst),
            .RegWrite(RegWrite),
            .ALUsrc(ALUsrc),
            .PCsrc(PCsrc),
            .MemRead(MemRead),
            .MemWrite(MemWrite),
            .MemtoReg(MemtoReg),
            .ALUop(ALUop)
        );

//ALU Control
wire[2:0] ALU_ctrl;
ALU_Control aluctrl(
                .ALU_op(ALUop),
                .func(instruction[5:0]),
                .ALU_ctrl(ALU_ctrl)
            );

//Regfile
wire[31:0] reg_write_data;
wire[31:0] read_data1;
wire[31:0] read_data2;
wire[4:0] write_register;//rd

//mux0
assign write_register = (RegDst==1)? instruction[15:11] : instruction[20:16];

regfile regfile(
            .clk(clk),
            .write_enable(RegWrite),
            .rs(instruction[25:21]),
            .rt(instruction[20:16]),
            .rd(write_register),
            .data_in(reg_write_data),
            .read_data1(read_data1),
            .read_data2(read_data2)
        );

//ex16to32
wire[31:0] imm_data;

EXT16TO32 ex16to32(
              .ALU_control(ALU_ctrl),
              .imm_data(instruction[15:0]),
              .out(imm_data)
          );


//ALU
wire[31:0] ALU_op1;
wire[31:0] ALU_op2;
wire[31:0] ALU_result;
wire[4:0] sa;
wire zero;
wire sign;
assign ALU_op1 = read_data1;
//mux1
assign ALU_op2 = (ALUsrc==1)? imm_data : read_data2;

assign sa = instruction[10:6];

ALU alu(
        .ALU_OP(ALU_ctrl),
        .sa(sa),
        .OP1(ALU_op1),
        .OP2(ALU_op2),
        .ALU_OUT(ALU_result),
        .zero(zero),
        .sign(sign)
    );



//DM
assign ext_ram_addr = ALU_result[21:2];
assign ext_ram_be_n = 4'b0000;
assign ext_ram_ce_n = ~(MemRead | MemWrite);
assign ext_ram_oe_n = ~MemRead;
assign ext_ram_we_n = ~MemWrite;


//mux2
// inout_top dm(
//     .I_data_in(read_data2),
//     .IO_data(ext_ram_data),
//     .O_data_out(dm_read_data),
//     .control(MemWrite)
// );

// assign reg_write_data = (MemtoReg==0)? ext_ram_data : ALU_result;


wire[31:0] write_data;
assign write_data = (MemtoReg==0)? ext_ram_data : ALU_result;
assign ext_ram_data = (MemWrite == 1'b1) ? read_data2 : 32'bz;

wire [31:0]slt_data;
assign slt_data = (sign == 1'b1 ) ? 32'b1 : 32'b0;

assign reg_write_data = (instruction[31:26] == 6'b000000 && instruction[5:0] == 6'b101010)? slt_data : write_data;



//pc_plus4
wire[31:0] pc_plus4;
assign pc_plus4 = (PC_out + 4);



//EXT16TO32 ext16to32_bn

wire [31:0] extaddr;
assign extaddr = {{16{instruction[13]}},instruction[13:0],2'b00};

//bne/beq
wire[31:0] bn_addr;
assign bn_addr = (extaddr + pc_plus4);

//j_addr
wire[31:0] j_addr;
assign j_addr = {pc_plus4[31:28],instruction[23:0],2'b00};

//select_con
wire [2:0]con;
assign con = {PCsrc,zero};

PC pc(
       .clk(clk),
       .rst(rst),
       .pcplus4(pc_plus4),
       .bn_addr(bn_addr),
       .j_addr(j_addr),
       .con(con),
       .pc_out(PC_out),
       .ram_addr(base_ram_addr)
   );



endmodule
