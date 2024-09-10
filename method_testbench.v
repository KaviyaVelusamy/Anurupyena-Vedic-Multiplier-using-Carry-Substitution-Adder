// Code your testbench here
// or browse Examples
module TopModule_tb;

    parameter N = 8;

    reg signed [N-1:0] X;
    reg signed [N-1:0] Y;
    wire signed [2*N-1:0] Result;

    // Instantiate the TopModule
    TopModule #(.N(N)) uut (
        .X(X),
        .Y(Y),
        .Result(Result)
    );

    initial begin
        $display("Time\t\tX\t\tY\t\tResult");

        // Test cases
        X = 0;
        Y = 0;

        #10 X = 8'sh1B; Y = 8'sh05; // 27 * 5
        #10 X = 8'sh0C; Y = 8'sh0A; // 12 * 10
        #10 X = 8'shF0; Y = 8'sh0F; // -16 * 15
        #10 X = 8'sh01; Y = 8'sh01; // 1 * 1
        #10 X = 8'sh00; Y = 8'sh01; // 0 * 1
        #10 X = 8'shFF; Y = 8'shFF; // -1 * -1
        #10 X = 8'sh7F; Y = 8'sh02; // 127 * 2
        #10 X = 8'sh80; Y = 8'sh02; // -128 * 2
        #10 X = 8'shAA; Y = 8'sh55; // -86 * 85
        #10 X = 8'sh7F; Y = 8'shFF; // 127 * -1

        #10 $finish;
    end

    initial begin
        $monitor("At time %t, X = %h (%0d), Y = %h (%0d), Result = %h (%0d)",
                 $time, X, X, Y, Y, Result, Result);
    end

endmodule

