//==========================================================
//Equipe: Alisson Xavier e Joao Lucas Ribeiro
//Atividade: Projeto 02 - 2a VA
//Disciplina: Arquitetura e Organizacao de Computadores
//Semestre: 2026.2
//Questao: teste inicial do nucleo MIPS.
//==========================================================
`timescale 1ns/1ps
module tb_mips;
    reg clock, reset;
    wire [31:0] PC_out, ULA_out, DMem_out;
    integer checks, errors;
    mips dut(.clock(clock), .reset(reset), .PC_out(PC_out),
             .ULA_out(ULA_out), .DMem_out(DMem_out));
    always #5 clock=~clock;

    task expect32;
        input [31:0] actual, expected;
        input [8*40-1:0] label;
        begin
            checks=checks+1;
            if (actual !== expected) begin
                errors=errors+1;
                $display("FAIL %s: got=%h expected=%h", label, actual, expected);
            end
        end
    endtask

    initial begin
        clock=0; reset=1; checks=0; errors=0;
        #2 reset=0; // antes da primeira borda; PC inicia em zero no modulo PC.
        expect32(PC_out,0,"PC inicial");
        @(posedge clock); #1;
        expect32(PC_out,4,"PC apos addi 1");
        expect32(dut.registers.registers[1],5,"addi $1");
        @(posedge clock); #1;
        expect32(PC_out,8,"PC apos addi 2");
        expect32(dut.registers.registers[2],10,"addi $2");
        @(posedge clock); #1;
        expect32(PC_out,12,"PC apos add");
        expect32(dut.registers.registers[3],15,"add $3");
        @(posedge clock); #1;
        expect32(PC_out,16,"PC apos sw");
        expect32(dut.data_memory.mem[0],15,"sw memoria[0]");
        @(posedge clock); #1;
        expect32(PC_out,20,"PC apos lw");
        expect32(dut.registers.registers[4],15,"lw $4");
        @(posedge clock); #1;
        expect32(PC_out,28,"beq pula ori");
        expect32(dut.registers.registers[5],0,"ori foi pulada");
        @(posedge clock); #1;
        expect32(PC_out,0,"j retorna ao inicio");
        expect32(dut.registers.registers[0],0,"$zero permanece zero");
        if (errors == 0) $display("PASS tb_mips: %0d verificacoes", checks);
        else $display("FAIL tb_mips: %0d erros em %0d verificacoes", errors, checks);
        $finish;
    end
    initial begin #1000; $display("FAIL tb_mips: timeout"); $finish; end
endmodule
