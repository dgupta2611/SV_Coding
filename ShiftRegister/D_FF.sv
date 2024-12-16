module D_FF 
#(
    parameter N = 1
) 
(
    input clk, clear,
    input [N-1:0] D,
    output logic [N-1:0] Q
);

    always_ff @(posedge clk or negedge clear) begin 
        if(!clear)
            Q <= '0;
        else 
            Q <= D;       
    end
    
endmodule