module Hazard(
    input wire clk,
    input wire reset,
    input wire [3:0] rs1F,
    input wire [3:0] rs2F,
    input wire [3:0] rdE,
    input wire isBranchTakenE,
    output reg track,
    output reg stallF,
    output reg stallC
);

    always @(negedge clk or posedge reset) begin
        
        if(track == 1) begin
            track = 0;
        end

        if (stallC != 0) begin
            stallC = 0;
            track = 1;
        end else if (isBranchTakenE != 0) begin
            stallC = 1;
        end else if (stallF != 0) begin
            stallF <= 0;
        end else if (rdE == 0) begin
            stallF <= 0;
        end else if ((rs1F == rdE) || (rs2F == rdE)) begin
            stallF <= 1;
        end else begin
            stallF <= 0;
            stallC <= 0;
        end
    end

endmodule

