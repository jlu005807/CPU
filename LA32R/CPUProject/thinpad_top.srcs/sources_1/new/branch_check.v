// Branch Checker for Thinpad
module branch_check(
           input wire[2:0] PCsrc,
           input wire[31:0] PC,
           input wire [31:0] prediction_PC,
           input wire [31:0] Extension_Data,
           input wire [31:0] ALU_result,
           input wire CF,//加法器最高位进位输出（用于无符号数判断借位）。
           input wire ZF,//零标志位
           input wire SF,//符号标志位
           input wire OF,//溢出标志，有符号数运算溢出时置1（通过比较输入符号和结果符号计算）。
           output reg branch_taken,
           output reg is_branch_instruction,
           output  branch_is_real,
           output[31:0] branch_target
       );

reg branch_check;//是否跳转的信号。
reg[31:0] target_PC;
reg[31:0] PC_plus_4;
always @(*) begin
    // 默认目标地址：取 `Extension_Data + PC`
    target_PC = Extension_Data + PC;
    PC_plus_4 = PC + 4;
    // 默认假设为不是条件分支指令
    is_branch_instruction = 1'b0;

    case(PCsrc)
        3'b000: begin // not branch
            branch_taken = 0;
        end
        3'b001: begin // branch on equal
            is_branch_instruction = 1'b1;
            branch_taken= ZF;
        end
        3'b010: begin // branch on not equal
            is_branch_instruction = 1'b1;
            branch_taken= ~ZF;
        end
        3'b011: begin // branch on signed less than
            is_branch_instruction = 1'b1;
            branch_taken = (~ZF&(SF!=OF));
        end 
        3'b100:begin // branch on signed greater or equal than
            is_branch_instruction = 1'b1;
            branch_check = ~(~ZF&(SF!=OF));
        end
        3'b101: begin // branch on unsigned less than
            is_branch_instruction = 1'b1;
            branch_taken = CF;
        end
        3'b110: begin // branch on unsigned greater or equal than
            is_branch_instruction = 1'b1;
            branch_taken = ~CF;
        end
        3'b111: begin // branch JIRL
            is_branch_instruction = 1'b1;
            branch_taken = 1'b1;
            target_PC = ALU_result;
        end
    endcase
end

// 分支是否真实（即与预测的PC比较）
assign branch_is_real = branch_taken?(target_PC==prediction_PC):(PC_plus_4==prediction_PC);
assign branch_target = branch_taken?target_PC:PC_plus_4;
endmodule
