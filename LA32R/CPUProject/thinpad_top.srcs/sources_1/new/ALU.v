`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2024/11/28 16:16:10
// Design Name:
// Module Name: ALU
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module ALU(
           input wire [3:0] ALU_ctrl,
           input wire [4:0] ui5,
           input wire [31:0] OP1,
           input wire [31:0] OP2,
           output wire [31:0] ALU_OUT,

           output wire CF,//加法器最高位进位输出（用于无符号数判断�?�位）�??
           output wire ZF,//零标志位
           output wire SF,//符号标志�?
           output wire OF//溢出标志，有符号数运算溢出时�?1（�?�过比较输入符号和结果符号计算）�?
       );
       reg[31:0] result;

      //实例�?32位超前加法器
      reg C_in;
      wire C_out;
      reg[31:0] Adder_B;
      wire[31:0] Adder_result;
      CarryLookaheadAdder32 adder32(
              .A(OP1),
              .B(Adder_B),
              .C_in(C_in),
              .Sum(Adder_result),
              .C_out(C_out)
      );

      //生成标志�?,只根据加法器赋�?�，�?以不使用加法器时标志位无�?
      assign ZF =(Adder_result==32'b0);
      assign SF = Adder_result[31];
      assign CF = (ALU_ctrl==4'b0010)?~C_out:C_out;//减法时Cout为�?�位取反
      assign OF = (OP1[31]^Adder_B[31])&(OP1[31]^SF);

       always @(*) begin
        //默认加法器使用加�?
        C_in=1'b0;
        Adder_B=OP2;
        case (ALU_ctrl)
        4'b0001:begin//add
          result=Adder_result;
        end
        4'b0010:begin//sub
          C_in=1'b1;
          Adder_B=~OP2;
          result=Adder_result;
        end
        4'b0011:begin//mul
          result = $signed(OP1)*$signed(OP2);
        end
        4'b0100:begin//and
          result = OP1 & OP2;
        end
        4'b0101:begin//or
          result = OP1 | OP2;
        end
        4'b0110:begin//nor
          result = ~(OP1|OP2);
        end
        4'b0111:begin//xor
          result = OP1 ^ OP2;
        end
        4'b1000:begin//逻辑左移
          result = OP2 << ui5;
          end
          4'b1001:begin//逻辑右移
          result = OP2 >> ui5;
        end
        4'b1010:begin//算术右移
          result = OP2 >>> ui5;
          end
          4'b1011:begin//无符号小于置�?
          result = CF?32'b1:32'b0;
          end
          4'b1100:begin//有符号小于置�?
          result = (~ZF&(SF!=OF))?32'b1:32'b0;
          end
          default: result = 32'b0;
        endcase
       end   
       assign ALU_OUT = result;
endmodule
