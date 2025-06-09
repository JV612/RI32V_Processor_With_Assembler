module Latch_FetchExecute (
    input clk,
    input reset,
    input wire stallC,
    input wire [31:0] instructionF,
    input wire [31:0] PCF,
    input wire [31:0] branchTargetF,
    input wire [31:0] immxF,
    input wire isStF, isLdF, isBeqF, isBgtF, isRetF,
    input wire isImmediateF, isWbF, isUbranchF, isCallF,
    input wire isAddF, isSubF, isCmpF, isMulF, isDivF,
    input wire isModF, isLslF, isLsrF, isAsrF, isOrF,
    input wire isAndF, isNotF, isMovF,
    input wire [3:0] rdF,
    input wire [31:0] op1F,
    input wire [31:0] op2F,
    input wire stallF,
    output reg [31:0] instructionE,
    output reg [31:0] PCE,
    output reg [31:0] branchTargetE,
    output reg [31:0] immxE,
    output reg isStE, isLdE, isBeqE, isBgtE, isRetE,
    output reg isImmediateE, isWbE, isUbranchE, isCallE,
    output reg isAddE, isSubE, isCmpE, isMulE, isDivE,
    output reg isModE, isLslE, isLsrE, isAsrE, isOrE,
    output reg isAndE, isNotE, isMovE,
    output reg [3:0] rdE,
    output reg [31:0] op1E,
    output reg [31:0] op2E
);

always @(posedge clk or posedge reset) begin
    if (stallF == 0 && stallC == 0) begin
        instructionE <= instructionF;
        PCE <= PCF;
        branchTargetE <= branchTargetF;
        immxE <= immxF;
        isStE <= isStF;
        isLdE <= isLdF;
        isBeqE <= isBeqF;
        isBgtE <= isBgtF;
        isRetE <= isRetF;
        isImmediateE <= isImmediateF;
        isWbE <= isWbF;
        isUbranchE <= isUbranchF;
        isCallE <= isCallF;
        isAddE <= isAddF;
        isSubE <= isSubF;
        isCmpE <= isCmpF;
        isMulE <= isMulF;
        isDivE <= isDivF;
        isModE <= isModF;
        isLslE <= isLslF;
        isLsrE <= isLsrF;
        isAsrE <= isAsrF;
        isOrE <= isOrF;
        isAndE <= isAndF;
        isNotE <= isNotF;
        isMovE <= isMovF;
        rdE <= rdF;
        op1E <= op1F;
        op2E <= op2F;
    end
end
endmodule
