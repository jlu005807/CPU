module CPU(
           input wire clk,
           input wire reset,
           input wire[31:0] base_ram_data,
           output wire[19:0] base_ram_addr,
           output wire[3:0] base_ram_be_n,
           output wire base_ram_ce_n,
           output wire base_ram_oe_n,
           output wire base_ram_we_n,
           inout wire[31:0] ext_ram_data,
           output wire[19:0] ext_ram_addr,
           output wire[3:0] ext_ram_be_n,
           output wire ext_ram_ce_n,
           output wire ext_ram_oe_n,
           output wire ext_ram_we_n
       );

//IF stage

//PC
wire [31:0] IF_PC;
wire [31:0] IF_npc;
wire [31:0] IF_correct_pc;
wire IF_pc_flush;
wire IF_pc_STALL;
PC pc(
       .clk(clk),
       .reset(reset),
       .flush(IF_pc_flush),
       .STALL(IF_pc_STALL),
       .correct_pc(IF_correct_pc),
       .npc(IF_npc),
       .PC(IF_PC)
   );

//BHT
wire BHT_update;
wire BHT_branch_taken;
wire BHT_prediction;
wire[31:0] BHT_branch_target_PC;
BHT bht(
        .clk(clk),
        .reset(reset),
        .PC_in(IF_PC),
        .update_PC(BHT_branch_target_PC),
        .update(BHT_update),
        .branch_taken(BHT_branch_taken),
        .prediction(BHT_prediction)
    );

//BTB
wire BTB_update;
wire[31:0] BTB_branch_target;
wire [31:0] BTB_branch_target_PC;
wire [31:0]BTB_prediction_PC;

BTB btb(
        .clk(clk),
        .reset(reset),
        .PC_in(IF_PC),
        .update(BTB_update),
        .branch_target(BTB_branch_target),
        .branch_target_PC(BTB_branch_target_PC),
        .prediction_PC(BTB_prediction_PC)
    );

wire IF_IS_JR;
wire[31:0] IF_instruction;
Resolve_Branch resolve_branch(
                   .PC(IF_PC),
                   .instruction(IF_instruction),
                   .prediction_PC(BTB_prediction_PC),
                   .prediction_taken(BHT_prediction),
                   .IS_JR(IF_IS_JR),
                   .resolved_PC(IF_npc)
               );

//IM
assign base_ram_be_n=4'b0000;
assign base_ram_ce_n=1'b0;
assign base_ram_oe_n=1'b0;
assign base_ram_we_n=1'b1;
assign base_ram_addr = IF_PC[21:2];

//instruction memory
assign IF_instruction = base_ram_data;

//IF/ID pipeline registers
wire IF_ID_Register_flush;
wire IF_ID_Register_STALL;
wire IF_ID_IS_JR;
wire[31:0] IF_ID_instruction;
wire[31:0] IF_ID_PC;
wire[31:0] IF_ID_prediction_PC;
IF_ID_Register if_id_register(
                   .clk(clk),
                   .reset(reset),
                   .flush(IF_ID_Register_flush),
                   .STALL(IF_ID_Register_STALL),
                   .IS_JR_in(IF_IS_JR),
                   .instruction_in(IF_instruction),
                   .PC_in(IF_PC),
                   .prediction_PC_in(BTB_prediction_PC),
                   .IS_JR(IF_ID_IS_JR),
                   .instruction(IF_ID_instruction),
                   .PC(IF_ID_PC),
                   .prediction_PC(IF_ID_prediction_PC)
               );

//ID stage

