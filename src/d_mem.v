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

    // Modelagem para simulacao: aguarda a propagacao combinacional de endereco
e dado antes de gravar. Isso evita capturar valores transitorios quando
    // instrucoes sw consecutivas atualizam o PC e o datapath na mesma unidade.
    // RAMs fisicas usuais exigem escrita sincronizada; este modelo pode nao
    // inferir bloco de RAM em FPGA.
    always @(MemWrite or Address or WriteData) begin
        if (MemWrite) begin
            #1;
            if (MemWrite && (word_address < MEM_WORDS))
                mem[Address[ADDR_BITS+1:2]] = WriteData;
        end
    end

    // Endereco de byte para palavra. Leituras fora da faixa retornam X.
    assign ReadData = !MemRead ? 32'bz :
                      (word_address < MEM_WORDS) ? mem[Address[ADDR_BITS+1:2]] : 32'bx;
endmodule
