`timescale 1ns / 1ps

module Processor_tb;

    // Declare signals to drive inputs of the ProcessorCore
    reg clk;
    reg reset;
    
    // Declare signals to monitor outputs of the ProcessorCore
    wire [31:0] PC;
    wire [31:0] instruction;
    wire [31:0] branchPC;
    wire isBranchTaken;
    wire [31:0] branchTarget;
    wire [31:0] immediateValue;
    wire [3:0] rd, rs1, rs2;
    wire isSt, isLd, isBeq, isBgt, isRet;
    wire isImmediate, isWb, isUbranch, isCall;
    wire isAdd, isSub, isCmp, isMul, isDiv;
    wire isMod, isLsl, isLsr, isAsr, isOr;
    wire isAnd, isNot, isMov;
    wire [31:0] op1, op2;
    wire [31:0] aluResult;
    wire flag_eq;
    wire flag_gt;
    wire [31:0] ldResult;

    // Instantiate the ProcessorCore
    Processor p (
        .clk(clk),
        .reset(reset),
        .PC(PC),
        .instruction(instruction),
        .branchPC(branchPC),
        .isBranchTaken(isBranchTaken),
        .branchTarget(branchTarget),
        .immediateValue(immediateValue),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
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
        .isMov(isMov),
        .op1(op1),
        .op2(op2),
        .aluResult(aluResult),
        .flag_eq(flag_eq),
        .flag_gt(flag_gt),
        .ldResult(ldResult)
    );

    // Initialize signals

    // Clock generation
    always begin
        clk = ~clk;  // Toggle clock every half period
        #5;          // Clock period: 10ns
    end

    initial begin
        $dumpfile("Processor_tb.vcd"); // VCD file for GTKWave
        $dumpvars(0, Processor_tb);     // Dump all variables in the testbench
    end

    initial begin
         clk = 1;
         reset = 0;
        $monitor("Time = %0dns | PC = %d | Instruction = %b | rd = %d | rs1 = %d | rs2 = %d | immediateValue = %d | R1 = %d | R2 = %d | branchTarget = %d | BranchPC = %d | isBranchTaken = %b | isCmp = %b | flag_gt = %b",
            $time, 
            PC, 
            instruction,
            rd,
            rs1,
            rs2,
            immediateValue,
            p.rf_stage.regFileData[1],
            p.rf_stage.regFileData[2],
            branchTarget,
            branchPC,
            isBranchTaken,
            isCmp,
            flag_gt
        );

        #400;
        $finish;
    end

endmodule