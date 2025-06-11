
module Latch_DecodeExecute (
    input clk,
    input reset,
    input wire [31:0] instructionD,
    input wire [31:0] PCD,
    input wire [31:0] branchTargetD,
    input wire [31:0] immxD,
    input wire isStD, isLdD, isBeqD, isBgtD, isRetD,
    input wire isImmediateD, isWbD, isUbranchD, isCallD,
    input wire isAddD, isSubD, isCmpD, isMulD, isDivD,
    input wire isModD, isLslD, isLsrD, isAsrD, isOrD,
    input wire isAndD, isNotD, isMovD,
    input wire [3:0] rdD,
    input wire [31:0] op1D,
    input wire [31:0] op2D,
    input wire [1:0] stall,
    input wire [1:0] stallC,
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
    if(stall == 0 && stallC == 0) begin
        instructionE <= instructionD;
        PCE <= PCD;
        branchTargetE <= branchTargetD;
        immxE <= immxD;
        isStE <= isStD;
        isLdE <= isLdD;
        isBeqE <= isBeqD;
        isBgtE <= isBgtD;
        isRetE <= isRetD;
        isImmediateE <= isImmediateD;
        isWbE <= isWbD;
        isUbranchE <= isUbranchD;
        isCallE <= isCallD;
        isAddE <= isAddD;
        isSubE <= isSubD;
        isCmpE <= isCmpD;
        isMulE <= isMulD;
        isDivE <= isDivD;
        isModE <= isModD;
        isLslE <= isLslD;
        isLsrE <= isLsrD;
        isAsrE <= isAsrD;
        isOrE <= isOrD;
        isAndE <= isAndD;
        isNotE <= isNotD;
        isMovE <= isMovD;
        rdE <= rdD;
        op1E <= op1D;
        op2E <= op2D;
    end
end
endmodule