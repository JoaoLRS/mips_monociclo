//==========================================================
//Equipe: Alisson Xavier e Joao Lucas Ribeiro
//Atividade: Projeto 02 - 2a VA
//Disciplina: Arquitetura e Organizacao de Computadores
//Semestre: 2026.2
//Questao: nucleo MIPS | Integra datapath, memorias, ULA e controle.
//========================================================== 
`timescale 1ns/1ps

module mips #(
    parameter IMEM_WORDS = 256,
    parameter DMEM_WORDS = 256,
    parameter IMEM_FILE = "instruction.list"
) (
    input         clock,
    input         reset,
    output [31:0]  PC_out,
    output [31:0]  ULA_out,
    output [31:0]  DMem_out
);
    wire [31:0] pc, next_pc, instruction, pc_plus4;
    wire [31:0] read_data1, read_data2, reg_write_data;
    wire [31:0] sign_imm, extended_imm, alu_in1, alu_in2, alu_result;
    wire [31:0] mem_read_data, branch_target, jump_target;
    wire [31:0] shift_amount;
    wire [4:0]  write_register;
    wire [3:0]  alu_op, alu_control;
    wire zero_flag;
    wire RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite;
    wire Branch, BranchNE, Jump, Jal, Jr, ImmZeroExt, Lui;
    wire branch_taken;
    wire is_shift_imm, is_shift_var;

    PC pc_register(.clock(clock), .nextPC(next_pc), .PC(pc));
    i_mem #(.MEM_WORDS(IMEM_WORDS), .INIT_FILE(IMEM_FILE)) instruction_memory
        (.address(pc), .i_out(instruction));

    ctrl control_unit(
        .opcode(instruction[31:26]), .funct(instruction[5:0]),
        .RegDst(RegDst), .ALUSrc(ALUSrc),
        .MemToReg(MemToReg), .RegWrite(RegWrite), .MemRead(MemRead),
        .MemWrite(MemWrite), .Branch(Branch), .BranchNE(BranchNE),
        .Jump(Jump), .Jal(Jal), .Jr(Jr), .ImmZeroExt(ImmZeroExt),
        .Lui(Lui), .ALUOp(alu_op)
    );

    regfile registers(
        .ReadAddr1(instruction[25:21]), .ReadAddr2(instruction[20:16]),
        .ReadData1(read_data1), .ReadData2(read_data2), .Clock(clock),
        .WriteAddr(write_register), .WriteData(reg_write_data),
        .RegWrite(RegWrite), .Reset(reset)
    );

    ula_ctrl alu_control_unit(.ALUOp(alu_op), .funct(instruction[5:0]), .OP(alu_control));

    assign is_shift_imm = (instruction[31:26] == 6'h00) &&
        ((instruction[5:0] == 6'h00) || (instruction[5:0] == 6'h02) || (instruction[5:0] == 6'h03));
    assign is_shift_var = (instruction[31:26] == 6'h00) &&
        ((instruction[5:0] == 6'h04) || (instruction[5:0] == 6'h06) || (instruction[5:0] == 6'h07));

    assign sign_imm = {{16{instruction[15]}}, instruction[15:0]};
    assign extended_imm = ImmZeroExt ? {16'b0, instruction[15:0]} : sign_imm;
    assign alu_in1 = (is_shift_imm || is_shift_var) ? read_data2 : read_data1;
    assign shift_amount = is_shift_imm ? {27'b0, instruction[10:6]} : read_data1;
    assign alu_in2 = (is_shift_imm || is_shift_var) ? shift_amount :
                     (ALUSrc ? extended_imm : read_data2);

    ula alu(.In1(alu_in1), .In2(alu_in2), .OP(alu_control),
            .result(alu_result), .Zero_flag(zero_flag));

    d_mem #(.MEM_WORDS(DMEM_WORDS)) data_memory(
        .Address(alu_result), .WriteData(read_data2), .ReadData(mem_read_data),
        .MemWrite(MemWrite), .MemRead(MemRead)
    );

    assign write_register = Jal ? 5'd31 : (RegDst ? instruction[15:11] : instruction[20:16]);
    assign reg_write_data = Jal ? pc_plus4 : (Lui ? {instruction[15:0], 16'b0} :
                             (MemToReg ? mem_read_data : alu_result));

    assign pc_plus4 = pc + 32'd4;
    assign branch_target = pc_plus4 + (sign_imm << 2);
    assign jump_target = {pc_plus4[31:28], instruction[25:0], 2'b00};
    assign branch_taken = Branch && (BranchNE ? !zero_flag : zero_flag);
    assign next_pc = Jr ? read_data1 :
                     (Jump ? jump_target : (branch_taken ? branch_target : pc_plus4));

    assign PC_out = pc;
    assign ULA_out = alu_result;
    assign DMem_out = mem_read_data;
endmodule
