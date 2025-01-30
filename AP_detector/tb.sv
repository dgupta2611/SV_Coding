module tb;
    logic [7:0] A, B, C, D, E, F, G; 
    logic is_ap;

    AP_detector AP(A, B, C, D, E, F, G, is_ap);

    bit ERR = 0;
    logic ap_goldenmodel;
    int d;

    initial begin
        $display("Testbench Begins");
        //$display("A \t B \t C \t D \t E \t F \t G \t is_ap", A, B, C, D, E, F, G, is_ap);
        //$monitor("%0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d", A, B, C, D, E, F, G, is_ap);

        //check if the code is working with direct inputs
        A = 8'd1; B = 8'd2; C = 8'd3; D = 8'd4; E = 8'd5; F = 8'd6; G = 8'd7;
        #10
        A = 8'd5; B = 8'd10; C = 8'd15; D = 8'd20; E = 8'd25; F = 8'd30; G = 8'd35;
        #10
        A = 8'd0; B = 8'd5; C = 8'd7; D = 8'd8; E = 8'd10; F = 8'd13; G = 8'd3;
        #10
        A = 8'd1;
        #10
        A = 8'd1; B = 8'd6; 
        #10
        A = 8'd2; B = 8'd4; C = 8'd8; D = 8'd16; E = 8'd32; F = 8'd64; G = 8'd128;
        #10
        A = 8'd17; B = 8'd5; C = 8'd4; D = 8'd11; E = 8'd17; F = 8'd6; G = 8'd7;


        //check with random input to all the inputs
        repeat(100) begin
            A = $random;
            B = $random;
            C = $random;
            D = $random;
            E = $random;
            F = $random;
            G = $random;
            d = B - A;
            ap_goldenmodel = (B == A+d) && (C == A+2*d) && (D == A+3*d) && (E == A+4*d) && (F == A+5*d) && (G == A+6*d);
            #1
            if (is_ap !== ap_goldenmodel) begin
                $display("ERROR: %0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d", A, B, C, D, E, F, G, is_ap);
                ERR = 1;
            end
        end

        //check with same input 
        repeat(100) begin
            A = $random;
            B = A;
            C = A;
            D = A;
            E = A;
            F = A;
            G = A;
            d = B - A;
            ap_goldenmodel = (B == A+d) && (C == A+2*d) && (D == A+3*d) && (E == A+4*d) && (F == A+5*d) && (G == A+6*d);
            #1
            if (is_ap !== ap_goldenmodel) begin
                $display("ERROR: %0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d", A, B, C, D, E, F, G, is_ap);
                ERR = 1;
            end
        end

        //check with random input in range 0 to 10 
        repeat(10) begin
            A = $urandom_range(10,30); 
		    d = $urandom_range(0,40);
            B = A+d;
            C = A+2*d;
            D = A+3*d;
            E = A+4*d;
            F = A+5*d;
            G = A+6*d;
            //d = B - A;
            //ap_goldenmodel = (B == A+d) && (C == A+2*d) && (D == A+3*d) && (E == A+4*d) && (F == A+5*d) && (G == A+6*d);
            #1
            if (is_ap != 1'b1) begin
                $display("ERROR: %0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d \t", A, B, C, D, E, F, G, is_ap, d);
                ERR = 1;
            end
        end

        //check with random input in range 50 to 200 with negative difference
        repeat(10) begin
            A = $urandom_range(200,255); 
		    d = $urandom_range(0,10);
            B = A-d;
            C = A-2*d;
            D = A-3*d;
            E = A-4*d;
            F = A-5*d;
            G = A-6*d;
            //d = B - A;
            //ap_goldenmodel = (B == A+d) && (C == A+2*d) && (D == A+3*d) && (E == A+4*d) && (F == A+5*d) && (G == A+6*d);
            #1
            if (is_ap !== 1'b1) begin
                $display("ERROR: %0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d", A, B, C, D, E, F, G, is_ap);
                ERR = 1;
            end
        end

        //check with random input in range 50 to 200 with positive difference
        repeat(100) begin
            A = $urandom_range(10, 30);
            d = $urandom_range(0, 10);
            B = A+d;
            C = A+2*d;
            D = A+3*d;
            E = A+4*d;
            F = A+5*d;
            G = A+6*d;
            //d = B - A;
            //ap_goldenmodel = (B == A+d) && (C == A+2*d) && (D == A+3*d) && (E == A+4*d) && (F == A+5*d) && (G == A+6*d);
            #1
            if (is_ap !== 1'b1) begin
                $display("ERROR: %0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d", A, B, C, D, E, F, G, is_ap);
                ERR = 1;
            end
        end

        if (ERR === 0)
		$display ("No Error : is_ap is VALID");

        $stop; 
    end

    
endmodule