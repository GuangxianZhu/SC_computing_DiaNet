module SC_Adder_3(
    input [63:0] A, B, C,
    output reg [63:0] Y
);
    reg [63:0] random_stream; // Random bit stream
    reg [5:0] count; // Counter for 64 bits

    initial begin
        // Generate a random bit stream with p=1/3
        for (count = 0; count < 64; count = count + 1)
            random_stream[count] = $random % 3;
    end

    always @(posedge clk) begin
        // Select a bit from A, B, or C based on the random bit stream
        if (random_stream[count] == 0)
            Y[count] <= A[count];
        else if (random_stream[count] == 1)
            Y[count] <= B[count];
        else
            Y[count] <= C[count];

        // Update counter
        count <= count + 1;
        if (count == 64)
            count <= 0;
    end
endmodule
