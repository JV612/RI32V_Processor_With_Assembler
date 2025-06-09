`timescale 1ns / 1ps
`include "ControlUnit.v"
`include "RegisterFile.v"

module OperandFetchUnit (
    input clk,
    input reset,
    input wire [31:0] instruction, // 32-bit instruction
    input wire [31:0] PC, // Global register file
    output reg [31:0] branchTarget,
    output reg [31:0] immx,
    // Change reg to wire for control signals
    output wire isSt, isLd, isBeq, isBgt, isRet,
    output wire isImmediate, isWb, isUbranch, isCall,
    output wire isAdd, isSub, isCmp, isMul, isDiv,
    output wire isMod, isLsl, isLsr, isAsr, isOr,
    output wire isAnd, isNot, isMov,
    output wire [3:0] rd,
    output wire [3:0] rs1,
    output wire [3:0] rs2
);

    // Extract relevant fields from the instruction
    wire [26:0] instr_1_27 = instruction[26:0];
    wire [17:0] instr_1_18 = instruction[17:0];
    wire [1:0] immx_ctrl = instruction[17:16];  // Control bits for immx
    assign rd = instruction[25:22];         // Destination register
    assign rs1 = instruction[21:18];        // Source register 1
    assign rs2 = instruction[17:14];        // Source register 2
    
    // Control signals extraction for control unit
    wire [5:0] opcode;
    assign opcode = instruction[31:26];
    
    // Calculate branchTarget
    always @(*) begin
        // Right shift instr_1_27 by 2 and sign-extend to 32 bits
        branchTarget = PC + {{3{instr_1_27[26]}}, instr_1_27[26:0], 2'b00};
    end

    // Calculate immx based on immx_ctrl
    always @(*) begin
        if (reset) begin
            immx <= 32'b0;
        end else begin
            case (immx_ctrl)
                2'b00: immx <= {16'b0, instr_1_18[15:0]};               // Zero extend
                2'b01: immx <= {{16{instr_1_18[15]}}, instr_1_18[15:0]}; // Sign extend
                2'b10: immx <= {instr_1_18[15:0], 16'b0};                // Lower 16 bits, rest zero
                default: immx <= 32'b0;                                  // Default case
            endcase
        end
    end

    // ControlUnit instance - Control signals driven by ControlUnit
    ControlUnit control_unit(
        .opcode(opcode),
        .isSt(isSt),
        .isLd(isLd), 
        .isBeq(isBeq),
        .isBgt(isBgt),
        .isRet(isRet),
        .isImmediate(isImmediate),
        .isWb(isWb),
        .isUbranch(isUbranch),
        .isCall(isCall),
        .isAdd(isAdd),
        .isSub(isSub),
        .isCmp(isCmp),
        .isMul(isMul),
        .isDiv(isDiv),
        .isMod(isMod),
        .isLsl(isLsl),
        .isLsr(isLsr),
        .isAsr(isAsr),
        .isOr(isOr),
        .isAnd(isAnd),
        .isNot(isNot),
        .isMov(isMov)
    );

    
endmodule
