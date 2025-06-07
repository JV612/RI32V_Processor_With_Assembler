module InstructionMemory (
    input wire [31:0] address,
    output reg [31:0] instruction
    
);

    // Assembly Program stored inside the Instruction Memory
    reg [31:0] Instructions [0:255]; 

    // Load Program Instructions into the memory
    initial begin
        
    end

    // Read address of 8-bit (divide by 4 for word addressing) and fetch instruction
    always @(*) begin
        instruction = memory[address[9:2]]; 
    end


endmodule