`timescale 1ns/1ps

module d_mem #(
    parameter MEM_WORDS = 256
) (
    input         clock,
    input  [31:0]  Address,
    input  [31:0]  WriteData,
    input         MemWrite,
    input         MemRead,
    output [31:0]  ReadData
);
    localparam ADDR_BITS = (MEM_WORDS <= 2) ? 1 : $clog2(MEM_WORDS);
    reg [31:0] mem [0:MEM_WORDS-1];

    always @(posedge clock) begin
        if (MemWrite)
            mem[Address[ADDR_BITS+1:2]] <= WriteData;
    end

    // Leitura assincrona; alta impedancia quando MemRead estiver desabilitado.
    assign ReadData = MemRead ? mem[Address[ADDR_BITS+1:2]] : 32'bz;
endmodule
