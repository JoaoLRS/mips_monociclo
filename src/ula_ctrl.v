// Grupo: João e Alisson | Projeto 02: MIPS monociclo em Verilog
// Disciplina: Arquitetura e Organização de Computadores | Semestre: preencher
// Questao: controle da ULA | Converte ALUOp/funct para OP de 4 bits.
`timescale 1ns/1ps

module ula_ctrl (
    input  [3:0] ALUOp,
    input  [5:0] funct,
    output reg [3:0] OP
);
    localparam ALU_AND=4'h0, ALU_OR=4'h1, ALU_ADD=4'h2, ALU_XOR=4'h3,
               ALU_NOR=4'h4, ALU_SUB=4'h6, ALU_SLT=4'h7, ALU_SLTU=4'h8,
               ALU_SLL=4'h9, ALU_SRL=4'hA, ALU_SRA=4'hB;

    always @* begin
        // ALUOp=4'hF indica instrucao R; os demais valores selecionam
        // diretamente operacoes para instrucoes I ou enderecos.
        if (ALUOp == 4'hF) begin
            case (funct)
                6'h20: OP = ALU_ADD; // add
                6'h22: OP = ALU_SUB; // sub
                6'h24: OP = ALU_AND;
                6'h25: OP = ALU_OR;
                6'h26: OP = ALU_XOR;
                6'h27: OP = ALU_NOR;
                6'h2A: OP = ALU_SLT;
                6'h2B: OP = ALU_SLTU;
                6'h00: OP = ALU_SLL;
                6'h02: OP = ALU_SRL;
                6'h03: OP = ALU_SRA;
                6'h04: OP = ALU_SLL; // sllv
                6'h06: OP = ALU_SRL; // srlv
                6'h07: OP = ALU_SRA; // srav
                default: OP = ALU_ADD;
            endcase
        end else begin
            OP = ALUOp;
        end
    end
endmodule
