module Load_use_Data_Hazard(
    input clk,
    input reset,
    input [4:0] IF_ID_RegisterRj,
    input [4:0] IF_ID_RegisterRk,
    input ID_EX_MemRead, // Load
    input [4:0] ID_EX_RegisterRd,
    output reg STALL 
);

// Load_use_Data_Hazardð�ռ��
wire hazard_detected;
assign hazard_detected = ID_EX_MemRead && 
                        ((ID_EX_RegisterRd == IF_ID_RegisterRj) || 
                         (ID_EX_RegisterRd == IF_ID_RegisterRk));

always @(*) begin
    if (reset) begin
        STALL <= 1'b0;
    end else begin
        STALL <= hazard_detected;
    end
end

endmodule