//sign
wire [1:0] ID_RegDst;
wire ID_RegWrite;
wire[1:0] ID_ALUsrc;
wire[2:0] ID_PCsrc;
wire ID_MemRead;
wire ID_MemWrite;
wire[1:0] ID_MemtoReg;
wire ID_SaFrom;
wire ID_MemByte;
wire[1:0] ID_Extension;
wire[3:0] ID_ALUop;
Control control(
            .IS_JR(IF_ID_IS_JR),
            .OP_code(IF_ID_instruction[31:26]),
            .RegDst(ID_RegDst),
            .RegWrite(ID_RegWrite),
            .ALUsrc(ID_ALUsrc),
            .PCsrc(ID_PCsrc),
            .MemRead(ID_MemRead),
            .MemWrite(ID_MemWrite),
            .MemtoReg(ID_MemtoReg),
            .SaFrom(ID_SaFrom),
            .MemByte(ID_MemByte),
            .Extension(ID_Extension),
            .ALUop(ID_ALUop)
        );

//ID_number
wire[4:0] ID_Regfile_Rs;
wire[4:0] ID_Regfile_Rt;
wire[4:0] ID_Regfile_Rd;
wire[25:0] ID_immediate;
wire[5:0] ID_funct;
wire[4:0] ID_sa;

assign ID_Regfile_Rs = IF_ID_instruction[25:21];
assign ID_Regfile_Rt = IF_ID_instruction[20:16];
assign ID_Regfile_Rd = IF_ID_instruction[15:11];
assign ID_immediate = IF_ID_instruction[25:0];
assign ID_funct = IF_ID_instruction[5:0];
assign ID_sa = IF_ID_instruction[10:6];


//Regfile
wire[31:0] ID_RegfileRs_Data;
wire[31:0] ID_RegfileRt_Data;
wire[31:0] Regfile_RegWriteData;
wire[4:0] Regfile_Write_Address;
wire Regfile_RegWrite;

regfile regfile(
            .clk(clk),
            .RegWrite(Regfile_RegWrite),
            .rs(ID_Regfile_Rs),
            .rt(ID_Regfile_Rt),
            .rd(Regfile_Write_Address),
            .RegWriteData(Regfile_RegWriteData),
            .RegfileRs_Data(ID_RegfileRs_Data),
            .RegfileRt_Data(ID_RegfileRt_Data)
        );

//Extension
wire[31:0]ID_Extension_Data;
Extension extension(
              .immediate(ID_immediate),
              .ena(ID_Extension),
              .Extension_Data(ID_Extension_Data)
          );

//Address RegDst
wire[4:0] ID_RegfileWrite_Address;
assign ID_RegfileWrite_Address = (ID_RegDst==2'b00)?ID_Regfile_Rt:((ID_RegDst==2'b01)?ID_Regfile_Rd:5'b11111);

//Address SaFrom
wire[4:0] correct_sa;
assign correct_sa=ID_SaFrom?5'b10000:ID_sa;

