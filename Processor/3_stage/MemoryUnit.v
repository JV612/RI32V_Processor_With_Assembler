`timescale 1ns / 1ps

module MemoryUnit (
    input wire clk,                   // Clock signal
    input wire isLd,                  // Load signal
    input wire isSt,                  // Store signal
    input wire [31:0] op2,            // Data to store
    input wire [31:0] aluResult,
    output reg [31:0] ldResult        // Data loaded from memory
);

    // Define a data memory of 256 words (32-bit each)
    reg [31:0] data_memory [0:255]; // Adjust size as needed
    
    //Memory operation
    always @(*) begin
        //aluResultW <= aluResult;
        if (isLd) begin
            // Load operation
            ldResult <= data_memory[aluResult[7:0]]; // Load word from memory at address aluResult
        end else if (isSt) begin
            // Store operation
            data_memory[aluResult[7:0]] <= op2; // Store op2 at address aluResult
        end
    end

endmodule
