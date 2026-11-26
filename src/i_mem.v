//==========================================================
//Equipe: Alisson Xavier e Joao Lucas Ribeiro
//Atividade: Projeto 02 - 2a VA
//Disciplina: Arquitetura e Organizacao de Computadores
//Semestre: 2026.2
//Questao: memoria de instrucoes | ROM assincrona carregada de arquivo texto.
//==========================================================
`timescale 1ns/1ps

module i_mem #(
    parameter MEM_WORDS = 256,
    parameter INIT_FILE = "instruction.list"
) (
    input  [31:0] address,
    output [31:0] i_out
);
    localparam ADDR_BITS = (MEM_WORDS <= 2) ? 1 : $clog2(MEM_WORDS);
    reg [31:0] mem [0:MEM_WORDS-1];
    wire [29:0] word_address = address[31:2];

    initial begin
        $readmemb(INIT_FILE, mem);
    end

    // PC e enderecos sao em bytes; cada palavra ocupa quatro bytes.
    // O endereco recebido e de byte; enderecos fora da profundidade retornam X.
    assign i_out = (word_address < MEM_WORDS) ? mem[address[ADDR_BITS+1:2]] : 32'bx;
endmodule
