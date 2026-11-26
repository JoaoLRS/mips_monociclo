//==========================================================
//Equipe: Alisson Xavier e Joao Lucas Ribeiro
//Atividade: Projeto 02 - 2a VA
//Disciplina: Arquitetura e Organizacao de Computadores
//Semestre: 2026.2
//Questao: validacao integrada do conjunto MIPS de 28 instrucoes.
//========================================================== 
`timescale 1ns/1ps
module tb_isa;
    reg clock, reset;
    wire [31:0] PC_out, ULA_out, DMem_out;
    integer checks, errors;
    mips #(.IMEM_FILE("programs/isa_completa.list")) dut(
        .clock(clock),.reset(reset),.PC_out(PC_out),.ULA_out(ULA_out),.DMem_out(DMem_out));
    always #5 clock=~clock;
    task expect32;
        input [31:0] actual, expected;
        input [8*32-1:0] label;
        begin
            checks=checks+1;
            if (actual !== expected) begin
                errors=errors+1;
                $display("FAIL %0s got=%h expected=%h",label,actual,expected);
            end
        end
    endtask
    initial begin
        clock=0; reset=1; checks=0; errors=0;
        #2 reset=0;
        repeat(26) @(posedge clock); #1;
        expect32(PC_out,32'd104,"PC apos 26 instrucoes");
        expect32(dut.registers.registers[1],32'hffffffff,"addi negativo");
        expect32(dut.registers.registers[2],32'd1,"addi positivo");
        expect32(dut.registers.registers[3],32'd0,"add");
        expect32(dut.registers.registers[4],32'd2,"sub");
        expect32(dut.registers.registers[5],32'd1,"and");
        expect32(dut.registers.registers[6],32'hffffffff,"or");
        expect32(dut.registers.registers[7],32'hfffffffe,"xor");
        expect32(dut.registers.registers[8],32'd0,"nor");
        expect32(dut.registers.registers[9],32'd1,"slt signed");
        expect32(dut.registers.registers[10],32'd0,"sltu unsigned");
        expect32(dut.registers.registers[11],32'h80000000,"sll 31");
        expect32(dut.registers.registers[12],32'd1,"srl 31");
        expect32(dut.registers.registers[13],32'hffffffff,"sra 31");
        expect32(dut.registers.registers[14],32'd2,"sllv");
        expect32(dut.registers.registers[15],32'h40000000,"srlv");
        expect32(dut.registers.registers[16],32'hc0000000,"srav");
        expect32(dut.registers.registers[17],32'hfffffffe,"addi -2");
        expect32(dut.registers.registers[18],32'h00008001,"andi zero extend");
        expect32(dut.registers.registers[19],32'h00008001,"ori zero extend");
        expect32(dut.registers.registers[20],32'h00008000,"xori zero extend");
        expect32(dut.registers.registers[21],32'd1,"slti signed");
        expect32(dut.registers.registers[22],32'd0,"sltiu sign-extended immediate");
        expect32(dut.registers.registers[23],32'h12340000,"lui");
        expect32(dut.data_memory.mem[0],32'hffffffff,"sw");
        expect32(dut.registers.registers[24],32'hffffffff,"lw");
        expect32(dut.registers.registers[25],32'd0,"branch inicial nao alterou destino");
        @(posedge clock); #1; expect32(PC_out,32'd116,"beq tomado");
        @(posedge clock); #1; expect32(PC_out,32'd120,"bne tomado");
        @(posedge clock); #1; expect32(dut.registers.registers[26],32'd5,"alvo de bne");
        @(posedge clock); #1; expect32(PC_out,32'd128,"beq nao tomado");
        @(posedge clock); #1; expect32(PC_out,32'd132,"bne nao tomado");
        @(posedge clock); #1; expect32(PC_out,32'd140,"j antes do jal");
        @(posedge clock); #1;
        expect32(PC_out,32'd156,"jal alvo");
        expect32(dut.registers.registers[31],32'd144,"jal link PC+4");
        @(posedge clock); #1;
        expect32(dut.registers.registers[27],32'd7,"instrucao na subrotina");
        @(posedge clock); #1; expect32(PC_out,32'd144,"jr retorna");
        @(posedge clock); #1; expect32(dut.registers.registers[28],32'd8,"retorno da subrotina");
        @(posedge clock); #1; expect32(PC_out,32'd164,"j apos retorno");
        @(posedge clock); #1; expect32(dut.registers.registers[29],32'd9,"instrucao final");
        @(posedge clock); #1; expect32(PC_out,32'd168,"beq com offset negativo");
        expect32(dut.registers.registers[0],32'd0,"$zero imutavel");
        if (errors==0) $display("PASS tb_isa: %0d verificacoes; 28 instrucoes exercitadas",checks);
        else $display("FAIL tb_isa: %0d erros em %0d verificacoes",errors,checks);
        $finish;
    end
    initial begin #1000; $display("FAIL tb_isa: timeout"); $finish; end
endmodule
