# MIPS monociclo em Verilog

Este projeto implementa um núcleo MIPS monociclo com 28 instruções dos formatos R, I e J. O módulo `mips` integra o contador de programa, a ROM de instruções, o banco de registradores, a ULA, as unidades de controle e a RAM de dados.

O topo recebe `clock` e `reset` e expõe `PC_out`, `ULA_out` e `DMem_out`. O reset zera o banco de registradores e o PC inicia em zero na simulação. A RAM tem leitura e escrita assíncronas e apresenta alta impedância na saída quando `MemRead=0`.

## Executar pela interface do ModelSim 10.5b

1. Se você já criou o projeto nesta máquina, abra **File > Open** e selecione `src/MIPS_Monociclo.mpf`. Para criar um projeto em outra cópia, use **File > New > Project**, dê o nome `MIPS_Monociclo`, selecione a pasta `src` em **Project Location** e deixe a biblioteca padrão como `work`.
2. Ao criar o projeto, use **Add Existing File > Browse** para selecionar os 17 arquivos `.v` de `src`, incluindo os testbenches `tb_*.v`. Marque **Reference from current location** e confirme. Mantenha os arquivos `.list` em seus caminhos dentro de `src`, pois o simulador os lê durante os testes.
3. Clique em **Compile > Compile All**. Confira no **Transcript** se os 17 arquivos compilaram sem erros.
4. Clique em **Simulate > Start Simulation**. Na aba **Design**, expanda `work`, selecione **`tb_projeto2`** e clique em **OK**.
5. No painel **Sim**, selecione `tb_projeto2`. No painel **Objects**, selecione `clock`, `reset`, `PC_out`, `ULA_out` e `DMem_out`. Clique com o botão direito e escolha **Add Wave**.
6. Clique em **Simulate > Run > Run -all**. Se aparecer a janela **Finish Vsim**, clique em **Não** para manter a simulação aberta e poder analisar as ondas. Confira o `PASS` no **Transcript**.
7. Em **Wave**, use **Zoom Full**. Para ler o PC em decimal, clique com o botão direito em `PC_out` e escolha **Radix > Unsigned**. Com o cursor em **696 ns**, o PC deve mostrar **256**. Se você adicionou sinais depois de rodar e a janela indicar `No Data`, use **Simulate > Restart** e rode novamente.

Para trocar de teste, use **Simulate > End Simulation** e depois **Simulate > Start Simulation**. Escolha o próximo testbench em `work`.

## Testes e resultados esperados

| Testbench | O que verifica | Resultado esperado |
|---|---|---|
| `tb_projeto2` | Programa do professor em `instructions.list`, também usado por padrão no núcleo | `PASS tb_projeto2: 273 verificacoes em 70 ciclos` |
| `tb_isa` | As 28 instruções com o programa `programs/isa_completa.list` | `PASS tb_isa: 42 verificacoes; 28 instrucoes exercitadas` |
| `tb_mips` | Programa curto em `programs/exemplo_original.list` | `PASS tb_mips: 15 verificacoes` |
| `tb_pc`, `tb_i_mem`, `tb_regfile`, `tb_d_mem` | Testes isolados de PC, ROM, registradores e RAM | `PASS` seguido do nome do teste |
| `tb_ula`, `tb_ctrl` | Testes isolados da ULA e do controle | `PASS` com 22 e 29 verificações, respectivamente |

## Executar pelo Transcript

Os mesmos testes também podem ser executados pelo **Transcript**. Ajuste o caminho do primeiro comando para a pasta `src` da sua cópia.

```tcl
cd C:/projetos/mips_monociclo/src
if {![file isdirectory work]} {vlib work}
vmap work work
vlog pc.v i_mem.v d_mem.v regfile.v ula.v ula_ctrl.v ctrl.v mips.v tb_pc.v tb_i_mem.v tb_regfile.v tb_d_mem.v tb_ula.v tb_ctrl.v tb_mips.v tb_isa.v tb_projeto2.v
vsim -onfinish stop work.tb_projeto2
add wave -r sim:/tb_projeto2/*
run -all
```

Para trocar de teste, execute `quit -sim` e repita as três últimas linhas com o nome do próximo testbench.
