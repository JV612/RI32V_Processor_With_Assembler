`ifndef PROCESSOR_CORE_V
`define PROCESSOR_CORE_V
`include "FetchUnit.v"
`include "OperandFetchUnit.v"
`include "ExecuteUnit.v"
`include "MemoryUnit.v"
`include "InstructionMemory.v"
`include "Latch_FetchExecute.v"
`include "Hazard.v"

module ProcessorCore (
    input wire clk,
    input wire reset,
    output wire flag_eq,
    output wire flag_gt,
    output wire [31:0] PCF,
    output wire [31:0] instructionF,
    output wire [31:0] branchTargetF,
    output wire [31:0] immxF,
    output wire isStF, isLdF, isBeqF, isBgtF, isRetF,
    output wire isImmediateF, isWbF, isUbranchF, isCallF,
    output wire isAddF, isSubF, isCmpF, isMulF, isDivF,
    output wire isModF, isLslF, isLsrF, isAsrF, isOrF,
    output wire isAndF, isNotF, isMovF,
    output wire [31:0] op1F,
    output wire [31:0] op2F,
    output wire [31:0] branchPCF,         
    output wire isBranchTakenF,
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
    output wire [3:0] rdF, 
    output wire [3:0] rs1F, 
    output wire [3:0] rs2F, 
    output wire [3:0] rdE, 
    output wire [3:0] rs1E, 
    output wire [3:0] rs2E,          
    output wire [31:0] aluResult,
    output wire stallF,
    output wire stallC,
    output wire track
);
    
    // Hazard control signals
    Hazard hz(
        .clk(clk),
        .reset(reset),
        .rs1F(rs1F),
        .rs2F(rs2F),
        .rdE(rdE),
        .stallF(stallF),
        .stallC(stallC),
        .isBranchTakenE(isBranchTakenE),
        .track(track)
    );

    wire [31:0] aluResultW, ldResultE;

    // Instantiate FetchUnit
    FetchUnit fuu(
        .clk(clk),
        .reset(reset),
        .isBranchTaken(isBranchTakenE),
        .branchPC(branchPCE),
        .PC(PCF),
        .stallF(stallF),
        .stallC(stallC),
        .track(track)
    );

    //Instruction Fetch
    InstructionMemory mem (
        .address(PCF),
        .instruction(instructionF)
    );
    
    //Operation Fetch Unit
    OperandFetchUnit ofu(
        .clk(clk),
        .reset(reset),
        .instruction(instructionF),
        .PC(PCF),
        .branchTarget(branchTargetF),
        .immx(immxF),
        .isSt(isStF),
        .isLd(isLdF),
        .isBeq(isBeqF), 
        .isBgt(isBgtF), 
        .isRet(isRetF),
        .isImmediate(isImmediateF), 
        .isWb(isWbF), 
        .isUbranch(isUbranchF), 
        .isCall(isCallF),
        .isAdd(isAddF), 
        .isSub(isSubF), 
        .isCmp(isCmpF), 
        .isMul(isMulF), 
        .isDiv(isDivF),
        .isMod(isModF),
        .isLsl(isLslF), 
        .isLsr(isLsrF), 
        .isAsr(isAsrF), 
        .isOr(isOrF),
        .isAnd(isAndF),
        .isNot(isNotF), 
        .isMov(isMovF),
        .rd(rdF),
        .rs1(rs1F),
        .rs2(rs2F)
    );

    Latch_FetchExecute lfe(
        .stallC(stallC),
        .clk(clk),
        .reset(reset),
        .instructionF(instructionF),
        .PCF(PCF),
        .branchTargetF(branchTargetF),
        .immxF(immxF),
        .isStF(isStF), 
        .isLdF(isLdF), 
        .isBeqF(isBeqF), 
        .isBgtF(isBgtF), 
        .isRetF(isRetF),
        .isImmediateF(isImmediateF), 
        .isWbF(isWbF), 
        .isUbranchF(isUbranchF), 
        .isCallF(isCallF),
        .isAddF(isAddF), 
        .isSubF(isSubF), 
        .isCmpF(isCmpF), 
        .isMulF(isMulF), 
        .isDivF(isDivF),
        .isModF(isModF), 
        .isLslF(isLslF), 
        .isLsrF(isLsrF), 
        .isAsrF(isAsrF), 
        .isOrF(isOrF),
        .isAndF(isAndF), 
        .isNotF(isNotF), 
        .isMovF(isMovF),
        .rdF(rdF),
        .op1F(op1F),
        .op2F(op2F),
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
        .stallF(stallF)
    );

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
        .aluResult(aluResult)          // Result of the ALU operation
);

    MemoryUnit muu(
        .clk(clk),
        .isLd(isLdE),
        .isSt(isStE),
        .op2(op2E),
        .aluResult(aluResult),
        .ldResult(ldResultE)
    );

    RegisterFile rf(
        .clk(clk),
        .reset(reset),
        .rs1(isRetF ? 4'd15 : rs1F), // Read address 1
        .rs2(isStF ? rdF : rs2F), // Read address 2
        .rd(rdE),  // Write address
        .writeData(isCallE ? PCE + 32'd4 : (isLdE ? ldResultE : aluResult)), // Data to write
        .isWb(isWbE),      // Writeback enable
        .op1(op1F), // Data output for register rs1
        .op2(op2F) // Data output for register rs2
    );


endmodule

`endif
