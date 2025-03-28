`include"define.vh"

module Resolve_Branch(
           input [31:0] PC,
           input [31:0] instruction,
           input[31:0] prediction_PC,
           input prediction_taken,
           output reg IS_JR,
           output [31:0] resolved_PC
       );
reg is_branch;
reg[31:0] PCpuls4;

//判断是否为j指令和jal指令
reg IS_J;
reg[31:0] J_target_PC;
always @(*) begin
    IS_JR=0;
    IS_J=0;
    is_branch=0;
    PCpuls4=PC+4;
    //jr
    if(instruction[31:26] == 6'b000000 &&instruction[20:6]==15'b0 && instruction[5:0] == 6'b001000) begin
        is_branch = 1;
        IS_JR = 1;
    end
    else if(instruction[31:26] == `BEQ || instruction[31:26] == `BNE || instruction[31:26] == `BGTZ ) begin
        is_branch = 1;
    end else if(instruction[31:26] == `J || instruction[31:26] == `JAL) begin
         is_branch = 1;
         IS_J=1;
         //对于直接跳转指令直接算出并跳转
         J_target_PC = {PCpuls4[31:28],instruction[23:0],2'b00};
    end
end
//除j,jal外的分支预测结果
wire[31:0] target_PC;
assign target_PC=is_branch? (prediction_taken? prediction_PC : PCpuls4) : PCpuls4;

assign resolved_PC = IS_J?J_target_PC:target_PC;

endmodule
