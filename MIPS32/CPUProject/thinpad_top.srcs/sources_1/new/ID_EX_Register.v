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
           input [31:0] RegfileRs_Data_in,
           input [31:0] RegfileRt_Data_in,
           input [4:0] ID_EX_RegfileWrite_Address_in,
           input [4:0] ID_EX_RegisterRs_in,
           input [4:0] ID_EX_RegisterRt_in,//for Load_use_Hazard
           input [31:0] Extension_Data_in,
           input [5:0] funct_in,
           input [5:0] sa_in,
           input [1:0] ALUsrc_in,
           input RegWrite_in,
           input [2:0] PCsrc_in,
           input MemRead_in,
           input MemWrite_in,
           input [1:0] MemtoReg_in,
           input MemByte_in,
           input [3:0] ALUop_in,

           //Output
           output reg [31:0] RegfileRs_Data,
           output reg [31:0] RegfileRt_Data,
           output reg [31:0] Extension_Data,
           output reg [4:0] ID_EX_RegfileWrite_Address,
           output reg [4:0] ID_EX_RegisterRs,
           output reg [4:0] ID_EX_RegisterRt,
           output reg [5:0] funct,
           output reg [5:0] sa,
           output reg [1:0] ALUsrc,
           output reg RegWrite,
           output reg [2:0] PCsrc,
           output reg MemRead,
           output reg MemWrite,
           output reg [1:0] MemtoReg,
           output reg MemByte,
           output reg [3:0] ALUop
       );

always @(posedge clk) begin
    //这里需要注意STALL不是停顿而是清除指令信息，避免STALL无法更新一直停顿流水线
    if(flush||reset||STALL) begin
        PC<=0;
        prediction_PC<=0;
        RegfileRs_Data <= 0;
        RegfileRt_Data <= 0;
        Extension_Data <= 0;
        ID_EX_RegfileWrite_Address <= 0;
        ID_EX_RegisterRs <= 0;
        ID_EX_RegisterRt <= 0;
        funct <= 0;
        sa <= 0;
        ALUsrc<=0;
        RegWrite <= 0;
        PCsrc <= 0;
        MemRead <= 0;
        MemWrite <= 0;
        MemtoReg <= 0;
        MemByte <= 0;
        ALUop <= 0;
    end
    else begin
        PC<=PC_in;
        prediction_PC<=prediction_PC_in;
        RegfileRs_Data <= RegfileRs_Data_in;
        RegfileRt_Data <= RegfileRt_Data_in;
        Extension_Data <= Extension_Data_in;
        ID_EX_RegfileWrite_Address <= ID_EX_RegfileWrite_Address_in;
        ID_EX_RegisterRs <= ID_EX_RegisterRs_in;
        ID_EX_RegisterRt <= ID_EX_RegisterRt_in;
        funct <= funct_in;
        sa <= sa_in;
        ALUsrc<=ALUsrc_in;
        RegWrite <= RegWrite_in;
        PCsrc <= PCsrc_in;
        MemRead <= MemRead_in;
        MemWrite <= MemWrite_in;
        MemtoReg <= MemtoReg_in;
        MemByte <= MemByte_in;
        ALUop <= ALUop_in;
    end
end

endmodule
