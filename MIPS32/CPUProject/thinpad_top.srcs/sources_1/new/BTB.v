module BTB(
           input clk, // 时钟信号
           input reset, // 复位信号
           input [31:0]PC_in, // PC输入
           input [31:0]branch_target, // 实际分支目标地址
           input [31:0]branch_target_PC, // 实际分支目标PC
           input update, // 更新信号
           output [31:0] prediction_PC // 预测的PC输出
       );

// BTB表项结构：{valid, tag, target}
reg [31:0] tag [0:63];         // 64项，每项存储地址的高位（假设地址低6位作为索引）
reg [31:0] target [0:63];
reg valid [0:63];

//update logic
wire[5:0] update_index = branch_target_PC[7:2]; // 取实际分支目标PC的低6位作为索引（假设4字节对齐）
integer i;
always @(posedge clk) begin
    if (reset) begin
        for (i=0; i<64; i=i+1) valid[i] <= 0;
    end else if (update) begin
        // 更新BTB项：记录实际分支跳转目标
        tag[update_index]    <= branch_target_PC; 
        target[update_index] <= branch_target;
        valid[update_index]  <= 1'b1;
    end
end

//prediction logic
// 预测逻辑：检查当前PC是否在BTB中命中，命中则返回预测的目标地址，否则返回当前PC+4
wire [5:0] prediction_index = PC_in[7:2]; // 取PC的低6位作为索引（假设4字节对齐）

assign prediction_PC = (valid[prediction_index] && (PC_in == tag[prediction_index])) ? target[prediction_index] : PC_in + 4;
endmodule
