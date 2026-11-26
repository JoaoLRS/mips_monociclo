//==========================================================
//Equipe: Alisson Xavier e Joao Lucas Ribeiro
//Atividade: Projeto 02 - 2a VA
//Disciplina: Arquitetura e Organizacao de Computadores
//Semestre: 2026.2
//Questao: teste do programa fornecido em instructions.list.
//==========================================================
`timescale 1ns/1ps
module tb_projeto2;
    reg clock, reset;
    wire [31:0] PC_out, ULA_out, DMem_out;
    localparam DMEM_WORDS = 256;
    integer cycles, checks, errors, word_index;
    mips #(.IMEM_FILE("instructions.list"), .DMEM_WORDS(DMEM_WORDS)) dut(
        .clock(clock),.reset(reset),.PC_out(PC_out),.ULA_out(ULA_out),.DMem_out(DMem_out));
    always #5 clock=~clock;

    task expect32;
        input [31:0] actual, expected;
        input [8*36-1:0] label;
        begin
            checks=checks+1;
            if (actual !== expected) begin
                errors=errors+1;
                $display("FAIL %0s: got=%h expected=%h",label,actual,expected);
            end
        end
    endtask

    initial begin
        clock=0; reset=1; checks=0; errors=0; cycles=0;
        #2 reset=0;
        // O programa salta para o rotulo exit apos executar os sete grupos.
        for (cycles=0; cycles<100 && PC_out !== 32'd256; cycles=cycles+1) begin
            @(posedge clock); #1;
        end
        expect32(PC_out,32'd256,"PC no rotulo exit");
        expect32(dut.registers.registers[0],32'd0,"$zero imutavel");
        expect32(dut.registers.registers[8],32'hfffffffc,"$t0 final");
        expect32(dut.registers.registers[9],32'd40,"$t1 final");
        expect32(dut.registers.registers[10],32'd40,"$t2");
        expect32(dut.registers.registers[11],32'd30,"$t3");
        expect32(dut.registers.registers[12],32'd70,"$t4");
        expect32(dut.registers.registers[13],32'd27,"$t5");
        expect32(dut.registers.registers[14],32'hffffffe0,"$t6 signed");
        expect32(dut.registers.registers[16],32'd10,"$s0 final");
        expect32(dut.registers.registers[17],32'd20,"$s1 final");
        expect32(dut.registers.registers[18],32'd30,"$s2 final");
        expect32(dut.registers.registers[19],32'd40,"$s3 final");
        expect32(dut.registers.registers[22],32'd12,"$s6 base");
        expect32(dut.registers.registers[23],32'd40,"$s7 base");
        expect32(dut.registers.registers[25],32'h000fa007,"contador dos testes");
        expect32(dut.registers.registers[31],32'd228,"link PC+4 do jal");
        expect32(dut.data_memory.mem[3],32'd10,"RAM byte 12");
        expect32(dut.data_memory.mem[4],32'd20,"RAM byte 16");
        expect32(dut.data_memory.mem[12],32'd30,"RAM byte 48");
        expect32(dut.data_memory.mem[13],32'd40,"RAM byte 52");
        // Os quatro sw consecutivos nao devem gravar em outros enderecos.
        for (word_index=0; word_index<DMEM_WORDS; word_index=word_index+1) begin
            case (word_index)
                3, 4, 12, 13: begin end // Conferidos acima.
                default: begin
                    checks=checks+1;
                    if (dut.data_memory.mem[word_index] !== 32'bx) begin
                        errors=errors+1;
                        $display("FAIL escrita inesperada na RAM byte %0d: %h",
                            4*word_index, dut.data_memory.mem[word_index]);
                    end
                end
            endcase
        end
        if (errors==0) $display("PASS tb_projeto2: %0d verificacoes em %0d ciclos",checks,cycles);
        else $display("FAIL tb_projeto2: %0d erros em %0d verificacoes",errors,checks);
        $finish;
    end
    initial begin #2000; $display("FAIL tb_projeto2: timeout"); $finish; end
endmodule
