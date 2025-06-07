include "ControlUnit.v"

module OF (
    input wire clk,
    input wire reset,
    input wire PC,
    input wire [31:0] instruction,

    output reg [31:0] branchTarget,
    output reg [31:0] immediateValue


);

    // calculate branch target address
    wire [26:0] branchOffset = instruction[26:0];
    wire [17:0] imm = instruction[17:0];
    wire [5:0] opcodeandibit = instruction[31:26];

    wire rd1 = instruction[25:22];
    wire rs1 = instruction[21:18];
    wire rs2 = instruction[17:14];

    always @(*) begin
        
        branchTarget = PC + {{3{branchOffset[26]}}, branchOffset[26:0], 2'b00}; 

        if(reset) begin
            immediateValue <= 32'b0; 
        end else begin
            case(imm[17:16]) 
                2'b00: immediateValue <= {16'b0, imm[15:0]};
                2'b01: immediateValue <= {16{imm[15]} , imm[15:0]};
                2'b10: immediateValue <= {imm[15:0], 16'b0};
                default: immediateValue <= 32'b0; 
            endcase
        end
    end

    ControlUnit controlUnit (
        .opcode(opcodeandibit),
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
