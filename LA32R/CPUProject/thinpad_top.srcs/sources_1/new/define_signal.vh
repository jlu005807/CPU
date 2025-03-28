//定义信号
//RegRead
`define RegRead_from_Rk 1'b0 //从Rk寄存器读
`define RegRead_from_Rd 1'b1 //从Rd寄存器读

//RegDst
`define RegDst_to_Rd 1'b0 //写到Rd寄存器
`define RegDst_to_1 1'b1 //写到一号寄存器

//RegWrite
`define RegWrite_no 1'b0 //不写
`define RegWrite_yes 1'b1 //写

//ALUsrc
`define ALUsrc_from_Rj 1'b0 //从Rj寄存器读
`define ALUsrc_from_Extension 1'b1 //从扩展模块读

//MemRead
`define MemRead_no 1'b0 //不读
`define MemRead_yes 1'b1 //读存储器

//MemWrite
`define MemWrite_no 1'b0 //不写
`define MemWrite_yes 1'b1 //写存储器

//MemByte
`define MemByte_four_Byte 2'b0 //读四个字节
`define MemByte_one_Byte 2'b1 //读一个字节

//MemtoReg
`define MemtoReg_from_ALUOUT 2'b00 //ALU输出作为结果寄存器输入
`define MemtoReg_from_Mem 2'b01 //存储器输出作为结果寄存器输入
`define MemtoReg_from_PC 2'b10 //PC+4作为结果寄存器输入

//Extension
`define Extension_u12 2'b00 //12位零扩展
`define Extension_s12 2'b01 //12位符号扩展
`define Extension_s16 2'b10 //16位左移2位符号扩展
`define Extension_u20 2'b11 //20位零扩展

//ui5From
`define ui5From_rk 2'b00 //移位量来自GR[rk][4:0]
`define ui5From_ui5 2'b01 //移位量来自ui5字段
`define ui5From_12 2'b10 //移位量为12

//PCsrc
`define PCsrc_plus4 3'b000 //PC <-- PC+4
`define PCsrc_e_branch 3'b001 //PC <-- 相等条件跳转分支地址
`define PCsrc_ne_branch 3'b010 //PC <-- 不相等条件跳转分支地址
`define PCsrc_s_l_branch 3'b011 //PC <--小于条件跳转分支地址
`define PCsrc_s_g_or_e_branch 3'b100 //PC <-- 大于等于条件跳转分支地址
`define PCsrc_u_l_branch 3'b101 //PC <-- 无符号小于无符号条件跳转分支地址
`define PCsrc_u_g_or_e_branch 3'b110 //PC <-- 无符号大于等于无符号条件跳转分支地址
`define PCsrc_j 3'b111 //PC <-- 寄存器值（JIRL）