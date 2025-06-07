`include "InstructionMemory.v"

module IF(
    input wire clk,
    input wire reset,
    input wire [31:0] branchPC,
    input wire isBranchTaken,
    output reg [31:0] PC,
    output wire [31:0] instruction

);  

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC <= 32'b0; // Reset PC to 0
        end else if (isBranchTaken) begin
            PC <= branchPC; // Update PC to branch target if branch is taken
        end else begin
            PC <= PC + 4; // Increment PC by 4 for next instruction
        end
    end

    // Instantiate Instruction Memory
    InstructionMemory instructionMemory (
        .address(PC),
        .instruction(instruction)
    );

endmodule