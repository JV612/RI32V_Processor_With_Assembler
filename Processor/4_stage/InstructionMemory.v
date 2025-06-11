
// Memory Module for 32-bit Instructions
module InstructionMemory (
    input wire [31:0] address,
    output reg [31:0] instruction
);

    // Simple memory array (change the depth as needed)
    reg [31:0] memory [0:255];  // 256 32-bit instructions

    // Initialize memory with sample instructions (optional)
    initial begin
        // Example instructions, modify as needed
        memory[0] = 32'b01001100010000000000000000000101;  //mov r1,5
        memory[1] = 32'b01001100100000000000000000000001;  //mov r2,1
        memory[2] = 32'b00010000100001001000000000000000;  //mul r2,r1,r2
        memory[3] = 32'b00001100010001000000000000000001;  //sub r1,r1,1
        memory[4] = 32'b00101100000001000000000000000001;  //cmp r1,1
        memory[5] = 32'b10001111111111111111111111111101;  //bgt -3
    end

    // Fetch instruction based on the address
    always @(*) begin
        instruction = memory[address[9:2]];  // Using address[9:2] to address word (32-bit aligned)
    end
endmodule
