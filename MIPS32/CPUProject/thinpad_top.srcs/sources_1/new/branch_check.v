// Branch Checker for Thinpad
module branch_check(
           input wire[2:0] PCsrc,
           input wire[31:0] PCpuls4,
           input wire [31:0] prediction_PC,
           input wire [31:0] Extension_Data,
           input wire[31:0] ALU_out,
           input wire[31:0] RegfileRs_Data,
           output reg branch_taken,
           output reg is_branch_instruction,
           output  branch_is_real,
           output[31:0] branch_target
       );

// is_branch
reg[31:0] target_PC;
wire zero_flag;
wire sign_flag;
assign zero_flag = (ALU_out == 32'b0);
assign sign_flag = ALU_out[31];
always @(*) begin
    // 默认目标地址：取 `Extension_Data + PCpuls4`
    target_PC = Extension_Data + PCpuls4;
    // 默认假设为分支指令
    is_branch_instruction = 1;

    case(PCsrc)
        3'b000: begin // not branch
            branch_taken = 0;
            is_branch_instruction=0;
        end
        3'b001: begin // branch on equal
            branch_taken= zero_flag;
        end
        3'b010: begin // branch on not equal
            branch_taken= ~zero_flag;
        end
        3'b011: begin // branch on bigger than
            branch_taken= ~sign_flag & ~zero_flag;
        end
        //j指令和jal指令在IF段直接跳转无需判断
        // 3'b100 : begin //j,jal
        //     branch_taken= 1;
        //     target_PC = {PCpuls4[31:28],Extension_Data[23:0],2'b00};
        // end
        3'b101: begin // jr
            branch_taken= 1;
            target_PC = RegfileRs_Data;
        end
    endcase
end

// 分支是否真实（即与预测的PC比较）
assign branch_is_real = branch_taken?(target_PC==prediction_PC):(PCpuls4==prediction_PC);
assign branch_target = branch_taken?target_PC:PCpuls4;
endmodule
