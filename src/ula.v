// Grupo: João e Alisson | Projeto 02: MIPS monociclo em Verilog
// Disciplina: Arquitetura e Organização de Computadores | Semestre: preencher
// Questao: ULA | Operacoes aritmeticas, logicas, comparacoes e shifts.
`timescale 1ns/1ps

module ula (
    input  [31:0] In1,
    input  [31:0] In2,
    input  [3:0]  OP,
    output reg [31:0] result,
    output Zero_flag
);
    localparam ALU_AND=4'h0, ALU_OR=4'h1, ALU_ADD=4'h2, ALU_XOR=4'h3,
               ALU_NOR=4'h4, ALU_SUB=4'h6, ALU_SLT=4'h7, ALU_SLTU=4'h8,
               ALU_SLL=4'h9, ALU_SRL=4'hA, ALU_SRA=4'hB;

    // As comparacoes signed e unsigned sao distintas; shifts usam 5 bits.
    always @* begin
        case (OP)
            ALU_AND:  result = In1 & In2;
            ALU_OR:   result = In1 | In2;
            ALU_ADD:  result = In1 + In2;
            ALU_XOR:  result = In1 ^ In2;
            ALU_NOR:  result = ~(In1 | In2);
            ALU_SUB:  result = In1 - In2;
            ALU_SLT:  result = ($signed(In1) < $signed(In2)) ? 32'd1 : 32'd0;
            ALU_SLTU: result = (In1 < In2) ? 32'd1 : 32'd0;
            ALU_SLL:  result = In1 << In2[4:0];
            ALU_SRL:  result = In1 >> In2[4:0];
            ALU_SRA:  result = $signed(In1) >>> In2[4:0];
            default:  result = 32'b0;
        endcase
    end

    assign Zero_flag = (result == 32'b0);
endmodule
