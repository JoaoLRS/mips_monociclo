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
    reg [31:0] mem [0:MEM_WORDS-1];
    wire [29:0] word_address = Address[31:2];
    reg write_enable;
    reg [29:0] write_address;
    reg [31:0] write_data;

    // Publica os sinais juntos apos a propagacao combinacional, no mesmo
    // instante simulado. O bloco continua sensivel a mudancas nas entradas.
    always @(MemWrite or Address or WriteData) begin
        {write_enable, write_address, write_data} <= {MemWrite, Address[31:2], WriteData};
    end

    // Escrita assincrona para simulacao, sem inferencia de RAM de bloco.
    always @(write_enable or write_address or write_data) begin
        if (write_enable && (write_address < MEM_WORDS))
            mem[write_address] = write_data;
    end

    // Endereco de byte para palavra. Leituras fora da faixa retornam X.
    assign ReadData = !MemRead ? 32'bz :
                      (word_address < MEM_WORDS) ? mem[word_address] : 32'bx;
endmodule
