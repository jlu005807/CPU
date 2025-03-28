`timescale 1ns / 1ps

module ALU_Control(
           input wire [3:0] ALU_op,
           input wire [5:0] funct,
           output reg [7:0] ALU_ctrl
       );
       
always @(*) begin
    if(ALU_op[3])begin
        case(funct)
            6'b100001:ALU_ctrl = 8'b0000_0001;// add
            6'b100010:ALU_ctrl = 8'b0000_0010;// sub
            6'b100100:ALU_ctrl = 8'b0000_1000;// and
            6'b100101:ALU_ctrl = 8'b0001_0000;// or
            6'b100110:ALU_ctrl = 8'b0010_0000;// xor
            6'b000000:ALU_ctrl = 8'b0100_0000;// sll
            6'b000010:ALU_ctrl = 8'b1000_0000;// srl
        endcase
    end
    else begin
        case(ALU_op[2:0])
            3'b001:ALU_ctrl = 8'b0000_0001;// add
            3'b010:ALU_ctrl = 8'b0000_0010;// sub
            3'b011:ALU_ctrl = 8'b0000_0100;// mul
            3'b100:ALU_ctrl = 8'b0000_1000;// and
            3'b101:ALU_ctrl = 8'b0001_0000;// or
            3'b111:ALU_ctrl = 8'b0010_0000;// xor
            3'b110:ALU_ctrl = 8'b0100_0000;// sll
            default:ALU_ctrl = 8'b0000_0000;
        endcase
    end
end

endmodule
