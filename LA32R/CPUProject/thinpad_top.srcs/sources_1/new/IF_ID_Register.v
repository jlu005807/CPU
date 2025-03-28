module IF_ID_Register(
           //sign
           input clk,
           input reset,
           input STALL,
           input flush,

           //inputs
           input [31:0]instruction_in,
           input [31:0]PC_in,
           input [31:0]prediction_PC_in,
           input RegRead_in,

           //outputs
           output reg [31:0]instruction,
           output reg [31:0]PC,
           output reg [31:0]prediction_PC,
           output reg RegRead
       );

always @(posedge clk) begin
    if(flush||reset)begin
        instruction<=32'b0;
        PC<=32'b0;
        prediction_PC<=32'b0;
        RegRead<=0;
    end
    else if(STALL) begin
        instruction<=instruction;
        PC<=PC;
        prediction_PC<=prediction_PC;
        RegRead<=RegRead;
    end
    else begin
        instruction<=instruction_in;
        PC<=PC_in;
        prediction_PC<=prediction_PC_in;
        RegRead<=RegRead_in;
    end
end

endmodule
