module neuron_unit(
    input [7:0] w1,   // [7:3] is the integer part, [2:0] is the fraction part
    input [7:0] w2,   
    input [7:0] x1,   
    input [7:0] x2,   
    input [7:0] b,
    input [2:0] shif, // shift amount
    input [2:0] slope, // leaky ReLU slope, right shift 3 is for 0.125
    output reg [7:0] y
)
    reg [15:0] temp1;
    reg [15:0] temp2;
    reg [7:0]  sum;
    reg [7:0]  leaky_slope;

    always @(*) begin
        // w1*x1 and w2*x2, then shift
        temp1 = w1 * x1;
        temp2 = w2 * x2;

        // Shift down to our fixed point format
        temp1 = temp1 >> shif;
        temp2 = temp2 >> shif;

        // Add results and bias
        sum = temp1[7:0] + temp2[7:0] + b;

        // Apply leaky ReLU, note that this is a simple implementation
        // leaky ReLU is defined as y = x if x > 0, else y = slope * x
        if (sum > 7'd0) begin
            y = sum;
        end else begin
            leaky_slope = slope * sum; 
            leaky_slope = leaky_slope >> 3; // adjust slope for fixed point format
            y = leaky_slope[7:0];
        end
    end
endmodule
