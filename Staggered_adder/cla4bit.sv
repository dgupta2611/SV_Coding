module cla4bit #(
    parameter N = 4
) (
    input [N-1:0] A, B,
    input cin,
    output logic [N-1:0] S,
    output logic cout
);

    logic [N-1:0] P, G, C; 

    // P is the output of A EXOR B so, the expression P[n] = A[n] ^ B[n]
    assign P[0] = A[0] ^ B[0];
    assign P[1] = A[1] ^ B[1];
    assign P[2] = A[2] ^ B[2];
    assign P[3] = A[3] ^ B[3];

    // G is the output of A and B so, the expression G[n] = A[n] & B[n]
    assign G[0] = A[0] & B[0];
    assign G[1] = A[1] & B[1];
    assign G[2] = A[2] & B[2];
    assign G[3] = A[3] & B[3];

    // Carry expression  C[n+1] = G[n] | (P[n] & C[n])
    assign C[0] = CI;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign CO   = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);


    // The expression of sum, S[n] = P[n] ^ C[n]
    assign S[0] = P[0] ^ C[0];
    assign S[1] = P[1] ^ C[1];
    assign S[2] = P[2] ^ C[2];
    assign S[3] = P[3] ^ C[3];

    
endmodule