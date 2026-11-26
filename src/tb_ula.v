// Grupo: João e Alisson | Projeto 02 | Disciplina: Arquitetura e Organização de Computadores
// Semestre:  | Questão: teste da ULA e controle da ULA.
`timescale 1ns/1ps
module tb_ula;
    reg [31:0] a, b;
    reg [3:0] aluop;
    reg [5:0] funct;
    wire [3:0] op;
    wire [31:0] result;
    wire zero;
    integer checks;
    ula_ctrl decode(.ALUOp(aluop), .funct(funct), .OP(op));
    ula dut(.In1(a), .In2(b), .OP(op), .result(result), .Zero_flag(zero));

    task check;
        input [3:0] selector;
        input [5:0] function_code;
        input [31:0] left, right, expected;
        begin
            aluop=selector; funct=function_code; a=left; b=right; #1;
            if (result !== expected || zero !== (expected == 0)) begin
                $display("FAIL ULA op=%h funct=%h a=%h b=%h got=%h expected=%h", selector, function_code, left, right, result, expected);
                $finish;
            end
            checks=checks+1;
        end
    endtask

    initial begin
        checks=0;
        check(4'hf,6'h20,32'd5,32'd10,32'd15); // add
        check(4'hf,6'h22,32'd5,32'd10,32'hfffffffb); // sub
        check(4'hf,6'h24,32'hf0,32'h0f,0); // and
        check(4'hf,6'h25,32'hf0,32'h0f,32'hff); // or
        check(4'hf,6'h26,32'hf0,32'h0f,32'hff); // xor
        check(4'hf,6'h27,32'hf0,32'h0f,32'hffffff00); // nor
        check(4'hf,6'h2a,32'hffffffff,32'd1,1); // slt signed
        check(4'hf,6'h2b,32'hffffffff,32'd1,0); // sltu unsigned
        check(4'hf,6'h00,32'd1,32'd31,32'h80000000); // sll/sllv
        check(4'hf,6'h02,32'h80000000,32'd31,1); // srl/srlv
        check(4'hf,6'h03,32'h80000000,32'd31,32'hffffffff); // sra/srav
        check(4'hf,6'h04,32'd1,32'd0,1);
        check(4'hf,6'h06,32'h80000000,32'd1,32'h40000000);
        check(4'hf,6'h07,32'h80000000,32'd1,32'hc0000000);
        check(4'h8,0,32'hffffffff,32'd1,0); // sltiu com imediato sinalizado
        check(4'h7,0,32'hffffffff,32'd1,1); // slti
        $display("PASS tb_ula: %0d verificacoes", checks);
        $finish;
    end
endmodule
