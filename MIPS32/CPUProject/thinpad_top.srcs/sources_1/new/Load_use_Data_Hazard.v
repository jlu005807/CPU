module Load_use_Data_Hazard(
    input clk,
    input reset,
    input [4:0] IF_ID_RegisterRs,
    input [4:0] IF_ID_RegisterRt,
    input ID_EX_MemRead, // Load
    input [4:0] ID_EX_RegisterRt,
    output reg STALL // 停顿或者堵塞一个周期
);

// Load_use_Data_Hazard冒险检测
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