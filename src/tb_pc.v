//==========================================================
//Equipe: Alisson Xavier e Joao Lucas Ribeiro
//Atividade: Projeto 02 - 2a VA
//Disciplina: Arquitetura e Organizacao de Computadores
//Semestre: 2026.2
//Questao: teste isolado do PC.
//========================================================== 
module tb_pc;
    reg clock;
    reg [31:0] nextPC;
    wire [31:0] PC_out;
    integer errors;
    PC dut(.clock(clock), .nextPC(nextPC), .PC(PC_out));
    initial begin
        clock=0; nextPC=32'h100; errors=0;
        #1 if (PC_out !== 0) begin $display("FAIL PC inicial: %h", PC_out); errors=errors+1; end
        #1 clock=1; #1 if (PC_out !== 32'h100) begin $display("FAIL PC borda positiva: %h", PC_out); errors=errors+1; end
        clock=0; nextPC=32'h104; #1;
        if (PC_out !== 32'h100) begin $display("FAIL PC mudou fora da borda: %h", PC_out); errors=errors+1; end
        clock=1; #1 if (PC_out !== 32'h104) begin $display("FAIL PC segunda borda: %h", PC_out); errors=errors+1; end
        if (errors==0) $display("PASS tb_pc"); else $display("FAIL tb_pc: %0d erros", errors);
        $finish;
    end
endmodule
