module IF_ID_Register(
           //sign
           input clk,
           input reset,
           input STALL,
           input flush,

           //inputs
           input IS_JR_in,
           input [31:0]instruction_in,
           input [31:0]PC_in,
           input [31:0]prediction_PC_in,

           //outputs
           output reg IS_JR,
           output reg [31:0]instruction,
           output reg [31:0]PC,
           output reg [31:0]prediction_PC
       );

always @(posedge clk) begin
    if(flush||reset)begin
        IS_JR <=1'b0;
        instruction<=32'b0;
        PC<=32'b0;
        prediction_PC<=32'b0;
    end
    else if(STALL) begin
        IS_JR <=IS_JR;
        instruction<=instruction;
        PC<=PC;
        prediction_PC<=prediction_PC;
    end
    else begin
        IS_JR <=IS_JR_in;
        instruction<=instruction_in;
        PC<=PC_in;
        prediction_PC<=prediction_PC_in;
    end
end

endmodule
