module Load_use_Data_Hazard(
    input clk,
    input reset,
    input [4:0] IF_ID_RegisterRs,
    input [4:0] IF_ID_RegisterRt,
    input ID_EX_MemRead, // Load
    input [4:0] ID_EX_RegisterRt,
    output reg STALL // ͣ�ٻ��߶���һ������
);

// Load_use_Data_Hazardð�ռ��
wire hazard_detected;
assign hazard_detected = ID_EX_MemRead && 
                        ((ID_EX_RegisterRt == IF_ID_RegisterRs) || 
                         (ID_EX_RegisterRt == IF_ID_RegisterRt));

always @(*) begin
    if (reset) begin
        STALL <= 1'b0;
    end else begin
        STALL <= hazard_detected;
    end
end

endmodule