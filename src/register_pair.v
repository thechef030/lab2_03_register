`timescale 1ns/1ps

module register_pair (
    input wire clk, rst, load, transfer,
    input wire [3:0] data_in,
    output reg [3:0] stored, value
);

    always @(posedge clk) begin
        if (rst) begin
            stored <= 4'd0;
            value <= 4'd0;
        end else begin
            if (load) stored <= data_in;
            if (transfer) value <= stored;
        end
    end

endmodule
