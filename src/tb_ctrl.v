//==========================================================
//Equipe: Alisson Xavier e Joao Lucas Ribeiro
//Atividade: Projeto 02 - 2a VA
//Disciplina: Arquitetura e Organizacao de Computadores
//Semestre: 2026.2
//Questao: teste da unidade de controle.
//========================================================== 
`timescale 1ns/1ps
module tb_ctrl;
    reg [5:0] opcode, funct;
    wire RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite;
    wire Branch, BranchNE, Jump, Jal, Jr, ImmZeroExt, Lui;
    wire [3:0] ALUOp;
    integer checks;
    ctrl dut(.opcode(opcode), .funct(funct), .RegDst(RegDst), .ALUSrc(ALUSrc),
        .MemToReg(MemToReg), .RegWrite(RegWrite), .MemRead(MemRead),
        .MemWrite(MemWrite), .Branch(Branch), .BranchNE(BranchNE),
        .Jump(Jump), .Jal(Jal), .Jr(Jr), .ImmZeroExt(ImmZeroExt),
        .Lui(Lui), .ALUOp(ALUOp));
    task check;
        input [5:0] opc, fn;
        input wr, rdmem, wrmem, br, jump, link, jr, zeroext, lui;
        begin
            opcode=opc; funct=fn; #1;
            if ({RegWrite,MemRead,MemWrite,Branch,Jump,Jal,Jr,ImmZeroExt,Lui} !==
                {wr,rdmem,wrmem,br,jump,link,jr,zeroext,lui}) begin
                $display("FAIL CTRL opcode=%h funct=%h flags=%b", opc, fn,
                    {RegWrite,MemRead,MemWrite,Branch,Jump,Jal,Jr,ImmZeroExt,Lui});
                $finish;
            end
            checks=checks+1;
        end
    endtask
    initial begin
        checks=0;
        check(0,6'h20,1,0,0,0,0,0,0,0,0);
        check(0,6'h22,1,0,0,0,0,0,0,0,0);
        check(0,6'h24,1,0,0,0,0,0,0,0,0);
        check(0,6'h25,1,0,0,0,0,0,0,0,0);
        check(0,6'h26,1,0,0,0,0,0,0,0,0);
        check(0,6'h27,1,0,0,0,0,0,0,0,0);
        check(0,6'h2a,1,0,0,0,0,0,0,0,0);
        check(0,6'h2b,1,0,0,0,0,0,0,0,0);
        check(0,6'h00,1,0,0,0,0,0,0,0,0);
        check(0,6'h02,1,0,0,0,0,0,0,0,0);
        check(0,6'h03,1,0,0,0,0,0,0,0,0);
        check(0,6'h04,1,0,0,0,0,0,0,0,0);
        check(0,6'h06,1,0,0,0,0,0,0,0,0);
        check(0,6'h07,1,0,0,0,0,0,0,0,0);
        check(0,6'h08,0,0,0,0,0,0,1,0,0); // jr
        check(0,6'h21,0,0,0,0,0,0,0,0,0); // R fora do escopo
        check(6'h08,0,1,0,0,0,0,0,0,0,0); // addi
        check(6'h0c,0,1,0,0,0,0,0,0,1,0); // andi
        check(6'h0d,0,1,0,0,0,0,0,0,1,0); // ori
        check(6'h0e,0,1,0,0,0,0,0,0,1,0); // xori
        check(6'h0a,0,1,0,0,0,0,0,0,0,0); // slti
        check(6'h0b,0,1,0,0,0,0,0,0,0,0); // sltiu
        check(6'h0f,0,1,0,0,0,0,0,0,0,1); // lui
        check(6'h04,0,0,0,0,1,0,0,0,0,0); // beq
        check(6'h05,0,0,0,0,1,0,0,0,0,0); // bne
        check(6'h23,0,1,1,0,0,0,0,0,0,0); // lw
        check(6'h2b,0,0,0,1,0,0,0,0,0,0); // sw
        check(6'h02,0,0,0,0,0,1,0,0,0,0); // j
        check(6'h03,0,1,0,0,0,1,1,0,0,0); // jal
        $display("PASS tb_ctrl: %0d verificacoes", checks);
        $finish;
    end
endmodule
