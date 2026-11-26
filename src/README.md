# MIPS monociclo em Verilog

Este projeto implementa, em Verilog, um nucleo MIPS monociclo com um subconjunto de 28 instrucoes dos formatos R, I e J. Em cada ciclo, o processador le uma instrucao, executa a operacao e calcula o proximo endereco do programa. O modulo de topo e `mips`.

## O que ha no projeto

- `pc.v`: contador de programa, atualizado na borda positiva do clock.
- `i_mem.v`: ROM assincrona, enderecada por byte e carregada de `instruction.list`.
- `d_mem.v`: RAM com leitura assincrona e escrita na borda positiva.
- `regfile.v`: banco de 32 registradores, duas leituras assincronas, escrita sincrona e registrador zero constante.
- `ula.v` e `ula_ctrl.v`: unidade aritmetica/logica e decodificador de operacao.
- `ctrl.v`: sinais de controle por opcode.
- `mips.v`: integracao do processador e interface externa.
- `instruction.list`: programa de exemplo em palavras binarias de 32 bits.
- `tb_ula.v`, `tb_ctrl.v` e `tb_mips.v`: testbenches da ULA, do controle e do nucleo completo.

## Interface do topo

`mips(clock, reset, PC_out, ULA_out, DMem_out)`. O reset e assincrono e zera o banco de registradores. O PC inicia em zero, pois o enunciado nao especifica um pino de reset para ele.

## Memorias e enderecos

PC e enderecos de dados sao enderecos de byte. Como lw/sw operam palavras, os dois bits menos significativos sao ignorados e as memorias usam o indice `Address >> 2`. `IMEM_WORDS` e `DMEM_WORDS` podem ser configurados no topo; use tamanhos potencias de dois. A ROM deve ser inicializada com palavras binarias, uma por linha. O caminho padrao e relativo ao diretorio de trabalho da simulacao; ajuste `IMEM_FILE` se necessario.

As instrucoes implementadas incluem aritmetica, logica, comparacoes, deslocamentos, acesso a memoria, desvios e saltos. A memoria de dados desta versao le de forma assincrona e escreve na borda positiva do clock.

## Como executar no ModelSim 10.5b

Abra o ModelSim e digite os comandos abaixo no **Transcript** (`ModelSim>`). O primeiro comando aponta para a pasta `src`, onde esta `instruction.list`.

```tcl
cd C:/projetos/mips_monociclo/src
vlib work
vmap work work
vlog pc.v i_mem.v d_mem.v regfile.v ula.v ula_ctrl.v ctrl.v mips.v tb_ula.v tb_ctrl.v tb_mips.v
vsim work.tb_mips
add wave -r sim:/tb_mips/*
run -all
```

O resultado aparece no Transcript; as formas de onda aparecem na janela **Wave**. O teste `tb_mips` executa o programa de exemplo e termina automaticamente. Para executar os testes isolados, substitua `tb_mips` por `tb_ula` ou `tb_ctrl` nas linhas `vsim` e `add wave`. Se `work` ja existir, prossiga apos a mensagem de `vlib`. Depois de editar um arquivo `.v`, repita `vlog` e carregue o testbench novamente com `vsim`.
