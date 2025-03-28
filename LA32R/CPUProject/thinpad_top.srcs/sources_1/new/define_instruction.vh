

//转移指令（IM[31:26]）

//无条件转移指令
`define JIRL 6'b010011 //JIRL rd,rj,offs 无条件转移并写入rd寄存器    010011 offs[15:0] rj rd 
`define B 6'b010100    //B    offs       无条件转移                 010100 offs[15:0] 
`define BL 6'b010101   //BL   offs       无条件转移并写入一号寄存器  010101 offs[15:0] 

//条件转移指令
`define BEQ 6'b010110 //BEQ   rj,rd,offs  相等则转移            010110 offs[15:0] rj rd 
`define BNE 6'b010111 //BNE   rj,rd,offs  不相等则转移          010111 offs[15:0] rj rd 
`define BLT 6'b011000 //BLT   rj,rd,offs  小于则转移            011000 offs[15:0] rj rd 
`define BGE 6'b011001 //BGE   rj,rd,offs  大于等于则转移         011001 offs[15:0] rj rd 
`define BLTU 6'b011010 //BLTU rj,rd,offs  无符号小于则转移       011010 offs[15:0] rj rd 
`define BGEU 6'b011011 //BGEU rj,rd,offs  无符号大于等于则转移   011011 offs[15:0] rj rd 

//算术指令
//IM[31:20]
`define R_type 12'h001
//对于3R-type这里标记funct(IM[19:15])
`define ADD_W 5'b00000 //ADD_W rd,rj,rk 加法           00000000000100000 rk rj rd
`define SUB_W 5'b00010 //SUB_W rd,rj,rk 减法           00000000000100010 rk rj rd 
`define MUL_W 5'b11000 //MUL_W rd,rj,rk 乘法           00000000000111000 rk rj rd 
`define AND 5'b01001   //AND   rd,rj,rk 按位与         00000000000101001 rk rj rd 
`define OR 5'b01010    //OR    rd,rj,rk 按位或         00000000000101010 rk rj rd 
`define NOR 5'b01000   //NOR   rd,rj,rk 按位或反       00000000000101000 rk rj rd 
`define XOR 5'b01011   //XOR   rd,rj,rk 按位异或       00000000000101011 rk rj rd 
`define SLL_W 5'b01110 //SLL_W rd,rj,rk 逻辑左移       00000000000110000 rk rj rd 
`define SRL_W 5'b01111 //SRL_W rd,rj,rk 逻辑右移       00000000000110001 rk rj rd 
`define SRA_W 5'b10000 //SRA_W rd,rj,rk 算术右移       00000000000110010 rk rj rd 
`define SLT 5'b00100   //SLT   rd,rj,rk 有符号小于置位  00000000000100100 rk rj rd 
`define SLTU 5'b00101  //SLTU  rd,rj,rk 无符号小于置位  00000000000100101 rk rj rd 

//LU12I(IM[31:25])
`define LU12I  7'b0001010 //LU12I rd si20 左移十二位   0001010 si20 rd

//I-type(IM[31:25])
`define I_type 7'b0000001
//对于I-type这里标记IM[24:22]
`define SLTI 3'b000  //SLTI  rd,rj,si12 有符号小于     0000001000 si12 rj rd 
`define SLTUI 3'b001 //SLTUI rd,rj,ui12 无符号小于     0000001001 ui12 rj rd 
`define ADDI_W 3'b010//ADDI_W rd,rj,si12 加法          0000001010 si12 rj rd 
`define ANDI 3'b101  //ANDI  rd,rj,ui12 按位与         0000001100 ui12 rj rd 
`define ORI 3'b110   //ORI   rd,rj,ui12 按位或         0000001110 ui12 rj rd 
`define XORI 3'b111  //XORI  rd,rj,ui12 按位异或       0000001111 ui12 rj rd 

//逻辑移位指令(IM[31:15])
//定义前后缀
`define PRE 12'b000000000100 //前缀IM[31:20]
`define POST 3'b001 //后缀IM[17:15]
`define SLLI_W 2'b00 //SLLI_W rd,rj,ui5 逻辑左移   00000000010000001 ui5 rj rd 
`define SRLI_W 2'b01 //SRLI_W rd,rj,ui5 逻辑右移   00000000010001001 ui5 rj rd 
`define SRAI_W 2'b10 //SRAI_W rd,rj,ui5 算术右移   00000000010010001 ui5 rj rd 

//访存指令（IM[31:22])
`define LOS  7'b0010100 //IM[31:25]
//IM[24:22]
`define LD_B 3'b000 //LD_B  rd,rj,si12  字节加载        0010100000 offs[15:0] rj rd 
`define LD_W 3'b010 //LD_W  rd,rj,si12  字加载         0010100010 offs[15:0] rj rd 
`define ST_B 3'b100 //ST_B  rd,rj,si12  字节存储        0010100100 offs[15:0] rj rd 
`define ST_W 3'b110 //ST_W  rd,rj,si12  字存储         0010100110 offs[15:0] rj rd 