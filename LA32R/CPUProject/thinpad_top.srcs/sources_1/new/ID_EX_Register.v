module ID_EX_Register(
           //sign
           input clk,
           input reset,
           input STALL,
           input flush,

           //PC
           input[31:0] PC_in,
           input[31:0] prediction_PC_in,
           output reg [31:0] PC,
           output reg [31:0] prediction_PC,

           //Instruction
           input [31:0] RegfileRj_Data_in,
           input [31:0] RegfileRk_Data_in,
           input [4:0] ID_EX_RegfileWrite_Address_in,
           input [4:0] ID_EX_RegisterRj_in,
           input [4:0] ID_EX_RegisterRk_in,//for Load_use_Hazard
           input [31:0] Extension_Data_in,
           input [5:0] funct_in,
           input [5:0] ui5_in,
           input  ALUsrc_in,
           input RegWrite_in,
           input [2:0] PCsrc_in,
           input MemRead_in,
           input MemWrite_in,
           input [1:0] MemtoReg_in,
           input [1:0] ui5From_in,
           input MemByte_in,
           input [3:0] ALUop_in,

           //Output
           output reg [31:0] RegfileRj_Data,
           output reg [31:0] RegfileRk_Data,
           output reg [31:0] Extension_Data,
           output reg [4:0] ID_EX_RegfileWrite_Address,
           output reg [4:0] ID_EX_RegisterRj,
           output reg [4:0] ID_EX_RegisterRk,
           output reg [5:0] funct,
           output reg [5:0] ui5,
           output reg  ALUsrc,
           output reg RegWrite,
           output reg [2:0] PCsrc,
           output reg MemRead,
           output reg MemWrite,
           output reg [1:0] MemtoReg,
           output reg [1:0] ui5From,
           output reg MemByte,
           output reg [3:0] ALUop
       );

always @(posedge clk) begin
    //这里需要注意STALL不是停顿而是清除指令信息，避免STALL无法更新一直停顿流水线
    if(flush||reset||STALL) begin
        PC<=0;
        prediction_PC<=0;
        RegfileRj_Data <= 0;
        RegfileRk_Data <= 0;
        Extension_Data <= 0;
        ID_EX_RegfileWrite_Address <= 0;
        ID_EX_RegisterRj <= 0;
        ID_EX_RegisterRk <= 0;
        funct <= 0;
        ui5 <= 0;
        ALUsrc<=0;
        RegWrite <= 0;
        PCsrc <= 0;
        MemRead <= 0;
        MemWrite <= 0;
        MemtoReg <= 0;
        ui5From <= 0;
        MemByte <= 0;
        ALUop <= 0;
    end
    else begin
        PC<=PC_in;
        prediction_PC<=prediction_PC_in;
        RegfileRj_Data <= RegfileRj_Data_in;
        RegfileRk_Data <= RegfileRk_Data_in;
        Extension_Data <= Extension_Data_in;
        ID_EX_RegfileWrite_Address <= ID_EX_RegfileWrite_Address_in;
        ID_EX_RegisterRj <= ID_EX_RegisterRj_in;
        ID_EX_RegisterRk <= ID_EX_RegisterRk_in;
        funct <= funct_in;
        ui5 <= ui5_in;
        ALUsrc<=ALUsrc_in;
        RegWrite <= RegWrite_in;
        PCsrc <= PCsrc_in;
        MemRead <= MemRead_in;
        MemWrite <= MemWrite_in;
        MemtoReg <= MemtoReg_in;
        ui5From <= ui5From_in;
        MemByte <= MemByte_in;
        ALUop <= ALUop_in;
    end
end

endmodule
