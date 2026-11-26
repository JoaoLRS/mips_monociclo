//==========================================================
//Equipe: Alisson Xavier e Joao Lucas Ribeiro
//Atividade: Projeto 02 - 2a VA
//Disciplina: Arquitetura e Organizacao de Computadores
//Semestre: 2026.2
//Questao: memoria de dados | RAM de palavras com interface assíncrona.
//==========================================================
`timescale 1ns/1ps

module d_mem #(
    parameter MEM_WORDS = 256
) (
    input  [31:0]  Address,
    input  [31:0]  WriteData,
    output [31:0]  ReadData,
    input         MemWrite,
    input         MemRead
);
    localparam ADDR_BITS = (MEM_WORDS <= 2) ? 1 : $clog2(MEM_WORDS);
    reg [31:0] mem [0:MEM_WORDS-1];
    wire [29:0] word_address = Address[31:2];

    // Modelagem para simulacao: grava quando qualquer entrada da escrita muda
    // enquanto MemWrite=1. RAMs fisicas usuais exigem escrita sincronizada;
    // esta descricao assincrona pode nao inferir bloco de RAM em FPGA.
    always @(*) begin
        if (MemWrite && (word_address < MEM_WORDS))
            mem[Address[ADDR_BITS+1:2]] = WriteData;
    end

    // Endereco de byte para palavra. Leituras fora da faixa retornam X.
    assign ReadData = !MemRead ? 32'bz :
                      (word_address < MEM_WORDS) ? mem[Address[ADDR_BITS+1:2]] : 32'bx;
endmodule
