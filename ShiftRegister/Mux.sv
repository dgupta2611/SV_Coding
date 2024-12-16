module mux 
#(
    parameter N = 8
) 
(
    input [N-1:0] M,
    input [$clog2(N)-1:0] S,
    output logic Y
);

    assign Y = M[S];
    
endmodule