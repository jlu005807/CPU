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

    // �����ɣ�GG�����鴫����PG���źţ�8�飬ÿ��4λ��
    wire [7:0] GG, PG;
    wire [8:0] C;  // ����λ����C[0]=C_in, C[8]=C_out��
    assign C[0] = C_in;

    // ��������λC[j]
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

    // ���ڲ��м����λ����ȷ���ɽ�λ���Carry��
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
            assign Carry[j*4 +3] = C[j+1]; // �����λ��λֱ��ʹ��C[j+1]
        end
    endgenerate

    // ���ɽ�λ����Cin
    wire [31:0] Cin;
    assign Cin = {Carry[30:0],C_in};
    // ��ȷ����ÿλ�ͣ�Sum = P ^ Cin������Carry��
    assign Sum = P ^ Cin;

endmodule