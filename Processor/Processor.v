`include "IF.v"
`include "InstructionMemory.v"
`include "OF.v"
`include "EX.v"
`include "MA.v"
`include "RF.v"

module Processor (

    input wire clk,
    input wire reset,
    
    output wire [31:0] PC,
    output wire [31:0] instruction,
    output wire [31:0] branchPC,
    output wire isBranchTaken,
    output wire [31:0] branchTarget,
    output wire [31:0] immediateValue,
    output wire [3:0] rd, rs1, rs2,
    output wire isSt, isLd, isBeq, isBgt, isRet,
    output wire isImmediate, isWb, isUbranch, isCall,
    output wire isAdd, isSub, isCmp, isMul, isDiv,
    output wire isMod, isLsl, isLsr, isAsr, isOr,
    output wire isAnd, isNot, isMov,

    output wire [31:0] op1, op2,
    output wire [31:0] aluResult,
    output wire flag_eq,
    output wire flag_gt,
    output wire [31:0] ldResult

);

    IF if_stage (
        .clk(clk),
        .reset(reset),
        .branchPC(branchPC),
        .isBranchTaken(isBranchTaken),
        
        .PC(PC)
    );

    InstructionMemory instructionMemory (
        .address(PC),
        .instruction(instruction)
    );

    OF of_stage (
        .clk(clk),
        .reset(reset),
        .PC(PC),
        .instruction(instruction),
        
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
        .isMov(isMov)
    );

    EX ex_stage (
        .clk(clk),
        .reset(reset),
        .op1(op1),
        .op2(op2),
        .immediateValue(immediateValue),
        .branchTarget(branchTarget),
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

        .flag_eq(flag_eq),
        .flag_gt(flag_gt),
        .branchPC(branchPC),
        .isBranchTaken(isBranchTaken),
        .aluResult(aluResult)
    );

    MA ma_stage (
        .clk(clk),
        .reset(reset),
        .isLd(isLd),
        .isSt(isSt),
        .op2(op2),
        .aluResult(aluResult),

        .ldResult(ldResult)    
    );

    RF rf_stage (
        .clk(clk),
        .reset(reset),
        .rs1(rs1),
        .rs2(rs2),
        .isWb(isWb),
        .writeData( isCall ? PC + 32'd4 : (isLd ? ldResult : aluResult) ),
        .writeaddress( isCall ? 4'b1111 : rd ), 

        .op1(op1),
        .op2(op2)
    );

endmodule
