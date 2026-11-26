//==========================================================
//Equipe: Alisson Xavier e Joao Lucas Ribeiro
//Atividade: Projeto 02 - 2a VA
//Disciplina: Arquitetura e Organizacao de Computadores
//Semestre: 2026.2
//Questao: teste isolado da RAM sem clock na interface.
//==========================================================
`timescale 1ns/1ps
module tb_d_mem;
    reg [31:0] address, write_data;
    reg mem_write, mem_read;
    wire [31:0] read_data;
    integer errors;
    d_mem #(.MEM_WORDS(4)) dut(.Address(address),.WriteData(write_data),.ReadData(read_data),
        .MemWrite(mem_write),.MemRead(mem_read));
    initial begin
        errors=0; address=0; write_data=0; mem_write=0; mem_read=1; #1;
        write_data=32'h12345678; mem_write=1; #2;
        if (read_data !== 32'h12345678) begin $display("FAIL RAM escrita assincrona: %h",read_data); errors=errors+1; end
        address=4; write_data=32'h87654321; #2;
        if (read_data !== 32'h87654321) begin $display("FAIL RAM segundo endereco: %h",read_data); errors=errors+1; end
        mem_write=0; address=0; write_data=32'hffffffff; #2;
        if (read_data !== 32'h12345678) begin $display("FAIL MemWrite=0 alterou RAM: %h",read_data); errors=errors+1; end
        mem_read=0; #1;
        if (read_data !== 32'bz) begin $display("FAIL MemRead=0 nao gerou Z: %h",read_data); errors=errors+1; end
        mem_read=1; address=4; #1;
        if (read_data !== 32'h87654321) begin $display("FAIL RAM reteve endereco 4: %h",read_data); errors=errors+1; end
        if (errors==0) $display("PASS tb_d_mem"); else $display("FAIL tb_d_mem: %0d erros",errors);
        $finish;
    end
endmodule
