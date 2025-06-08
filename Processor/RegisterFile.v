
module RegisterFile (
    input wire clk,
    input wire reset,
    input wire [3:0] rs1, // Read address 1
    input wire [3:0] rs2, // Read address 2
    input wire [3:0] rd,  // Write address
    input wire [31:0] writeData, // Data to write
    input wire isWb,      // Writeback enable
    output wire [31:0] op1, // Data output for register rs1
    output wire [31:0] op2  // Data output for register rs2
);
    reg [31:0] regFileData [0:15]; // 16 registers, 32-bit width

    // Default values for registers
    initial begin
        regFileData[0] = 32'b0;
        regFileData[1] = 32'b0;
        regFileData[2] = 32'b0;
        regFileData[3] = 32'b0;
        regFileData[4] = 32'b0;
        regFileData[5] = 32'b0;
        regFileData[6] = 32'b0;
        regFileData[7] = 32'b0;
        regFileData[8] = 32'b0;
        regFileData[9] = 32'b0;
        regFileData[10] = 32'b0;
        regFileData[11] = 32'b0;
        regFileData[12] = 32'b0;
        regFileData[13] = 32'b0;
        regFileData[14] = 32'b0;
        regFileData[15] = 32'b0;
    end

    // Initialize register file at start of simulation
    // Combinational read logic
    assign op1 = regFileData[rs1]; // Read from rs1
    assign op2 = regFileData[rs2]; // Read from rs2

    // if (isWb) begin
    //     regFileData[rd] <= writeData; // Write to rd
    // end
    //Synchronous write logic
    always @(*) begin
        if (isWb && rd!=4'b0000) begin // Writeback condition, avoid register 0 if necessary
            regFileData[rd] <= writeData;
        end
    end
endmodule
