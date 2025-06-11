module Latch_ExecuteMemory(
    input wire clk,
    input wire reset,
    input wire [31:0] PCE,
    input wire [3:0] rdE,
    input wire [31:0] aluResultE,
    input wire [1:0] stall,
    input wire isStE, isLdE, isBeqE, isBgtE, isRetE,
    input wire isImmediateE, isWbE, isUbranchE, isCallE,
    input wire isAddE, isSubE, isCmpE, isMulE, isDivE,
    input wire isModE, isLslE, isLsrE, isAsrE, isOrE,
    input wire isAndE, isNotE, isMovE,
    input wire [31:0] op1E,
    input wire [31:0] op2E,
    output reg [31:0] PCM,
    output reg [3:0] rdM,
    output reg [31:0] aluResultM,
    output reg isStM, isLdM, isBeqM, isBgtM, isRetM,
    output reg isImmediateM, isWbM, isUbranchM, isCallM,
    output reg isAddM, isSubM, isCmpM, isMulM, isDivM,  
    output reg isModM, isLslM, isLsrM, isAsrM, isOrM,
    output reg isAndM, isNotM, isMovM,
    output reg [31:0] op1M,
    output reg [31:0] op2M
);

always @(posedge clk or posedge reset) begin
    //if(stall == 0) begin
        rdM <= rdE;
        aluResultM <= aluResultE;
        isStM <= isStE; 
        isLdM <= isLdE;
        isBeqM <= isBeqE; 
        isBgtM <= isBgtE; 
        isRetM <= isRetE;
        isImmediateM <= isImmediateE; 
        isWbM <= isWbE; 
        isUbranchM <= isUbranchE; 
        isCallM <= isCallE;
        isAddM <= isAddE; 
        isSubM <= isSubE; 
        isCmpM <= isCmpE; 
        isMulM <= isMulE; 
        isDivM <= isDivE;
        isModM <= isModE; 
        isLslM <= isLslE; 
        isLsrM <= isLsrE; 
        isAsrM <= isAsrE; 
        isOrM <= isOrE;
        isAndM <= isAndE; 
        isNotM <= isNotE; 
        isMovM <= isMovE;
        op1M <= op1E;
        op2M <= op2E;
    //end
end

endmodule