module AP_detector (
    input [7:0] A, B, C, D, E, F, G, 
    output logic is_ap
    );

    logic [7:0] Dab, Dbc, Dcd, Dde, Def, Dfg;
    logic Bab, Bbc, Bcd, Bde, Bef, Bfg;
   
    logic [7:0] diff;
    logic borrow;

    subtractor_8bit AP0(B, A, 1'b0, Dab, Bab);
    subtractor_8bit AP1(C, B, 1'b0, Dbc, Bbc);
    subtractor_8bit AP2(D, C, 1'b0, Dcd, Bcd);
    subtractor_8bit AP3(E, D, 1'b0, Dde, Bde);
    subtractor_8bit AP4(F, E, 1'b0, Def, Bef);
    subtractor_8bit AP5(G, F, 1'b0, Dfg, Bfg);

    // assign diff = (Dab === Dbc === Dcd === Dde === Def === Dfg) ? '1 : '0;
    // assign borrow = (Bab === Bbc === Bcd === Bde === Bef === Bfg) ? '1 : '0;

    assign diff = &((Dab ^~ Dbc) &
                    (Dbc ^~ Dcd) &
                    (Dcd ^~ Dde) &
                    (Dde ^~ Def) &
                    (Def ^~ Dfg));

    assign borrow = &((Bab ^~ Bbc) &
                      (Bbc ^~ Bcd) &
                      (Bcd ^~ Bde) &
                      (Bde ^~ Bef) &
                      (Bef ^~ Bfg));


    assign is_ap = diff & borrow;
   
endmodule

module subtractor_1bit(
    input A, B, Bin,
    output logic D, BW
    );

    assign D = A ^ B ^ Bin;

    assign BW = (~A & (B | Bin)) | (B & Bin);

endmodule


module subtractor_8bit(
    input [7:0] A, B, 
    input Bin,
    output logic [7:0] D, 
    output logic BW
    );

    logic [8:0] CI;

    assign CI[0] = Bin;
    assign BW = CI[8];

    generate
        for(genvar i = 0; i < 8; i++) begin
           subtractor_1bit sub_n(A[i], B[i], CI[i], D[i], CI[i+1]); 
        end
    endgenerate
    
endmodule