module EX_MEM_Register(
    //sign
    input clk,
    input reset,

    //inputs
    input [31:0] EX_MEM_PC_in,
    input [31:0] ALU_result_in,
    input [31:0] EX_MEM_Ext_ram_Data_in,
    input [4:0] EX_MEM_RegfileWrite_Address_in,
    input RegWrite_in,
    input MemRead_in,
    input MemWrite_in,
    input[1:0] MemtoReg_in,
    input MemByte_in,

    //outputs
    output reg [31:0] EX_MEM_PC,
    output reg [31:0] EX_MEM_ALU_OUT,
    output reg [31:0] EX_MEM_Ext_ram_Data,
    output reg [31:0] EX_MEM_Ext_ram_Address,//访存地址
    output reg [4:0] EX_MEM_RegfileWrite_Address,//写寄存器地址
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg[1:0] MemtoReg,
    output reg MemByte
);

always @(posedge clk) begin
    if(reset)begin
        EX_MEM_PC <= 0;
        EX_MEM_ALU_OUT<=0;
        EX_MEM_Ext_ram_Data <= 0;
        EX_MEM_Ext_ram_Address <= 0;
        EX_MEM_RegfileWrite_Address <= 0;
        RegWrite <= 0;
        MemWrite <= 0;
        MemtoReg <= 0;
        MemRead <= 0;
        MemByte <= 0;
    end else begin
        EX_MEM_PC <= EX_MEM_PC_in;
        EX_MEM_ALU_OUT<=ALU_result_in;
        EX_MEM_Ext_ram_Data <= EX_MEM_Ext_ram_Data_in;
        EX_MEM_Ext_ram_Address <= ALU_result_in;
        EX_MEM_RegfileWrite_Address <= EX_MEM_RegfileWrite_Address_in;
        RegWrite <= RegWrite_in;
        MemWrite <= MemWrite_in;
        MemtoReg <= MemtoReg_in;
        MemRead <= MemRead_in;
        MemByte <= MemByte_in;
    end
end


endmodule