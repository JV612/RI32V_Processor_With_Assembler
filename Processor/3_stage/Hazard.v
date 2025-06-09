module Hazard(
    input wire clk,
    input wire reset,
    input wire [3:0] rs1D,
    input wire [3:0] rs2D,
    input wire [3:0] rdE,
    input wire isBranchTakenE,
    output reg stall = 0,
    output reg [1:0] stallC,
    output reg track
);
    always @(negedge clk) begin
        if(track) begin
            track = 0;
        end

        if (stallC == 2) begin
            stallC = 1;
        end else if (stallC == 1) begin
            stallC = 0;
            track = 1;
        end else if (isBranchTakenE != 0) begin
            stallC = 2;
        end else if(stall != 0) begin
            stall = 0;
        end else if (rdE == 0) begin
            stall = 0;
        end else if (rs1D == rdE || rs2D == rdE) begin
            stall = 1;
        end else begin
            stall = 0;
            stallC = 0;
        end
    end

endmodule