//ID/EX pipeline registers
wire ID_EX_Register_flush;
wire ID_EX_Register_STALL;
wire[31:0] ID_EX_PC;
wire[31:0] ID_EX_prediction_PC;
wire[31:0] ID_EX_RegfileRs_Data;
wire[31:0] ID_EX_RegfileRt_Data;
wire[4:0] ID_EX_RegfileWrite_Address;
wire[4:0] ID_EX_RegisterRs;
wire[4:0] ID_EX_RegisterRt;
wire[31:0] ID_EX_Extension_Data;
wire[5:0] ID_EX_funct;
wire[4:0] ID_EX_sa;
wire[1:0] ID_EX_ALUsrc;
wire ID_EX_RegWrite;
wire[2:0] ID_EX_PCsrc;
wire ID_EX_MemRead;
wire ID_EX_MemWrite;
wire[1:0] ID_EX_MemtoReg;
wire ID_EX_MemByte;
wire[3:0] ID_EX_ALUop;
ID_EX_Register id_ex_register(
                   //sign
                   .clk(clk),
                   .reset(reset),
                   .flush(ID_EX_Register_flush),
                   .STALL(ID_EX_Register_STALL),
                   //PC
                   .PC_in(IF_ID_PC),
                   .prediction_PC_in(IF_ID_prediction_PC),
                   .PC(ID_EX_PC),
                   .prediction_PC(ID_EX_prediction_PC),
                   //input
                   .RegfileRs_Data_in(ID_RegfileRs_Data),
                   .RegfileRt_Data_in(ID_RegfileRt_Data),
                   .ID_EX_RegfileWrite_Address_in(ID_RegfileWrite_Address),
                   .ID_EX_RegisterRs_in(ID_Regfile_Rs),
                   .ID_EX_RegisterRt_in(ID_Regfile_Rt),
                   .Extension_Data_in(ID_Extension_Data),
                   .funct_in(ID_funct),
                   .sa_in(correct_sa),
                   .ALUsrc_in(ID_ALUsrc),
                   .RegWrite_in(ID_RegWrite),
                   .PCsrc_in(ID_PCsrc),
                   .MemRead_in(ID_MemRead),
                   .MemWrite_in(ID_MemWrite),
                   .MemtoReg_in(ID_MemtoReg),
                   .MemByte_in(ID_MemByte),
                   .ALUop_in(ID_ALUop),
                   //output
                   .RegfileRs_Data(ID_EX_RegfileRs_Data),
                   .RegfileRt_Data(ID_EX_RegfileRt_Data),
                   .ID_EX_RegfileWrite_Address(ID_EX_RegfileWrite_Address),
                   .ID_EX_RegisterRs(ID_EX_RegisterRs),
                   .ID_EX_RegisterRt(ID_EX_RegisterRt),
                   .Extension_Data(ID_EX_Extension_Data),
                   .funct(ID_EX_funct),
                   .sa(ID_EX_sa),
                   .ALUsrc(ID_EX_ALUsrc),
                   .RegWrite(ID_EX_RegWrite),
                   .PCsrc(ID_EX_PCsrc),
                   .MemRead(ID_EX_MemRead),
                   .MemWrite(ID_EX_MemWrite),
                   .MemtoReg(ID_EX_MemtoReg),
                   .MemByte(ID_EX_MemByte),
                   .ALUop(ID_EX_ALUop)
               );

//EX stage

//ALU_control
wire[7:0] EX_ALU_Ctrl;
ALU_Control alu_control(
                .ALU_op(ID_EX_ALUop),
                .funct(ID_EX_funct),
                .ALU_ctrl(EX_ALU_Ctrl)
            );

//ALU
wire[31:0] EX_ALU_OUT;
wire[31:0] EX_ALU_OP1;
wire[31:0] EX_ALU_OP2;
wire[31:0] ForwardA_Data;
wire[31:0] ForwardB_Data;

//address op_data
assign EX_ALU_OP1=ForwardA_Data;
assign EX_ALU_OP2=(ID_EX_ALUsrc==2'b00)?ForwardB_Data:((ID_EX_ALUsrc==2'b01)?ID_EX_Extension_Data:32'b0);
ALU alu(
        .ALU_ctrl(EX_ALU_Ctrl),
        .sa(ID_EX_sa),
        .OP1(EX_ALU_OP1),
        .OP2(EX_ALU_OP2),
        .ALU_OUT(EX_ALU_OUT)
    );

//branch_check
wire branch_taken;
wire is_branch_instruction;
wire branch_is_real;
wire[31:0] PCplus4;
wire[31:0] branch_target;
assign PCplus4 = ID_EX_PC+4;

branch_check branch_check(
                 .PCsrc(ID_EX_PCsrc),
                 .PCpuls4(PCplus4),
                 .prediction_PC(ID_EX_prediction_PC),
                 .Extension_Data(ID_EX_Extension_Data),
                 .ALU_out(EX_ALU_OUT),
                 .RegfileRs_Data(ID_EX_RegfileRs_Data),
                 .branch_taken(branch_taken),
                 .is_branch_instruction(is_branch_instruction),
                 .branch_is_real(branch_is_real),
                 .branch_target(branch_target)
             );

