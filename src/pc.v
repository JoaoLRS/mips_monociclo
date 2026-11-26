`timescale 1ns/1ps

module PC (
    input         clock,
    input  [31:0] nextPC,
    output reg [31:0] PC
);
    // A especificacao nao define reset para o PC. O valor inicial permite
    // iniciar a simulacao no endereco zero; em FPGA, isso tambem e sintetizavel
    // por ferramentas que suportam inicializacao de registradores.
    initial PC = 32'b0;

    always @(posedge clock)
        PC <= nextPC;
endmodule
