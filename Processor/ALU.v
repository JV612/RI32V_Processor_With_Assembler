module ALU (
    input wire [31:0] A,               // First operand
    input wire [31:0] B,               // Second operand
    input wire isAdd,                  // Control signal for addition
    input wire isSub,                  // Control signal for subtraction
    input wire isMul,                  // Control signal for multiplication
    input wire isDiv,                  // Control signal for division
    input wire isCmp,                  // Control signal for comparison
    input wire isMod,                  // Control signal for modulus
    input wire isOr,                   // Control signal for OR operation
    input wire isAnd,                  // Control signal for AND operation
    input wire isNot,                  // Control signal for NOT operation
    input wire isMov,                  // Control signal for MOV operation
    input wire isLsl,                  // Control signal for left shift logical
    input wire isLsr,                  // Control signal for right shift logical
    input wire isAsr,                  // Current flags register passed from ExecuteUnit
    output reg [31:0] aluResult,       // Result of ALU operation
    output reg flag_eq,
    output reg flag_gt         
);

wire [3:0] local_flags;                 // Local flags register

// Always block to handle ALU operations
always @(*) begin
    // Default results
    aluResult = 32'b0; // Initialize aluResult

    if (isAdd) begin
        aluResult = A + B;
    end else if (isSub) begin
        aluResult = A - B;
    end else if (isMul) begin
        aluResult = A * B;
    end else if (isDiv) begin
        aluResult = B != 0 ? A / B : 32'b0; // Check for division by zero
    end else if (isMod) begin
        aluResult = B != 0 ? A % B : 32'b0;
    end else if (isOr) begin
        aluResult = A | B;
    end else if (isAnd) begin
        aluResult = A & B;
    end else if (isNot) begin
        aluResult = ~A;
    end else if (isMov) begin
        aluResult = B;
    end else if (isLsl) begin
        aluResult = A << B;
    end else if (isLsr) begin
        aluResult = A >> B;
    end else if (isAsr) begin
        aluResult = A >>> B;
    end else if (isCmp) begin
        // Comparison and updating the local flags
        flag_eq = (A == B) ? 1'b1 : 1'b0; // Equal flag
        flag_gt = (A > B) ? 1'b1 : 1'b0;  // Greater Than flag
    end
end

endmodule
