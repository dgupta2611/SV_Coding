module cla8bit #(
    parameter N = 8
) (
    input [N-1:0] A, B,
    input cin,
    output logic [N-1:0] S,
    output logic cout
);

    logic CO;

    cla4bit Cla1(A[3:0], B[3:0], cin, S[3:0], CO);
    cla4bit Cla2(A[7:4], B[7:4], CO, S[7:4], cout);

endmodule

