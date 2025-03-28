module Extension(
    input [25:0] immediate,
    input [1:0] ena,
    output reg[31:0] Extension_Data
);

always @(*) begin
    case(ena)
        //0extend
        2'b00:Extension_Data={16'b0,immediate[15:0]};
        //sign extend
        2'b01:Extension_Data={{16{immediate[15]}},immediate[15:0]};
        //branch extend，eg. bne,bnq,bngt
        2'b10:Extension_Data={{16{immediate[13]}},immediate[13:0],2'b00};
    endcase
end

endmodule