module divby4 
    (
        input [3:0] a, b,
        output logic out
    );

    always_comb begin 
        if((a&1) && (b =='d2 || b == 'd6)) begin
            out = 'd1;           
        end
        else if ((a|1) && (b == 'd0 || b == 'd4 || b == 'd8)) begin
            out = 'd1;
        end
        else out = 'd0;
        
    end

endmodule