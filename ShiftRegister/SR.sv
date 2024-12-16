module SR 
#(
    parameter N = 8
) 
(
    input clk, clear,
    input [N-1:0] D,
    input MSBin, LSBin,
    input [$clog2(N)-1:0] S,
    output logic [N-1:0] Q

);

    logic [N-1:0] w;

    // mux M_0(.M({1'b0 ,Q[1] ,Q[7] ,Q[1] ,LSBin ,Q[1] ,D[0] ,Q[0]}), .S(S), .Y(w[0]));
    // mux M_1(.M({Q[0] ,Q[2] ,Q[0] ,Q[2] ,Q[0] ,Q[2] ,D[1] ,Q[1]}),  .S(S), .Y(w[1]));
    // mux M_2(.M({Q[1] ,Q[3] ,Q[1] ,Q[3] ,Q[1] ,Q[3] ,D[2] ,Q[2]}),  .S(S), .Y(w[2]));
    // mux M_3(.M({Q[2] ,Q[4] ,Q[2] ,Q[4] ,Q[2] ,Q[4] ,D[3] ,Q[3]}),  .S(S), .Y(w[3]));
    // mux M_4(.M({Q[3] ,Q[5] ,Q[3] ,Q[5] ,Q[3] ,Q[5] ,D[4] ,Q[4]}),  .S(S), .Y(w[4]));
    // mux M_5(.M({Q[4] ,Q[6] ,Q[4] ,Q[6] ,Q[4] ,Q[6] ,D[5] ,Q[5]}),  .S(S), .Y(w[5]));
    // mux M_6(.M({Q[5] ,Q[7] ,Q[5] ,Q[7] ,Q[5] ,Q[7] ,D[6] ,Q[6]}),  .S(S), .Y(w[6]));
    // mux M_7(.M({Q[6] ,Q[7] ,Q[6] ,Q[0] ,Q[6] ,MSBin ,D[7] ,Q[7]}), .S(S), .Y(w[7]));

    for(genvar i=0; i<N; i++) begin
        if(i == 0) begin
           mux M_n(.M({1'b0 ,Q[1] ,Q[7] ,Q[1] ,LSBin ,Q[1] ,D[0] ,Q[0]}), .S(S), .Y(w[0])); 
        end
        else if(i == N-1) begin
            mux M_n(.M({Q[6] ,Q[7] ,Q[6] ,Q[0] ,Q[6] ,MSBin ,D[7] ,Q[7]}), .S(S), .Y(w[7]));
        end
        else 
            mux M_n(.M({Q[i-1] ,Q[i+1] ,Q[i-1] ,Q[i+1] ,Q[i-1] ,Q[i+1] ,D[i] ,Q[i]}),  .S(S), .Y(w[i]));
    end

    for(genvar i=0; i<N; i++) begin
        D_FF ff_n(.clk(clk), .clear(clear), .D(w[i]), .Q(Q[i]));
    end

    
endmodule