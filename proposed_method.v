// Code your design here
module Comparator #(
    parameter N = 8
)(
    input signed [N-1:0] X,
    input signed [N-1:0] Y,
    output reg G
);
    always @* begin
        G = (X > Y) ? 1'b1 : 1'b0;
    end
endmodule

module Mux2x1 #(
    parameter N = 8
)(
    input signed [N-1:0] A,
    input signed [N-1:0] B,
    input Sel,
    output signed [N-1:0] Y
);
    assign Y = Sel ? B : A;
endmodule

module TwosComplement #(
    parameter N = 8
)(
    input signed [N-1:0] A,
    output signed [N-1:0] B
);
    assign B = ~A + 1;
endmodule

module PriorityEncoder #(
    parameter N = 8
)(
    input [N-1:0] A,
    output reg [$clog2(N)-1:0] B
);
    integer i;
    always @* begin
        B = 0;
        for (i = 0; i < N; i = i + 1) begin
            if (A[N-1-i]) begin
                B = N-1-i;
            end
        end
    end
endmodule

module Subtractor #(
    parameter N = 8
)(
    input signed [N-1:0] A,
    input signed [N-1:0] B,
    output signed [N-1:0] Y
);
    assign Y = A - B;
endmodule

module BoothMultiplier #(
    parameter N = 8
)(
    input signed [N-1:0] A,
    input signed [N-1:0] B,
    output signed [2*N-1:0] P
);
    assign P = A * B;
endmodule

module ProposedMultiplier #(
    parameter N = 8
)(
    input signed [N-1:0] A,
    input signed [N-1:0] B,
    output signed [2*N-1:0] P
);
    assign P = A * B;
endmodule

module CarrySubstitutionAdder #(
    parameter N = 8
)(
    input signed [N-1:0] A,
    input signed [N-1:0] B,
    output signed [N-1:0] Sum,
    output CarryOut
);
    wire [N-1:0] Carry;
    genvar i;

    generate
    for (i = 0; i < N; i = i + 1) begin : adder_bits
        if (i == 0) begin
            assign {Carry[i], Sum[i]} = A[i] + B[i];
        end else begin
            assign {Carry[i], Sum[i]} = A[i] + B[i] + Carry[i-1];
        end
    end
    endgenerate

    assign CarryOut = Carry[N-1];
endmodule

module HalfSubtractor(
    input X,
    input Y,
    output D,
    output B
);
    assign D = X ^ Y;
    assign B = ~X & Y;
endmodule

module TopModule #(
    parameter N = 8
)(
    input signed [N-1:0] X,
    input signed [N-1:0] Y,
    output signed [2*N-1:0] Result
);
    wire G;
    wire signed [N-1:0] X_comp, Y_comp;
    wire signed [N-1:0] mux_out1, mux_out2;
    wire signed [N-1:0] sub_out, sum_out;
    wire signed [2*N-1:0] mult_out;
    wire carry_out;

    // Instantiate the modules
    Comparator #(.N(N)) cmp(
        .X(X),
        .Y(Y),
        .G(G)
    );

    Mux2x1 #(.N(N)) mux1(.A(X), .B(Y), .Sel(G), .Y(mux_out1));
    Mux2x1 #(.N(N)) mux2(.A(Y), .B(X), .Sel(G), .Y(mux_out2));

    TwosComplement #(.N(N)) tc1(.A(X), .B(X_comp));
    TwosComplement #(.N(N)) tc2(.A(Y), .B(Y_comp));

    Subtractor #(.N(N)) sub(.A(X), .B(Y), .Y(sub_out));

    CarrySubstitutionAdder #(.N(N)) csa(.A(X), .B(Y), .Sum(sum_out), .CarryOut(carry_out));

    BoothMultiplier #(.N(N)) bm(.A(X), .B(Y), .P(mult_out));

    // Uncomment and define the ProposedMultiplier if needed
    // ProposedMultiplier #(.N(N)) pm(.A(X), .B(Y), .P(mult_out));

    assign Result = mult_out;
endmodule

