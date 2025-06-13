// Memory Module for 32-bit Instructions
module InstructionMemory (
    input wire [31:0] address,
    output reg [31:0] instruction
);

    // Simple memory array (change the depth as needed)
    reg [31:0] memory [0:255];  // 256 32-bit instructions

    // Initialize memory with sample instructions (optional)
    initial begin
        
        $readmemb("instructions.txt", memory);

    end

    // Fetch instruction based on the address
    always @(*) begin
        instruction = memory[address[9:2]];  // Using address[9:2] to address word (32-bit aligned)
    end
    
endmodule
