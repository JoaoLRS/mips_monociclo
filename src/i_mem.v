`timescale 1ns/1ps

module i_mem #(
    parameter MEM_WORDS = 256,
    parameter INIT_FILE = "instruction.list"
) (
    input  [31:0] address,
    output [31:0] i_out
);
    localparam ADDR_BITS = (MEM_WORDS <= 2) ? 1 : $clog2(MEM_WORDS);
    reg [31:0] mem [0:MEM_WORDS-1];

    initial begin
        $readmemb(INIT_FILE, mem);
    end

    // PC e enderecos sao em bytes; cada palavra ocupa quatro bytes.
    assign i_out = mem[address[ADDR_BITS+1:2]];
endmodule
