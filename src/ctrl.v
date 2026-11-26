// Grupo: João e Alisson | Projeto 02: MIPS monociclo em Verilog
// Disciplina: Arquitetura e Organização de Computadores | Semestre: preencher
// Questão: unidade de controle | Decodifica opcode/funct e sinais do datapath.
`timescale 1ns/1ps

module ctrl (
    input  [5:0] opcode,
    input  [5:0] funct,
    output reg       RegDst,
    output reg       ALUSrc,
    output reg       MemToReg,
    output reg       RegWrite,
    output reg       MemRead,
    output reg       MemWrite,
    output reg       Branch,
    output reg       BranchNE,
    output reg       Jump,
    output reg       Jal,
    output reg       Jr,
    output reg       ImmZeroExt,
    output reg       Lui,
    output reg [3:0] ALUOp
);
    localparam ALU_AND=4'h0, ALU_OR=4'h1, ALU_ADD=4'h2, ALU_XOR=4'h3,
               ALU_SUB=4'h6, ALU_SLT=4'h7, ALU_SLTU=4'h8, ALU_RTYPE=4'hF;

    always @* begin
        RegDst=0; ALUSrc=0; MemToReg=0; RegWrite=0;
        MemRead=0; MemWrite=0; Branch=0; BranchNE=0;
        Jump=0; Jal=0; Jr=0; ImmZeroExt=0; Lui=0;
        ALUOp=ALU_ADD;

        case (opcode)
            6'h00: begin // Tipo R: aceitar apenas o subconjunto pedido.
                ALUOp=ALU_RTYPE;
                case (funct)
                    6'h20, 6'h22, 6'h24, 6'h25, 6'h26, 6'h27,
                    6'h2A, 6'h2B, 6'h00, 6'h02, 6'h03,
                    6'h04, 6'h06, 6'h07: begin RegDst=1; RegWrite=1; end
                    6'h08: Jr=1;
                    default: begin end // R desconhecida nao altera o estado.
                endcase
            end
            6'h02: Jump=1; // j
            6'h03: begin Jump=1; Jal=1; RegWrite=1; end // jal
            6'h04: begin Branch=1; ALUOp=ALU_SUB; end // beq
            6'h05: begin Branch=1; BranchNE=1; ALUOp=ALU_SUB; end // bne
            6'h08: begin ALUSrc=1; RegWrite=1; ALUOp=ALU_ADD; end // addi
            6'h0C: begin ALUSrc=1; RegWrite=1; ImmZeroExt=1; ALUOp=ALU_AND; end // andi
            6'h0D: begin ALUSrc=1; RegWrite=1; ImmZeroExt=1; ALUOp=ALU_OR; end // ori
            6'h0E: begin ALUSrc=1; RegWrite=1; ImmZeroExt=1; ALUOp=ALU_XOR; end // xori
            6'h0A: begin ALUSrc=1; RegWrite=1; ALUOp=ALU_SLT; end // slti
            6'h0B: begin ALUSrc=1; RegWrite=1; ALUOp=ALU_SLTU; end // sltiu
            6'h0F: begin ALUSrc=1; RegWrite=1; Lui=1; end // lui
            6'h23: begin ALUSrc=1; MemToReg=1; RegWrite=1; MemRead=1; end // lw
            6'h2B: begin ALUSrc=1; MemWrite=1; end // sw
            default: begin end // instrucoes nao implementadas: segue PC+4
        endcase
    end
endmodule
