module fixed_point_multiplier(
    input [7:0] a,   // a[7:3] is the integer part, a[2:0] is the fraction part
    input [7:0] b,   // b[7:3] is the integer part, b[2:0] is the fraction part
    output reg [7:0] c   // c[7:3] is the integer part, c[2:0] is the fraction part
);
    reg [15:0] temp_product;
    
    always @(*)
    begin
        temp_product = a * b; // multiplication result will be 16 bits
        c = temp_product >> 3; // adjust for fixed point. This is like dividing by 8.
    end
endmodule
