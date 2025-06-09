module FetchUnit (
    input wire clk,
    input wire reset,
    input wire stallF,
    input wire isBranchTaken,
    input wire stallC,
    input wire track,
    input wire [31:0] branchPC,
    
    output reg [31:0] PC = -32'd4 // Initialize PC to 0
);

    //Synchronous PC update with reset
    always @(posedge clk) begin
        if (stallF == 0) begin
            if(track) begin
                PC <= PC + 32'd4; // ignore the repeatation of the instruction due to control hazard
            end else if (isBranchTaken) begin
                PC <= branchPC;   // Branch taken, set PC to branch address
            end else begin
                PC <= PC + 32'd4; // Default increment of 4 bytes (32-bit instruction)
            end
        end
    end
            
endmodule
