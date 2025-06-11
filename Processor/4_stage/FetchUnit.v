module FetchUnit (
    input wire clk,
    input wire reset,
    input wire [1:0] stall,
    input wire isBranchTaken,
    input wire [1:0] stallC,
    input wire track,
    input wire [31:0] branchPC,
    output reg [31:0] PC = -32'd4 // Initialize PC to 0
);

    always @(posedge clk or posedge reset) begin
        if(stall == 0) begin

            if (stallC == 2) begin
                PC <= branchPC;
            end else if (stallC == 1) begin
                PC <= PC + 32'd4;       
            end else if (track) begin
                PC <= PC + 32'd4;
            end else if (reset)
                PC <= 32'd0; // Reset PC to 0
            else if (isBranchTaken)
                PC <= branchPC; // Branch taken, set PC to branch address
            else
                PC <= PC + 32'd4; // Default increment of 4 bytes (32-bit instruction)
        end
    end
endmodule
