module StaggeredAdd(Clock, A, B, CI, S, CO);

    parameter N = 16; 
    input Clock;
    input [N-1:0] A, B;
    input CI;
    output logic [N-1:0] S;
    output logic CO;

    logic [7:0] Ah, Bh, Slw, Shw, Sl;
    logic Clw, Cl, Ch;

    cla8bit Cla1(A[7:0], B[7:0], CI, Slw, Clw);
    cla8bit Cla2(A[15:8], B[15:8], Cl, Shw, Ch);

    always_ff @(posedge Clock) begin 
        Sl <= Slw;
        Cl <= Clw;
        Ah <= A[15:8];
        Bh <= B[15:8];

        S[7:0] <= Sl;
        S[15:8] <= Shw;
        CO <= Ch;        
    end 


endmodule