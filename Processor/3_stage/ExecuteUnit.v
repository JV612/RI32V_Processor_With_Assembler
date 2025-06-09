`timescale 1ns / 1ps
`include "ALU.v"

module ExecuteUnit (
    input wire clk,                        // Clock signal
    input wire [31:0] op1,                 // First operand (from Operand Fetch)
    input wire [31:0] op2,                 // Second operand (can be register or immediate)
    input wire [31:0] immx,                // Immediate value
    input wire [31:0] branchTarget,
    input wire isSt, isLd, isBeq, isBgt, isRet,
    input wire isImmediate, isWb, isUbranch, isCall,
    input wire isAdd, isSub, isCmp, isMul, isDiv,
    input wire isMod, isLsl, isLsr, isAsr, isOr,
    input wire isAnd, isNot, isMov,         // Control signal for return
    output reg flag_eq,
    output reg flag_gt,                    // Global flags array passed from Processor
    output reg [31:0] branchPC,            // Next PC for branch
    output reg isBranchTaken,              // Signal indicating if the branch is taken
    output reg [31:0] aluResult            // Result of the ALU operation
);

// Internal signals
wire [31:0] aluInputB;
wire [31:0] aluOut;
wire aluFlag_eq, aluFlag_gt;
wire branchTakenByBeq;
wire branchTakenByBgt;
wire branchTakenUnconditionally;

// Multiplexer to select ALU second operand
assign aluInputB = isImmediate ? immx : op2;

// ALU Operation
ALU alu(
    .A(op1),               // First operand
    .B(aluInputB),         // Second operand
    .isAdd(isAdd),         // Control signal for addition
    .isSub(isSub),         // Control signal for subtraction
    .isMul(isMul),         // Control signal for multiplication
    .isDiv(isDiv),         // Control signal for division
    .isCmp(isCmp),         // Control signal for comparison
    .isMod(isMod),         // Control signal for modulus
    .isOr(isOr),           // Control signal for OR operation
    .isAnd(isAnd),         // Control signal for AND operation
    .isNot(isNot),         // Control signal for NOT operation
    .isMov(isMov),         // Control signal for MOV operation
    .isLsl(isLsl),         // Control signal for left shift logical
    .isLsr(isLsr),         // Control signal for right shift logical
    .isAsr(isAsr),         // Control signal for arithmetic shift right
    .flag_eq(aluFlag_eq),
    .flag_gt(aluFlag_gt),  // Flags output from ALU
    .aluResult(aluOut)     // Result of ALU operation
);

// Branch outcome logic
assign branchTakenByBeq = isBeq & aluFlag_eq; // E flag
assign branchTakenByBgt = isBgt & aluFlag_gt; // GT flag

// Sequential logic block triggered on posedge of clk
always @(*) begin
    // Update ALU results and flags
    aluResult <= aluOut;
    flag_eq <= aluFlag_eq;
    flag_gt <= aluFlag_gt;

    // Determine branch PC based on return or branch target
    branchPC <= isRet ? op1 : branchTarget;

    // Determine if any branch is taken
    isBranchTaken <= branchTakenByBeq | branchTakenByBgt | isUbranch;
end

endmodule
