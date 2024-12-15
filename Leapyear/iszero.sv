module iszero 
    (
        input [3:0] a,
        output logic out
    );

    assign out = ~(|a);
    
endmodule