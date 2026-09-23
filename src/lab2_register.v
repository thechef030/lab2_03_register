`timescale 1ns/1ps

// Combo II-DLD S75. Main clock B6 MUST be set to 1 kHz.
// K4: reset. N8: step button. DIPSW1..8 = sw[7]..sw[0].
module lab2_register #(parameter integer STABLE_CYCLES = 20) (
    input wire clk, rst, button,
    input wire [7:0] sw,
    output wire [7:0] led
);

    wire reset, press;
    wire [7:0] switches;

    input_frontend #(.STABLE_CYCLES(STABLE_CYCLES)) inputs(
        clk, rst, button, sw, reset, press, switches);

    wire [3:0] stored, value;

    register_pair core(clk, reset, press && switches[0],
                       press && switches[1], switches[7:4], stored, value);

    assign led = {stored, value};

endmodule
