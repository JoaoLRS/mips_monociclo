# Programa de validacao do conjunto MIPS. Cada linha corresponde a uma palavra
# em isa_completa.list; o PC usa enderecos de byte (indice da linha * 4).
# Registros com valores esperados sao conferidos por tb_isa.
00 addi $1,$zero,-1
01 addi $2,$zero,1
02 add $3,$1,$2
03 sub $4,$2,$1
04 and $5,$1,$2
05 or $6,$1,$2
06 xor $7,$1,$2
07 nor $8,$1,$2
08 slt $9,$1,$2
09 sltu $10,$1,$2
10 sll $11,$2,31
11 srl $12,$11,31
12 sra $13,$11,31
13 sllv $14,$2,$2
14 srlv $15,$11,$2
15 srav $16,$11,$2
16 addi $17,$zero,-2
17 andi $18,$1,0x8001
18 ori $19,$zero,0x8001
19 xori $20,$2,0x8001
20 slti $21,$1,1
21 sltiu $22,$1,-1
22 lui $23,0x1234
23 sw $6,0($zero)
24 lw $24,0($zero)
25 addi $25,$zero,0
26 beq $3,$8,2             # tomado: pula 27 e 28
27 addi $25,$zero,99       # ignorada
28 addi $25,$zero,77       # ignorada
29 bne $1,$2,0             # tomado com deslocamento zero
30 addi $26,$zero,5
31 beq $1,$2,1             # nao tomado
32 bne $1,$1,1             # nao tomado
33 j 35                     # vai a jal
34 addi $26,$zero,99       # ignorada
35 jal 39                   # salva PC+4 em $31
36 addi $28,$zero,8        # retorno da subrotina
37 j 41
38 addi $28,$zero,99       # ignorada
39 addi $27,$zero,7        # corpo da subrotina
40 jr $31
41 addi $29,$zero,9
42 beq $zero,$zero,-1      # desvio negativo; permanece nesta palavra
