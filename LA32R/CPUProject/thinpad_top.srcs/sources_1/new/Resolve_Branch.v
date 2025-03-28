`include"define_instruction.vh"

module Resolve_Branch(
           input [31:0] PC,
           input [31:0] instruction,
           input[31:0] prediction_PC,
           input prediction_taken,
           output [31:0] resolved_PC
       );
reg is_branch;
reg[31:0] PCpuls4;

//判断是否为B指令和BL指令
reg IS_J;//无条件转移指令
reg[31:0] J_target_PC;
always @(*) begin
    PCpuls4 = PC + 4;
    IS_J=1'b0;
    J_target_PC=0;
    is_branch=1'b0;
    case(instruction[31:26])
    `B,`BL:begin
        is_branch=1'b1;
        IS_J=1'b1;
        J_target_PC = PC+{{6{instruction[7]}},instruction[7:0],instruction[25:10],2'b00};
    end
    `JIRL:begin
        is_branch=1'b1;
    end
    `BEQ,`BNE,`BLT,`BGE,`BLTU,`BGEU:begin
        is_branch=1'b1;
    end
    endcase
    
end
//除B,BL外的分支预测结果
wire[31:0] target_PC;
assign target_PC=is_branch? (prediction_taken? prediction_PC : PCpuls4) : PCpuls4;

//npc计算
assign resolved_PC = IS_J?J_target_PC:target_PC;

endmodule
