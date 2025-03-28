module BHT (
    input clk,
    input reset,
    input [31:0] PC_in,          // 当前PC
    input [31:0] update_PC,      // 需要更新的PC
    input branch_taken,          // EX阶段实际分支结果
    input update,                // 需要更新计数器
    output  prediction        // 预测结果（0:不跳转，1:跳转）
);
    // 计数器状态机
    reg [1:0] counter [0:63];    // 64项两位计数器
    wire [5:0] index = PC_in[7:2];
    
    wire [5:0] update_index = update_PC[7:2];
    integer i;
    always @(posedge clk) begin
        if (reset) begin
            for (i=0; i<64; i=i+1) counter[i] <= 2'b10; // 初始化为弱跳转
        end else if (update) begin
            // 更新计数器状态
            case (counter[update_index])
                2'b00: counter[update_index] <= branch_taken ? 2'b01 : 2'b00; // 强不跳转
                2'b01: counter[update_index] <= branch_taken ? 2'b10 : 2'b00;
                2'b10: counter[update_index] <= branch_taken ? 2'b11 : 2'b01;
                2'b11: counter[update_index] <= branch_taken ? 2'b11 : 2'b10; // 强跳转
            endcase
        end
    end

    // 预测逻辑：根据计数器状态判断
    assign prediction = (counter[index][1] == 1'b1); // 高位为1则预测跳转
endmodule