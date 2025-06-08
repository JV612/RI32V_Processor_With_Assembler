`timescale 1ns / 1ps
`include "ProcessorCore.v"
module ProcessorCore_tb;

    // Declare signals to drive inputs of the ProcessorCore
    reg clk;
    reg reset;
    wire flag_eq, flag_gt;
    
    // Declare signals to monitor outputs of the ProcessorCore
    wire [31:0] PCF;
    wire [31:0] instructionF;
    wire [31:0] branchTargetF;
    wire [31:0] immxF;
    wire isStF, isLdF, isBeqF, isBgtF, isRetF;
    wire isImmediateF, isWbF, isUbranchF, isCallF;
    wire isAddF, isSubF, isCmpF, isMulF, isDivF;
    wire isModF, isLslF, isLsrF, isAsrF, isOrF;
    wire isAndF, isNotF, isMovF;
    wire [31:0] op1F, op2F;
    wire [31:0] branchPCF;        // Next PC for branch
    wire isBranchTakenF;
    wire [31:0] PCE;
    wire [31:0] instructionE;
    wire [31:0] branchTargetE;
    wire [31:0] immxE;
    wire isStE, isLdE, isBeqE, isBgtE, isRetE;
    wire isImmediateE, isWbE, isUbranchE, isCallE;
    wire isAddE, isSubE, isCmpE, isMulE, isDivE;
    wire isModE, isLslE, isLsrE, isAsrE, isOrE;
    wire isAndE, isNotE, isMovE;
    wire [31:0] op1E, op2E;
    wire [31:0] branchPCE;
    wire isBranchTakenE;
    wire [3:0] rdF; 
    wire [3:0] rs1F; 
    wire [3:0] rs2F; 
    wire [3:0] rdE; 
    wire [3:0] rs1E; 
    wire [3:0] rs2E;            // Signal indicating if the branch is taken
    wire [31:0] aluResult;
    wire stallF;
    wire stallC;
    wire track;
    
    // Instantiate the ProcessorCore
    ProcessorCore uut (
        .clk(clk),
        .reset(reset),
        .flag_eq(flag_eq),
        .flag_gt(flag_gt),
        .PCF(PCF),
        .instructionF(instructionF),
        .branchTargetF(branchTargetF),
        .immxF(immxF),
        .isStF(isStF), .isLdF(isLdF), .isBeqF(isBeqF), .isBgtF(isBgtF), .isRetF(isRetF),
        .isImmediateF(isImmediateF), .isWbF(isWbF), .isUbranchF(isUbranchF), .isCallF(isCallF),
        .isAddF(isAddF), .isSubF(isSubF), .isCmpF(isCmpF), .isMulF(isMulF), .isDivF(isDivF),
        .isModF(isModF), .isLslF(isLslF), .isLsrF(isLsrF), .isAsrF(isAsrF), .isOrF(isOrF),
        .isAndF(isAndF), .isNotF(isNotF), .isMovF(isMovF),
        .op1F(op1F), .op2F(op2F),
        .branchPCF(branchPCF),
        .isBranchTakenF(isBranchTakenF),
        .PCE(PCE),
        .instructionE(instructionE),
        .branchTargetE(branchTargetE),
        .immxE(immxE),
        .isStE(isStE), .isLdE(isLdE), .isBeqE(isBeqE), .isBgtE(isBgtE), .isRetE(isRetE),
        .isImmediateE(isImmediateE), .isWbE(isWbE), .isUbranchE(isUbranchE), .isCallE(isCallE),
        .isAddE(isAddE), .isSubE(isSubE), .isCmpE(isCmpE), .isMulE(isMulE), .isDivE(isDivE),
        .isModE(isModE), .isLslE(isLslE), .isLsrE(isLsrE), .isAsrE(isAsrE), .isOrE(isOrE),
        .isAndE(isAndE), .isNotE(isNotE), .isMovE(isMovE),
        .op1E(op1E), .op2E(op2E),
        .branchPCE(branchPCE),
        .isBranchTakenE(isBranchTakenE),
        .rdF(rdF),
        .rs1F(rs1F),
        .rs2F(rs2F),
        .rdE(rdE),
        .rs1E(rs1E),
        .rs2E(rs2E),
        .aluResult(aluResult),
        .stallF(stallF),
        .stallC(stallC),
        .track(track)
    );

    // Clock generation
    always begin
        clk = ~clk;  // Toggle clock every half period
        #5;          // Clock period: 10ns
    end

    initial begin
        $dumpfile("ProcessorCore_tb.vcd"); // VCD file for GTKWave
        $dumpvars(0, ProcessorCore_tb);     // Dump all variables in the testbench
    end

    initial begin
         clk = 1;
         reset = 0;
        $monitor("Time = %0dns | PCF = %h | InstructionF = %b | R1 = %d | R2 = %d",
         $time, 
         PCF, 
         instructionF,
         uut.rf.regFileData[1], 
         uut.rf.regFileData[2]
);

        #400;
        $finish;
    end
endmodule
