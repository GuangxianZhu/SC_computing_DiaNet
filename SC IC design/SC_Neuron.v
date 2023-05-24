module SC_Neuron(
    input [63:0] input1, input2, input3, w1, w2, w3, b,
    input input1_enable, input2_enable, input3_enable,
    output reg [63:0] output
);
    wire [63:0] mult1, mult2, mult3;
    wire [63:0] add1, add2;
    reg [2:0] state; // State variable for the FSM
    reg [5:0] count; // Counter for 64 bits

    // Multiplication
    assign mult1 = input1_enable ? (input1 & w1) : 64'b0;
    assign mult2 = input2_enable ? (input2 & w2) : 64'b0;
    assign mult3 = input3_enable ? (input3 & w3) : 64'b0;

    // First Addition
    SC_Adder_3 adder1(.A(mult1), .B(mult2), .C(mult3), .Y(add1));

    // FSM for the sigmoid activation function
    always @(posedge clk) begin
        if (count == 0) begin
            state <= 0; // Start at state s0
            output[0] <= 1'b0;
        end
        else begin
            // Update state based on input bit
            if (add1[count] == 1'b1 && state < 7)
                state <= state + 1;
            else if (add1[count] == 1'b0 && state > 0)
                state <= state - 1;

            // Update output based on state
            output[count] <= (state >= 4) ? 1'b1 : 1'b0;
        end

        // Update counter
        count <= count + 1;
        if (count == 64)
            count <= 0;
    end

    // Second Addition
    SC_Adder adder2(.A(output), .B(b), .Y(add2));
endmodule
