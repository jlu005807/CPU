module Forward(
           input[4:0] ID_EX_RegisterRj,
           input[4:0] ID_EX_RegisterRk,

           input EX_MEM_RegWrite,
           input[4:0] EX_MEM_RegisterRd,

           input MEM_WB_RegWrite,
           input[4:0] MEM_WB_RegisterRd,

           output [1:0] ForwardA,
           output [1:0] ForwardB
       );

wire EX_Hazard_A;
wire EX_Hazard_B;
assign EX_Hazard_A=EX_MEM_RegWrite&&(EX_MEM_RegisterRd!=5'b0)&&(EX_MEM_RegisterRd==ID_EX_RegisterRj);
assign EX_Hazard_B=EX_MEM_RegWrite&&(EX_MEM_RegisterRd!=5'b0)&&(EX_MEM_RegisterRd==ID_EX_RegisterRk);

wire MEM_Hazard_A;
wire MEM_Hazard_B;
assign MEM_Hazard_A=MEM_WB_RegWrite&&(MEM_WB_RegisterRd!=5'b0)&&(MEM_WB_RegisterRd==ID_EX_RegisterRj);
assign MEM_Hazard_B=MEM_WB_RegWrite&&(MEM_WB_RegisterRd!=5'b0)&&(MEM_WB_RegisterRd==ID_EX_RegisterRk);

assign ForwardA={EX_Hazard_A,MEM_Hazard_A};
assign ForwardB={EX_Hazard_B,MEM_Hazard_B};

endmodule
