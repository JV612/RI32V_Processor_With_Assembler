`timescale 1ns / 1ps

module ControlUnit(
    input [5:0] opcode,         // 6-bit opcode where opcode[5] = I (immediate bit)
    output reg isSt, isLd, isBeq, isBgt, isRet,
    output reg isImmediate, isWb, isUbranch, isCall,
    output reg isAdd, isSub, isCmp, isMul, isDiv,
    output reg isMod, isLsl, isLsr, isAsr, isOr,
    output reg isAnd, isNot, isMov
);

    // Internal signals for extracting parts of the opcode
    wire I = opcode[0];             // Immediate bit
    wire [4:0] op = opcode[5:1];    // Actual 5-bit opcode
    
    always @(*) begin
        
        isSt = 0; 
        isLd = 0; 
        isBeq = 0; 
        isBgt = 0; 
        isRet = 0;
        isImmediate = 0; 
        isWb = 0; 
        isUbranch = 0; 
        isCall = 0;
        isAdd = 0; 
        isSub = 0; 
        isCmp = 0; 
        isMul = 0; 
        isDiv = 0;
        isMod = 0; 
        isLsl = 0; 
        isLsr = 0; 
        isAsr = 0; 
        isOr = 0;
        isAnd = 0; 
        isNot = 0; 
        isMov = 0;
        
        case (op)
            5'b01111: isSt = 1;                  // Store instruction
            5'b01110: isLd = 1;                  // Load instruction
            5'b10000: isBeq = 1;                 // Branch if equal
            5'b10001: isBgt = 1;                 // Branch if greater
            5'b10100: isRet = 1;                 // Return
            5'b00000: isAdd = 1;                 // Add
            5'b00001: isSub = 1;                 // Subtract
            5'b00101: isCmp = 1;                 // Compare
            5'b00010: isMul = 1;                 // Multiply
            5'b00011: isDiv = 1;                 // Divide
            5'b00100: isMod = 1;                 // Modulus
            5'b00110: isAnd = 1;                 // AND
            5'b00111: isOr = 1;                  // OR
            5'b01000: isNot = 1;                 // NOT
            5'b01001: isMov = 1;                 // Move
            5'b01010: isLsl = 1;                 // Logical shift left
            5'b01011: isLsr = 1;                 // Logical shift right
            5'b01100: isAsr = 1;                 // Arithmetic shift right
            5'b10010: isUbranch = 1;             // Unconditional branch
            5'b10011: isCall = 1;                // Call
        endcase

        // Immediate bit set
        if (I) isImmediate = 1;

        if(isLd || isSt) isAdd = 1;
        
        // Writeback instructions (isWb)
        isWb = (isAdd | isSub | isMul | isDiv | isMod | isAnd | isOr |
                isNot | isMov | isLd | isLsl | isLsr | isAsr | isCall);

        // Unconditional branch instructions (isUbranch)
        isUbranch = (op == 5'b10010) || isCall || isRet;

        // Call instructions (isCall)
        isCall = (op == 5'b10011);
    end
endmodule

