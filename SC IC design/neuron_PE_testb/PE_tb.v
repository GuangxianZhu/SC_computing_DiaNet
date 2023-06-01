`timescale 1ns / 1ps

module PE_tb;
    reg [7:0] x1, x2, x_mem;
    reg [29:0] configer;
    wire [7:0] y_next, y_outmem;

    // Instantiate the module to test
    PE pe_inst (
        .x1(x1),
        .x2(x2),
        .x_mem(x_mem),
        .config_sig(configer),
        .y_next(y_next),
        .y_outmem(y_outmem)
    );

    initial begin
        // Initialize inputs
        x1 = 8'b00111111;
        x2 = 8'b00111111;
        x_mem = 8'b00111111;
        // Configure the PE
        configer = 29'b0011111100111111001111110001; // Some sample configuration
        // Wait for a while
        #100;
        // Modify inputs
        x1 = 8'b00111100;
        x2 = 8'b00111100;
        x_mem = 8'b00111100;
        // Modify the configuration
        configer = 29'b0011111100111111001111110001; // Some sample configuration
        // Wait for a while
        #100;
        // Finish the simulation
        $finish;
    end
endmodule
