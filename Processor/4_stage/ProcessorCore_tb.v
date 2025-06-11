`timescale 1ns / 1ps
`include "ProcessorCore.v"
module ProcessorCore_tb;

    // Declare signals to drive inputs of the ProcessorCore
    reg clk;
    reg reset;
    wire flag_eq, flag_gt;
    wire [31:0] PCF;
    wire [31:0] instructionF;
    // Declare signals to monitor outputs of the ProcessorCore
    wire [31:0] PCD;
    wire [31:0] instructionD;
    wire [31:0] branchTargetD;
    wire [31:0] immxD;
    wire isStD, isLdD, isBeqD, isBgtD, isRetD;
    wire isImmediateD, isWbD, isUbranchD, isCallD;
    wire isAddD, isSubD, isCmpD, isMulD, isDivD;
    wire isModD, isLslD, isLsrD, isAsrD, isOrD;
    wire isAndD, isNotD, isMovD;
    wire [31:0] op1D, op2D;
    wire [31:0] branchPCD;        // Next PC for branch
    wire isBranchTakenD;
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
    wire [3:0] rdD; 
    wire [3:0] rs1D; 
    wire [3:0] rs2D; 
    wire [3:0] rdE; 
    wire [3:0] rs1E; 
    wire [3:0] rs2E;            // Signal indicating if the branch is taken
    wire [31:0] aluResultE;
    wire [3:0] rdM;
    wire [31:0] aluResultM;
    wire [31:0] PCM;
    wire isStM, isLdM, isBeqM, isBgtM, isRetM;
    wire isImmediateM, isWbM, isUbranchM, isCallM;
    wire isAddM, isSubM, isCmpM, isMulM, isDivM;
    wire isModM, isLslM, isLsrM, isAsrM, isOrM;
    wire isAndM, isNotM, isMovM;
    wire [31:0] op1M;
    wire [31:0] op2M;
    wire [31:0] ldResultM;
    wire [1:0] stall;
    wire [1:0] stallC;
    wire track;
    
    // Instantiate the ProcessorCore
    ProcessorCore uut (
        .clk(clk),
        .reset(reset),
        .flag_eq(flag_eq),
        .flag_gt(flag_gt),
        .PCF(PCF),
        .instructionF(instructionF),
        .PCD(PCD),
        .instructionD(instructionD),
        .branchTargetD(branchTargetD),
        .immxD(immxD),
        .isStD(isStD), .isLdD(isLdD), .isBeqD(isBeqD), .isBgtD(isBgtD), .isRetD(isRetD),
        .isImmediateD(isImmediateD), .isWbD(isWbD), .isUbranchD(isUbranchD), .isCallD(isCallD),
        .isAddD(isAddD), .isSubD(isSubD), .isCmpD(isCmpD), .isMulD(isMulD), .isDivD(isDivD),
        .isModD(isModD), .isLslD(isLslD), .isLsrD(isLsrD), .isAsrD(isAsrD), .isOrD(isOrD),
        .isAndD(isAndD), .isNotD(isNotD), .isMovD(isMovD),
        .op1D(op1D), .op2D(op2D),
        .branchPCD(branchPCD),
        .isBranchTakenD(isBranchTakenD),
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
        .rdD(rdD),
        .rs1D(rs1D),
        .rs2D(rs2D),
        .rdE(rdE),
        .rs1E(rs1E),
        .rs2E(rs2E),
        .aluResultE(aluResultE),
        .PCM(PCM),
        .rdM(rdM),
        .aluResultM(aluResultM),
        .isStM(isStM), .isLdM(isLdM), .isBeqM(isBeqM), .isBgtM(isBgtM), .isRetM(isRetM),
        .isImmediateM(isImmediateM), .isWbM(isWbM), .isUbranchM(isUbranchM), .isCallM(isCallM),
        .isAddM(isAddM), .isSubM(isSubM), .isCmpM(isCmpM), .isMulM(isMulM), .isDivM(isDivM),
        .isModM(isModM), .isLslM(isLslM), .isLsrM(isLsrM), .isAsrM(isAsrM), .isOrM(isOrM),
        .isAndM(isAndM), .isNotM(isNotM), .isMovM(isMovM),
        .op1M(op1M), .op2M(op2M),
        .ldResultM(ldResultM),
        .stall(stall),
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

    // Test stimulus
    initial begin
        // Initialize signals
        $monitor("Time = %0dns | PCF = %h | InstructionF = %b | R1 = %d | R2 = %d", 
        $time, 
        PCF, 
        instructionF,
        uut.rf.regFileData[1],
        uut.rf.regFileData[2],
        );
        clk = 1;
        reset = 0;
        
        // Monitor signals in waveform
        #1000;
        $finish;
    end
endmodule