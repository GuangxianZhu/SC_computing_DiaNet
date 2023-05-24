module SC_Adder(
    input [63:0] A, B,
    output reg [63:0] Y
);
    reg [63:0] random_stream; // Random bit stream
    reg [5:0] count; // Counter for 64 bits

    initial begin
        // Generate a random bit stream with p=0.5
        for (count = 0; count < 64; count = count + 1)
            random_stream[count] = $random % 2;
    end

    always @(posedge clk) begin
        // Select a bit from A or B based on the random bit stream
        Y[count] <= random_stream[count] ? A[count] : B[count];

        // Update counter
        count <= count + 1;
        if (count == 64)
            count <= 0;
    end
endmodule
