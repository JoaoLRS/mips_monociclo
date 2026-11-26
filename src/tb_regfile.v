//==========================================================
//Equipe: Alisson Xavier e Joao Lucas Ribeiro
//Atividade: Projeto 02 - 2a VA
//Disciplina: Arquitetura e Organizacao de Computadores
//Semestre: 2026.2
//Questao: teste isolado do banco de registradores.
//========================================================== 
`timescale 1ns/1ps
module tb_regfile;
    reg [4:0] ra1,ra2,wa;
    reg [31:0] wd;
    reg clk,wr,rst;
    wire [31:0] rd1,rd2;
    integer errors;
    regfile dut(.ReadAddr1(ra1),.ReadAddr2(ra2),.ReadData1(rd1),.ReadData2(rd2),
        .Clock(clk),.WriteAddr(wa),.WriteData(wd),.RegWrite(wr),.Reset(rst));
    initial begin
        clk=0; rst=1; wr=0; wa=0; wd=0; ra1=0; ra2=0; errors=0;
        #2 rst=0; ra1=0; ra2=1; #1;
        if (rd1 !== 0 || rd2 !== 0) begin $display("FAIL reset/$zero"); errors=errors+1; end
        wa=5; wd=32'hcafebabe; wr=1; #1;
        if (dut.registers[5] !== 0) begin $display("FAIL escrita ocorreu sem clock"); errors=errors+1; end
        clk=1; #1; clk=0; wr=0; ra1=5; ra2=0; #1;
        if (rd1 !== 32'hcafebabe || rd2 !== 0) begin $display("FAIL leituras simultaneas: %h %h",rd1,rd2); errors=errors+1; end
        wa=0; wd=32'hffffffff; wr=1; clk=1; #1; clk=0; wr=0; ra1=0; #1;
        if (rd1 !== 0) begin $display("FAIL escrita em $zero: %h",rd1); errors=errors+1; end
        rst=1; #1; rst=0; ra1=5; #1;
        if (rd1 !== 0) begin $display("FAIL reset assincrono: %h",rd1); errors=errors+1; end
        if (errors==0) $display("PASS tb_regfile"); else $display("FAIL tb_regfile: %0d erros",errors);
        $finish;
    end
endmodule
