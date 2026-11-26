//==========================================================
//Equipe: Alisson Xavier e Joao Lucas Ribeiro
//Atividade: Projeto 02 - 2a VA
//Disciplina: Arquitetura e Organizacao de Computadores
//Semestre: 2026.2
//Questao: teste isolado da ROM.
//========================================================== 
`timescale 1ns/1ps
module tb_i_mem;
    reg [31:0] address;
    wire [31:0] i_out;
    integer errors;
    i_mem #(.MEM_WORDS(3), .INIT_FILE("tb_imem.list")) dut(.address(address), .i_out(i_out));
    task expect_word;
        input [31:0] addr, expected;
        begin address=addr; #1;
            if (i_out !== expected) begin
                $display("FAIL ROM addr=%h got=%h expected=%h", addr, i_out, expected); errors=errors+1;
            end
        end
    endtask
    initial begin
        errors=0;
        expect_word(0,32'h11223344);
        expect_word(4,32'h55667788);
        expect_word(8,32'hdeadbeef);
        address=12; #1;
        if (i_out !== 32'bx) begin $display("FAIL ROM limite fora da faixa: %h", i_out); errors=errors+1; end
        if (errors==0) $display("PASS tb_i_mem"); else $display("FAIL tb_i_mem: %0d erros", errors);
        $finish;
    end
endmodule
