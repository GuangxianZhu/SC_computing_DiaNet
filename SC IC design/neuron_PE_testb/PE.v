module PE(
    input [7:0] x1, // left previous PE output
    input [7:0] x2, // right previous PE output
    input [7:0] x_mem, // from external memory
    input [29:0] config_sig,   // {w1, w2, b, shif, slope, RD, WR}
    output reg [7:0] y_next, // output to next PE
    output reg [7:0] y_outmem // output to out memory
)
    // Split the config_sig to different parts
    wire [7:0] w1 = config_sig[29:22];
    wire [7:0] w2 = config_sig[21:14];
    wire [7:0] b  = config_sig[13:6];
    wire [2:0] shif = config_sig[5:4];
    wire [2:0] slope = config_sig[3:2];
    wire RD = config_sig[1];
    wire WR = config_sig[0];
    
    wire [7:0] neuron_output;
    
    // Instantiate neuron_unit
    neuron_unit neuron_inst (
        .w1(w1),
        .w2(w2),
        .x1((RD == 1'b0) ? x1 : x_mem), // Select input based on RD
        .x2(x2),
        .b(b),
        .shif(shif),
        .slope(slope),
        .y(neuron_output)
    );
    
    // Generate outputs based on control signals
    always @(*) begin
        if (WR == 1'b0) begin
            y_next = neuron_output;
            y_outmem = 8'b0; // Not outputting to external memory
        end else begin
            y_outmem = neuron_output;
            y_next = 8'b0; // Not outputting to next PE
        end
    end
endmodule
