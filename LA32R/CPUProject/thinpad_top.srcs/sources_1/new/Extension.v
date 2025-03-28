module Extension(
    input [25:5] immediate,
    input [1:0] ena,
    output reg[31:0] Extension_Data
);

always @(*) begin
    case(ena)
        //IM[21:10]立即数零扩展
        2'b00:Extension_Data={20'b0,immediate[21:10]};
        //IM[21:10]立即数符号扩展
        2'b01:Extension_Data={{20{immediate[21]}},immediate[21:10]};
        //IM[25:10]立即数offset左移2位并进行有符号扩展
        2'b10:Extension_Data={{16{immediate[23]}},immediate[23:10],2'b00};
        //IM[24:5]零扩展
        2'b11:Extension_Data={12'b0,immediate[24:5]};
    endcase
end

endmodule