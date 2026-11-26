`timescale 1ns/1ps

module regfile (
    input  [4:0]  ReadAddr1,
    input  [4:0]  ReadAddr2,
    output [31:0] ReadData1,
    output [31:0] ReadData2,
    input         Clock,
    input  [4:0]  WriteAddr,
    input  [31:0] WriteData,
    input         RegWrite,
    input         Reset
);
    reg [31:0] registers [0:31];
    integer i;

    always @(posedge Clock or posedge Reset) begin
        if (Reset) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'b0;
        end else if (RegWrite && (WriteAddr != 5'd0)) begin
            registers[WriteAddr] <= WriteData;
        end
    end

    assign ReadData1 = (ReadAddr1 == 5'd0) ? 32'b0 : registers[ReadAddr1];
    assign ReadData2 = (ReadAddr2 == 5'd0) ? 32'b0 : registers[ReadAddr2];
endmodule
