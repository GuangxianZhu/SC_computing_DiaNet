`timescale 1ns / 1ps

module neuron_unit_tb;
    reg [7:0] w1, w2, x1, x2, b;
    reg [2:0] shif, slope;
    wire [7:0] y;

    // Instantiate the module to test
    neuron_unit neuron_inst (
        .w1(w1),
        .w2(w2),
        .x1(x1),
        .x2(x2),
        .b(b),
        .shif(shif),
        .slope(slope),
        .y(y)
    );

    // Create a clock with a period of 20 ns (or whatever fits your design)
    initial begin
        w1 = 8'b00111111; // Sample input
        w2 = 8'b00111111; // Sample input
        x1 = 8'b00111111; // Sample input
        x2 = 8'b00111111; // Sample input
        b = 8'b00111111;  // Sample input
        shif = 3'b001; // Sample input
        slope = 3'b010; // Sample input

        #100; // Wait for 100 ns

        $finish; // Terminate the simulation
    end
endmodule
