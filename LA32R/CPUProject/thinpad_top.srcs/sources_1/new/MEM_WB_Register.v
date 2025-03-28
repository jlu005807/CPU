module MEM_WB_Register(
           //sign
           input clk,
           input reset,

           //inputs
           input[31:0] PC_in,
           input [31:0] ALU_OUT_in,
           input [31:0] Ext_ram_Data_in,
           input [4:0] MEM_WB_RegisterRd_in,
           input [1:0] MEM_WB_MemtoReg_in,
           input MEM_WB_RegWrite_in,

           //outputs
           output reg [31:0] PC,
           output reg [31:0] ALU_OUT,
           output reg [31:0] Ext_ram_Data,
           output reg [1:0] MEM_WB_MemtoReg,
           output reg [4:0] MEM_WB_RegisterRd,
           output reg MEM_WB_RegWrite
       );
always @(posedge clk) begin
    if(reset)begin
        PC <= 0;
        ALU_OUT <= 0;
        Ext_ram_Data <= 0;
        MEM_WB_MemtoReg <= 0;
        MEM_WB_RegisterRd <= 0;
        MEM_WB_RegWrite <= 0;
    end
    else begin
        PC <= PC_in;
        ALU_OUT <= ALU_OUT_in;
        Ext_ram_Data <= Ext_ram_Data_in;
        MEM_WB_MemtoReg <= MEM_WB_MemtoReg_in;
        MEM_WB_RegisterRd <= MEM_WB_RegisterRd_in;
        MEM_WB_RegWrite <= MEM_WB_RegWrite_in;
    end
end

endmodule
