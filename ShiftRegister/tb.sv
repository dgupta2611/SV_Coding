typedef enum logic[2:0] {NOP, IILOAD, LSR, LSL, RR, RL, ASR, ASL} OP_t; 

module ShiftRegistertesting
#(parameter N = 8)
(output logic [N-1:0] Q,
input clk,
input clear,
input [N-1:0] D,
input [$clog2(N)-1:0] S,
input MSBin,
input LSBin);


	OP_t Sel;
	assign Sel = OP_t'(S);

	always @(posedge clk or negedge clear) begin
		if (!clear)
			Q <= '0;
		else
			case(Sel)
			NOP:  	  Q =  Q;
			IILOAD:   Q =  D;
			LSR:  	  Q = {MSBin,Q[7:1]};
			LSL:  	  Q = {Q[6:0],LSBin};
			RR:   	  Q = {Q[0],Q[7:1]};
			RL:       Q = {Q[6:0],Q[7]};
			ASR:      Q = {Q[7],Q[7:1]};
			ASL:      Q = {Q[6:0],'0};
			endcase
		end

endmodule : ShiftRegistertesting



//Shift register testbench
module top ();
    parameter N = 8;
    logic clk, clear; 
    logic [N-1:0] D, Expected_OP;
    logic MSBin, LSBin;
    logic [$clog2(N)-1:0] S;
    logic [N-1:0] Q;

	int i;

ShiftRegistertesting SR_Golden (Expected_OP, clk, clear, D, S, MSBin, LSBin);
SR                   SR_inst   (.*);

parameter CLOCK_CYCLE = 20;
parameter CLOCK_WIDTH = CLOCK_CYCLE/2;
bit ERROR = 0;

always@(posedge clk) begin
	if (Q !== Expected_OP) begin
		ERROR = 1;
		$display("%t Error: Exp_Out = %b Q = %b S = %b Clr = %b D  = %b MSBin = %b LSBin = %b", $time, Expected_OP, Q, S, clear, D, MSBin, LSBin);
	end
end


initial begin
	clk = '0;
	forever #CLOCK_WIDTH clk = ~clk;
	end

initial begin
	// clear activated 
	//$display("-------------Simulation Start-------------");
	//$display("-------------clear activated-------------");
    
    repeat(5) @(negedge clk);
	clear = 1'b0; S = 3'd0; D = 8'b0000_0000;  MSBin = 1'b0; LSBin = 1'b0;
	repeat(5) @(negedge clk);
	clear = 1'b0; S = 3'd1; D = 8'b0010_0100;  MSBin = 1'b0; LSBin = 1'b0;
	repeat(5) @(negedge clk);
	clear = 1'b0; S = 3'd2; D = 8'b1011_0100;  MSBin = 1'b1; LSBin = 1'b0;
	repeat(5) @(negedge clk);
	clear = 1'b0; S = 3'd3; D = 8'b1001_0101;  MSBin = 1'b0; LSBin = 1'b1;
	repeat(5) @(negedge clk);
	clear = 1'b0; S = 3'd1; D = 8'b0010_0100;  MSBin = 1'b0; LSBin = 1'b0;
	repeat(5) @(negedge clk);
	clear = 1'b0; S = 3'd4; D = 8'b1011_0100;  MSBin = 1'b0; LSBin = 1'b0;
	repeat(5) @(negedge clk);
	clear = 1'b0; S = 3'd1; D = 8'b0010_0100;  MSBin = 1'b0; LSBin = 1'b0;
	repeat(5) @(negedge clk);
	clear = 1'b0; S = 3'd5; D = 8'b1011_0101;  MSBin = 1'b0; LSBin = 1'b0;
	repeat(5) @(negedge clk);
	clear = 1'b0; S = 3'd1; D = 8'b0010_0100;  MSBin = 1'b0; LSBin = 1'b0;
	repeat(5) @(negedge clk);
	clear = 1'b0; S = 3'd6; D = 8'b1011_0100;  MSBin = 1'b0; LSBin = 1'b0;
	repeat(5) @(negedge clk);
	clear = 1'b0; S = 3'd1; D = 8'b0010_0100;  MSBin = 1'b0; LSBin = 1'b0;
	repeat(5) @(negedge clk);
	clear = 1'b0; S = 3'd7; D = 8'b1011_0101;  MSBin = 1'b0; LSBin = 1'b0;
	repeat(5) @(negedge clk);

	// clear deactivated
	//$display("-------------clear deactivated-------------");

	// Testing Parallel Loads and no change scenarios
	//$display("Testing Parallel Loads and no change scenarios");
	clear = 1'b1; S = 3'd0; D = 8'b0000_0000;  MSBin = 1'b0; LSBin = 1'b0;
	repeat(5) @(negedge clk);	
	clear = 1'b1; S = 3'd1; D = 8'b0010_0100;  MSBin = 1'b0; LSBin = 1'b0;
	repeat(5) @(negedge clk);
	clear = 1'b1; S = 3'd1; D = 8'b1110_0101;  MSBin = 1'b1; LSBin = 1'b0;
	repeat(5) @(negedge clk);
	clear = 1'b1; S = 3'd0; D = 8'b1010_1010;  MSBin = 1'b0; LSBin = 1'b0;
	repeat(5) @(negedge clk);
	clear = 1'b1; S = 3'd0; D = 8'b1111_1111;  MSBin = 1'b0; LSBin = 1'b1;
	repeat(5) @(negedge clk);
	clear = 1'b1; S = 3'd1; D = 8'b0000_0000;  MSBin = 1'b0; LSBin = 1'b0;
	repeat(5) @(negedge clk);


	// Testing logical shift right scenario
	//$display("Testing logical shift right scenarios");
	clear = 1'b1; S = 3'd2; D = 8'b0110_0001;  MSBin = 1'b1; LSBin = 1'b0;
	repeat(5) @(negedge clk);
	clear = 1'b1; S = 3'd2; D = 8'b0110_0001;  MSBin = 1'b0; LSBin = 1'b1;
	repeat(5) @(negedge clk);
	clear = 1'b1; S = 3'd2; D = 8'b0110_0001;  MSBin = 1'b1; LSBin = 1'b0;
	repeat(5) @(negedge clk);
	clear = 1'b1; S = 3'd2; D = 8'b0110_0001;  MSBin = 1'b0; LSBin = 1'b0;
	repeat(5) @(negedge clk);
	clear = 1'b1; S = 3'd2; D = 8'b0110_0001;  MSBin = 1'b1; LSBin = 1'b1;
	repeat(5) @(negedge clk);
	clear = 1'b1; S = 3'd2; D = 8'b0110_0001;  MSBin = 1'b0; LSBin = 1'b0;
	repeat(5) @(negedge clk);
	clear = 1'b1; S = 3'd2; D = 8'b0110_0001;  MSBin = 1'b1; LSBin = 1'b0;
	repeat(5) @(negedge clk);
	clear = 1'b1; S = 3'd2; D = 8'b0110_0001;  MSBin = 1'b0; LSBin = 1'b0;
	repeat(5) @(negedge clk);

	// Testing logical shift left scenario
	//$display("Testing logical shift left scenarios");
	clear = 1'b1; S = 3'd0; D = 8'b0000_0000;  MSBin = 1'b0; LSBin = 1'b0;
	repeat(5) @(negedge clk);
	clear = 1'b1; S = 3'd3; D = 8'b0110_0001;  MSBin = 1'b0; LSBin = 1'b1;
	repeat(5) @(negedge clk);
	clear = 1'b1; S = 3'd3; D = 8'b0110_0001;  MSBin = 1'b0; LSBin = 1'b0;
	repeat(5) @(negedge clk);
	clear = 1'b1; S = 3'd3; D = 8'b0110_0001;  MSBin = 1'b0; LSBin = 1'b1;
	repeat(5) @(negedge clk);
	clear = 1'b1; S = 3'd3; D = 8'b0110_0001;  MSBin = 1'b0; LSBin = 1'b0;
	repeat(5) @(negedge clk);
	clear = 1'b1; S = 3'd3; D = 8'b0110_0001;  MSBin = 1'b1; LSBin = 1'b1;
	repeat(5) @(negedge clk);
	clear = 1'b1; S = 3'd3; D = 8'b0110_0001;  MSBin = 1'b0; LSBin = 1'b0;
	repeat(5) @(negedge clk);
	clear = 1'b1; S = 3'd3; D = 8'b0110_0001;  MSBin = 1'b1; LSBin = 1'b0;
	repeat(5) @(negedge clk);
	clear = 1'b1; S = 3'd3; D = 8'b0110_0001;  MSBin = 1'b0; LSBin = 1'b1;
	repeat(5) @(negedge clk);

	// Testing Rotate Right scenario
	//$display("Testing Rotate Right scenario");
	clear = 1'b1; S = 3'd1; D = 8'b0110_1001;  MSBin = 1'b1; LSBin = 1'b0;
	repeat(5) @(negedge clk);
	clear = 1'b1; S = 3'd4; D = 8'b0001_1011;  MSBin = 1'b1; LSBin = 1'b0;
	repeat(20) @(negedge clk);

	// Testing Rotate Left scenario
	//$display("Testing Rotate Left scenario");
	clear = 1'b1; S = 3'd5; D = 8'b0001_1011;  MSBin = 1'b1; LSBin = 1'b0;
	repeat(20) @(negedge clk);

	// Testing Arithmetic Shift Right scenario
	//$display("Testing Arithmetic Shift Right scenario");
	clear = 1'b1; S = 3'd1; D = 8'b0110_1001;  MSBin = 1'b1; LSBin = 1'b0;
	repeat(5) @(negedge clk);
	clear = 1'b1; S = 3'd6; D = 8'b0001_1011;  MSBin = 1'b1; LSBin = 1'b0;
	repeat(5) @(negedge clk);
	clear = 1'b1; S = 3'd1; D = 8'b1011_0011;  MSBin = 1'b1; LSBin = 1'b0;
	repeat(5) @(negedge clk);
	clear = 1'b1; S = 3'd6; D = 8'b0001_1011;  MSBin = 1'b1; LSBin = 1'b0;
	repeat(5) @(negedge clk);

	// Testing Arithmetic Shift Left scenario
	//$display("Testing Arithmetic Shift Left scenario");
	clear = 1'b1; S = 3'd1; D = 8'b0010_1101;  MSBin = 1'b1; LSBin = 1'b0;
	repeat(5) @(negedge clk);
	clear = 1'b1; S = 3'd7; D = 8'b0001_1011;  MSBin = 1'b1; LSBin = 1'b0;
	repeat(5) @(negedge clk);
	clear = 1'b1; S = 3'd1; D = 8'b1110_1001;  MSBin = 1'b1; LSBin = 1'b0;
	repeat(5) @(negedge clk);
	clear = 1'b1; S = 3'd7; D = 8'b0001_1011;  MSBin = 1'b1; LSBin = 1'b0;
	repeat(5) @(negedge clk);

	// Testing for Random values
	//$display("Testing for Random values");
	clear = 1'b1; S = $random; D = $random;  MSBin = $random; LSBin = $random;
	repeat(5) @(negedge clk);
	clear = 1'b0; S = $random; D = $random;  MSBin = $random; LSBin = $random;
	repeat(5) @(negedge clk);
	
	if(ERROR === 0)
	     $display("-----------------------NO ERROR------------------------");
   	  $stop;
end

//initial $monitor ($time, "   Output Q = %b S = %b clear = %b D  = %b MSBin = %b LSBin = %b", Q, S, clear, D, MSBin, LSBin);
    

endmodule : top
