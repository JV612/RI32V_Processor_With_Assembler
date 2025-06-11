`ifndef PROCESSOR_CORE_V
`define PROCESSOR_CORE_V
`include "FetchUnit.v"
`include "OperandFetchUnit.v"
`include "ExecuteUnit.v"
`include "MemoryUnit.v"
`include "InstructionMemory.v"
`include "Latch_FetchDecode.v"
`include "Latch_DecodeExecute.v"
`include "Latch_ExecuteMemory.v"
`include "Hazard.v"

module ProcessorCore (
    input wire clk,
    input wire reset,
    output wire flag_eq,
    output wire flag_gt,
    output wire [31:0] PCF,
    output wire [31:0] instructionF,
    output wire [31:0] PCD,
    output wire [31:0] instructionD,
    output wire [31:0] branchTargetD,
    output wire [31:0] immxD,
    output wire isStD, isLdD, isBeqD, isBgtD, isRetD,
    output wire isImmediateD, isWbD, isUbranchD, isCallD,
    output wire isAddD, isSubD, isCmpD, isMulD, isDivD,
    output wire isModD, isLslD, isLsrD, isAsrD, isOrD,
    output wire isAndD, isNotD, isMovD,
    output wire [31:0] op1D,
    output wire [31:0] op2D,
    output wire [31:0] branchPCD,         
    output wire isBranchTakenD,
    output wire [31:0] PCE,
    output wire [31:0] instructionE,
    output wire [31:0] branchTargetE,
    output wire [31:0] immxE,
    output wire isStE, isLdE, isBeqE, isBgtE, isRetE,
    output wire isImmediateE, isWbE, isUbranchE, isCallE,
    output wire isAddE, isSubE, isCmpE, isMulE, isDivE,
    output wire isModE, isLslE, isLsrE, isAsrE, isOrE,
    output wire isAndE, isNotE, isMovE,
    output wire [31:0] op1E,
    output wire [31:0] op2E,
    output wire [31:0] branchPCE,         
    output wire isBranchTakenE,
    output wire [3:0] rdD, 
    output wire [3:0] rs1D, 
    output wire [3:0] rs2D, 
    output wire [3:0] rdE, 
    output wire [3:0] rs1E, 
    output wire [3:0] rs2E,          
    output wire [31:0] aluResultE,
    output wire [31:0] PCM,
    output wire [3:0] rdM,
    output wire [31:0] aluResultM,
    output wire isStM, isLdM, isBeqM, isBgtM, isRetM,
    output wire isImmediateM, isWbM, isUbranchM, isCallM,
    output wire isAddM, isSubM, isCmpM, isMulM, isDivM,
    output wire isModM, isLslM, isLsrM, isAsrM, isOrM,
    output wire isAndM, isNotM, isMovM,
    output wire [31:0] op1M,
    output wire [31:0] op2M,
    output wire [31:0] ldResultM,
    output wire [1:0] stall,
    output wire [1:0] stallC,
    output wire track
);
    // Instruction Fetch Unit
    FetchUnit fuu(
        .clk(clk),
        .reset(reset),
        .isBranchTaken(isBranchTakenE),
        .branchPC(branchPCE),
        .PC(PCF),
        .stall(stall),
        .stallC(stallC),
        .track(track)
    );

    //Instruction Fetch
    InstructionMemory mem (
        .address(PCF),
        .instruction(instructionF)
    );

    // Hazard Handling Unit
    Hazard hz(
        .clk(clk),
        .reset(reset),
        .rs1D(rs1D),
        .rs2D(rs2D),
        .rdM(rdM),
        .rdE(rdE),
        .stall(stall),
        .isBranchTakenE(isBranchTakenE),
        .stallC(stallC),
        .track(track)
    );

    // Latch 1
    Latch_FetchDecode lfd(
        .clk(clk),
        .reset(reset),
        .instructionF(instructionF),
        .PCF(PCF),
        .instructionD(instructionD),
        .PCD(PCD),
        .stall(stall)
    );

    // Operand Fetch Unit
    OperandFetchUnit ofu(
        .clk(clk),
        .reset(reset),
        .instruction(instructionD),
        .PC(PCD),
        .branchTarget(branchTargetD),
        .immx(immxD),
        .isSt(isStD),
        .isLd(isLdD),
        .isBeq(isBeqD), 
        .isBgt(isBgtD), 
        .isRet(isRetD),
        .isImmediate(isImmediateD), 
        .isWb(isWbD), 
        .isUbranch(isUbranchD), 
        .isCall(isCallD),
        .isAdd(isAddD), 
        .isSub(isSubD), 
        .isCmp(isCmpD), 
        .isMul(isMulD), 
        .isDiv(isDivD),
        .isMod(isModD),
        .isLsl(isLslD), 
        .isLsr(isLsrD), 
        .isAsr(isAsrD), 
        .isOr(isOrD),
        .isAnd(isAndD),
        .isNot(isNotD), 
        .isMov(isMovD),
        .rd(rdD),
        .rs1(rs1D),
        .rs2(rs2D)
    );

    // Latch 2
    Latch_DecodeExecute lfe(
        .clk(clk),
        .reset(reset),
        .instructionD(instructionD),
        .PCD(PCD),
        .branchTargetD(branchTargetD),
        .immxD(immxD),
        .isStD(isStD), 
        .isLdD(isLdD), 
        .isBeqD(isBeqD), 
        .isBgtD(isBgtD), 
        .isRetD(isRetD),
        .isImmediateD(isImmediateD), 
        .isWbD(isWbD), 
        .isUbranchD(isUbranchD), 
        .isCallD(isCallD),
        .isAddD(isAddD), 
        .isSubD(isSubD), 
        .isCmpD(isCmpD), 
        .isMulD(isMulD), 
        .isDivD(isDivD),
        .isModD(isModD), 
        .isLslD(isLslD), 
        .isLsrD(isLsrD), 
        .isAsrD(isAsrD), 
        .isOrD(isOrD),
        .isAndD(isAndD), 
        .isNotD(isNotD), 
        .isMovD(isMovD),
        .rdD(rdD),
        .op1D(op1D),
        .op2D(op2D),
        .instructionE(instructionE),
        .PCE(PCE),
        .branchTargetE(branchTargetE),
        .immxE(immxE),
        .isStE(isStE), 
        .isLdE(isLdE), 
        .isBeqE(isBeqE), 
        .isBgtE(isBgtE), 
        .isRetE(isRetE),
        .isImmediateE(isImmediateE), 
        .isWbE(isWbE), 
        .isUbranchE(isUbranchE), 
        .isCallE(isCallE),
        .isAddE(isAddE), 
        .isSubE(isSubE), 
        .isCmpE(isCmpE), 
        .isMulE(isMulE), 
        .isDivE(isDivE),
        .isModE(isModE), 
        .isLslE(isLslE), 
        .isLsrE(isLsrE), 
        .isAsrE(isAsrE), 
        .isOrE(isOrE),
        .isAndE(isAndE), 
        .isNotE(isNotE), 
        .isMovE(isMovE),
        .rdE(rdE),
        .op1E(op1E),
        .op2E(op2E),
        .stall(stall),
        .stallC(stallC)
    );

    // Execution Unit
    ExecuteUnit euu(
        .clk(clk),
        .op1(op1E),               // First operand (from Operand Fetch)
        .op2(op2E),               // Second operand (can be register or immediate)
        .immx(immxE),              // Immediate value
        .branchTarget(branchTargetE),
        .isSt(isStE),
        .isLd(isLdE), 
        .isBeq(isBeqE), 
        .isBgt(isBgtE), 
        .isRet(isRetE),
        .isImmediate(isImmediateE), 
        .isWb(isWbE), 
        .isUbranch(isUbranchE), 
        .isCall(isCallE),
        .isAdd(isAddE), 
        .isSub(isSubE), 
        .isCmp(isCmpE), 
        .isMul(isMulE), 
        .isDiv(isDivE),
        .isMod(isModE), 
        .isLsl(isLslE), 
        .isLsr(isLsrE), 
        .isAsr(isAsrE), 
        .isOr (isOrE),
        .isAnd(isAndE), 
        .isNot(isNotE), 
        .isMov(isMovE),                 // Control signal for return
        .flag_eq(flag_eq),                 // Control signal for return
        .flag_gt(flag_gt),               // Global flags array passed from Processor
        .branchPC(branchPCE),         // Next PC for branch
        .isBranchTaken(isBranchTakenE),            // Signal indicating if the branch is taken
        .aluResult(aluResultE)          // Result of the ALU operation
    );

    // Latch 3
    Latch_ExecuteMemory lem(
        .clk(clk),
        .reset(reset),
        .PCE(PCE),
        .rdE(rdE),
        .aluResultE(aluResultE),
        .isStE(isStE),
        .isLdE(isLdE),
        .isBeqE(isBeqE),
        .isBgtE(isBgtE),
        .isRetE(isRetE),
        .isImmediateE(isImmediateE),
        .isWbE(isWbE),
        .isUbranchE(isUbranchE),
        .isCallE(isCallE),
        .isAddE(isAddE),
        .isSubE(isSubE),
        .isCmpE(isCmpE),
        .isMulE(isMulE),
        .isDivE(isDivE),
        .isModE(isModE),
        .isLslE(isLslE),
        .isLsrE(isLsrE),
        .isAsrE(isAsrE),
        .isOrE(isOrE),
        .isAndE(isAndE),
        .isNotE(isNotE),
        .isMovE(isMovE),
        .op1E(op1E),
        .op2E(op2E),
        .PCM(PCM),
        .rdM(rdM),
        .aluResultM(aluResultM),
        .isStM(isStM),
        .isLdM(isLdM),
        .isBeqM(isBeqM),
        .isBgtM(isBgtM),
        .isRetM(isRetM),
        .isImmediateM(isImmediateM),
        .isWbM(isWbM),
        .isUbranchM(isUbranchM),
        .isCallM(isCallM),
        .isAddM(isAddM),
        .isSubM(isSubM),
        .isCmpM(isCmpM),
        .isMulM(isMulM),
        .isDivM(isDivM),
        .isModM(isModM),
        .isLslM(isLslM),
        .isLsrM(isLsrM),
        .isAsrM(isAsrM),
        .isOrM(isOrM),
        .isAndM(isAndM),
        .isNotM(isNotM),
        .isMovM(isMovM),
        .op1M(op1M),
        .op2M(op2M),
        .stall(stall)
    );

    // Memory Unit
    MemoryUnit muu(
        .clk(clk),
        .isLd(isLdM),
        .isSt(isStM),
        .op2(op2M),
        .aluResult(aluResultM),
        .ldResult(ldResultM)
    );

    // Register file
    RegisterFile rf(
        .clk(clk),
        .reset(reset),
        .rs1(isRetD ? 4'd15 : rs1D), // Read address 1
        .rs2(isStD ? rdD : rs2D), // Read address 2
        .rd(rdM),  // Write address
        .writeData(isCallM ? PCM + 32'd4 : (isLdM ? ldResultM : aluResultM)), // Data to write
        .isWb(isWbM),      // Writeback enable
        .op1(op1D), // Data output for register rs1
        .op2(op2D) // Data output for register rs2
    );


endmodule

`endif // PROCESSOR_CORE_V
