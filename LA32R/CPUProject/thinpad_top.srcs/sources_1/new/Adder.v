module CarryLookaheadAdder32 (
    input [31:0] A,
    input [31:0] B,
    input C_in,
    output [31:0] Sum,
    output C_out
);
    wire [31:0] G, P;
    assign G = A & B;
    assign P = A ^ B;

    // 组生成（GG）和组传播（PG）信号（8组，每组4位）
    wire [7:0] GG, PG;
    wire [8:0] C;  // 组间进位链（C[0]=C_in, C[8]=C_out）
    assign C[0] = C_in;

    // 计算组间进位C[j]
    genvar j;
    generate
        for (j = 0; j < 8; j = j + 1) begin : group
            wire [3:0] G_group = G[j*4 +3 : j*4];
            wire [3:0] P_group = P[j*4 +3 : j*4];

            assign GG[j] = G_group[3] | 
                          (P_group[3] & G_group[2]) | 
                          (P_group[3] & P_group[2] & G_group[1]) | 
                          (P_group[3] & P_group[2] & P_group[1] & G_group[0]);
            assign PG[j] = P_group[3] & P_group[2] & P_group[1] & P_group[0];
            assign C[j+1] = GG[j] | (PG[j] & C[j]);
        end
    endgenerate
    assign C_out = C[8];

    // 组内并行计算进位（正确生成进位输出Carry）
    wire [31:0] Carry;
    generate
        for (j = 0; j < 8; j = j + 1) begin : group_carry
            wire C_group = C[j];
            wire [3:0] G_group = G[j*4 +3 : j*4];
            wire [3:0] P_group = P[j*4 +3 : j*4];

            assign Carry[j*4 +0] = G_group[0] | (P_group[0] & C_group);
            assign Carry[j*4 +1] = G_group[1] | (P_group[1] & G_group[0]) | 
                                  (P_group[1] & P_group[0] & C_group);
            assign Carry[j*4 +2] = G_group[2] | (P_group[2] & G_group[1]) | 
                                  (P_group[2] & P_group[1] & G_group[0]) | 
                                  (P_group[2] & P_group[1] & P_group[0] & C_group);
            assign Carry[j*4 +3] = C[j+1]; // 组最高位进位直接使用C[j+1]
        end
    endgenerate

    // 生成进位输入Cin
    wire [31:0] Cin;
    assign Cin = {Carry[30:0],C_in};
    // 正确计算每位和：Sum = P ^ Cin（而非Carry）
    assign Sum = P ^ Cin;

endmodule