//Address bht and btb update

//bht
assign BHT_update = is_branch_instruction;
assign BHT_branch_taken = branch_taken;
assign BHT_branch_target_PC=ID_EX_PC;


//btb
assign BTB_update = is_branch_instruction & branch_taken; //BTB只存储需要跳转成功的指令，对于不需要跳转的指令不存储直接加四
assign BTB_branch_target = branch_target;
assign BTB_branch_target_PC = ID_EX_PC;

//Address flush
wire flush;
assign flush = is_branch_instruction & (~branch_is_real);
assign IF_pc_flush = flush;
assign IF_ID_Register_flush = flush;
assign ID_EX_Register_flush = flush;

//Address jump to correct_pc
assign IF_correct_pc = branch_target;

//EX/MEM pipeline registers
wire[31:0] EX_MEM_ALU_OUT;
wire[31:0] EX_MEM_Ext_ram_Data;
wire[31:0] EX_MEM_Ext_ram_Address;
wire[4:0] EX_MEM_RegfileWrite_Address;
wire EX_MEM_RegWrite;
wire EX_MEM_MemRead;
wire EX_MEM_MemWrite;
wire[1:0] EX_MEM_MemtoReg;
wire EX_MEM_MemByte;
wire [31:0] EX_MEM_PC;

EX_MEM_Register ex_mem_register(
                    //sign
                    .clk(clk),
                    .reset(reset),
                    //input
                    .EX_MEM_PC_in(ID_EX_PC),
                    .EX_MEM_Ext_ram_Data_in(ForwardB_Data),
                    .ALU_result_in(EX_ALU_OUT),
                    .EX_MEM_RegfileWrite_Address_in(ID_EX_RegfileWrite_Address),
                    .RegWrite_in(ID_EX_RegWrite),
                    .MemRead_in(ID_EX_MemRead),
                    .MemWrite_in(ID_EX_MemWrite),
                    .MemtoReg_in(ID_EX_MemtoReg),
                    .MemByte_in(ID_EX_MemByte),
                    //output
                    .EX_MEM_PC(EX_MEM_PC),
                    .EX_MEM_ALU_OUT(EX_MEM_ALU_OUT),
                    .EX_MEM_Ext_ram_Data(EX_MEM_Ext_ram_Data),
                    .EX_MEM_Ext_ram_Address(EX_MEM_Ext_ram_Address),
                    .EX_MEM_RegfileWrite_Address(EX_MEM_RegfileWrite_Address),
                    .RegWrite(EX_MEM_RegWrite),
                    .MemRead(EX_MEM_MemRead),
                    .MemWrite(EX_MEM_MemWrite),
                    .MemtoReg(EX_MEM_MemtoReg),
                    .MemByte(EX_MEM_MemByte)
                );

//MEM stage

