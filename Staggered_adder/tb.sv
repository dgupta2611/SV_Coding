module tb;

    parameter N = 16; 
    logic Clock;
    logic [N-1:0] A, B;
    logic CI;
    logic [N-1:0] S;
    logic CO;

    StaggeredAdd SA_Inst(Clock, A, B, CI, S, CO);

    logic Error = 0;

    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

    initial begin
        for(int Ain = 0; Ain < 16; Ain++)
            for(int Bin = 0; Bin < 16; Bin++)
                for(int Cin = 0; Cin < 2; Cin++) begin
                    A = Ain; B = Bin; CI = Cin;                   
                    #1000;
                    if(({CO,S}) !== (Ain+Bin+Cin)) begin
                        Error = 1;
                        $display(" ERROR \t A = %0d B = %0d CI = %0d S = %0d C0 = %0d", A, B, CI, S, CO);
                    end
                end
        if(Error == 0) begin
            $display("No ERROR FOUND");
        end
    end


	// initial begin
	// A = 16'd0; B = 16'd0; CI = 1'b0;
	// #10
	// A = 16'd7; B = 16'd9; CI = 1'b1;
	// #20
	// $stop;
	// end

	//initial $monitor (  $time, "    A=%d B=%d CI=%b S=%d CO=%b", A, B, CI, S, CO);
    
endmodule