//Address EX_MEM_MemByte
wire[31:0] MEM_Ext_ram_Read_Data;
wire[31:0] MEM_Ext_ram_Write_Data;
assign MEM_Ext_ram_Read_Data = EX_MEM_MemByte?{{24{ext_ram_data[7]}},ext_ram_data[7:0]}:ext_ram_data;
assign MEM_Ext_ram_Write_Data = EX_MEM_MemByte?{24'b0,EX_MEM_Ext_ram_Data[7:0]}:EX_MEM_Ext_ram_Data;

//DM
assign ext_ram_addr = EX_MEM_Ext_ram_Address[21:2];
assign ext_ram_be_n = EX_MEM_MemByte&&EX_MEM_MemWrite ?4'b1110:4'b0000;
assign ext_ram_ce_n = ~(EX_MEM_MemRead | EX_MEM_MemWrite);
assign ext_ram_oe_n = ~EX_MEM_MemRead;
assign ext_ram_we_n = ~EX_MEM_MemWrite;
//address inout sign
assign ext_ram_data = (EX_MEM_MemWrite == 1'b1) ? MEM_Ext_ram_Write_Data : 32'bz;

//Forwarding
wire[31:0] MEM_RegisterWrite_Data;
assign MEM_RegisterWrite_Data = EX_MEM_MemtoReg[1]?EX_MEM_PC+8:EX_MEM_ALU_OUT;



//MEM/WB pipeline registers
wire[31:0] MEM_WB_PC;
wire[31:0] MEM_WB_ALU_OUT;
wire[31:0] MEM_WB_Ext_ram_Data;
wire[4:0] MEM_WB_RegfileWrite_Address;
wire[1:0] MEM_WB_MemtoReg;
wire MEM_WB_RegWrite;

MEM_WB_Register mem_wb_register(
                    //sign
                    .clk(clk),
                    .reset(reset),
                    //input
                    .PC_in(EX_MEM_PC),
                    .ALU_OUT_in(EX_MEM_ALU_OUT),
                    .Ext_ram_Data_in(MEM_Ext_ram_Read_Data),
                    .MEM_WB_RegisterRd_in(EX_MEM_RegfileWrite_Address),
                    .MEM_WB_RegWrite_in(EX_MEM_RegWrite),
                    .MEM_WB_MemtoReg_in(EX_MEM_MemtoReg),
                    //output
                    .PC(MEM_WB_PC),
                    .ALU_OUT(MEM_WB_ALU_OUT),
                    .Ext_ram_Data(MEM_WB_Ext_ram_Data),
                    .MEM_WB_RegisterRd(MEM_WB_RegfileWrite_Address),
                    .MEM_WB_RegWrite(MEM_WB_RegWrite),
                    .MEM_WB_MemtoReg(MEM_WB_MemtoReg)
                );

//WB stage

//Address MemtoReg
assign  Regfile_RegWriteData= (MEM_WB_MemtoReg==2'b00)?MEM_WB_ALU_OUT:((MEM_WB_MemtoReg==2'b01)?MEM_WB_Ext_ram_Data:MEM_WB_PC+8);
assign Regfile_Write_Address = MEM_WB_RegfileWrite_Address;
assign Regfile_RegWrite = MEM_WB_RegWrite;


//Load_use_hazard
wire STALL;
Load_use_Data_Hazard load_use_hazard(
                         .clk(clk),
                         .reset(reset),
                         .IF_ID_RegisterRs(IF_ID_instruction[25:21]),
                         .IF_ID_RegisterRt(IF_ID_instruction[20:16]),
                         .ID_EX_MemRead(ID_EX_MemRead),
                         .ID_EX_RegisterRt(ID_EX_RegisterRt),
                         .STALL(STALL)
                     );
assign ID_EX_Register_STALL = STALL;
assign IF_ID_Register_STALL = STALL;
assign IF_pc_STALL =STALL;


//Forwarding
wire[1:0] ForwardA;
wire[1:0] ForwardB;

Forward forward(
            .ID_EX_RegisterRs(ID_EX_RegisterRs),
            .ID_EX_RegisterRt(ID_EX_RegisterRt),
            .EX_MEM_RegWrite(EX_MEM_RegWrite),
            .EX_MEM_RegisterRd(EX_MEM_RegfileWrite_Address),
            .MEM_WB_RegWrite(MEM_WB_RegWrite),
            .MEM_WB_RegisterRd(MEM_WB_RegfileWrite_Address),
            .ForwardA(ForwardA),
            .ForwardB(ForwardB)
        );
assign ForwardA_Data = (ForwardA==2'b00)?ID_EX_RegfileRs_Data:((ForwardA == 2'b01)?Regfile_RegWriteData:MEM_RegisterWrite_Data);
assign ForwardB_Data = (ForwardB==2'b00)?ID_EX_RegfileRt_Data:((ForwardB == 2'b01)?Regfile_RegWriteData:MEM_RegisterWrite_Data);

endmodule
