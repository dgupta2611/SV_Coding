module tb;

    parameter N = 8;
    logic clk, reset, load, inc, dec;
    logic [N-1:0] din;
    logic [N-1:0] count;

    Counter C_Inst(.*);
    bind Counter counterassertions CA(clk, reset, load, inc, dec, din, count, saturated, zeroed);

    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial begin
        $display("Testbench Begins");
        $display("time \t reset \t load \t inc \t dec \t din \t count \t",$time, reset, load, inc, dec, din, count);
        $monitor("time = %0t \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d",$time, reset, load, inc, dec, din, count);

                        {reset, load, inc, dec} = 4'b1000; din = '0; //check reset

        @(negedge clk); {reset, load, inc, dec} = 4'b0100; din = 8'hFF; //check load and reset
        @(negedge clk); {reset, load, inc, dec} = 4'b1000; din = 'X;

        @(negedge clk); {reset, load, inc, dec} = 4'b0100; din = 8'hF; //check load and unkonown din
        @(negedge clk); {reset, load, inc, dec} = 4'b0100; din = 'z;
        @(negedge clk); {reset, load, inc, dec} = 4'b0100; din = 'X;

        @(negedge clk); {reset, load, inc, dec} = 4'b0100; din = 8'h0; //check load and inc
        @(negedge clk); {reset, load, inc, dec} = 4'b0010; din = 8'hX;

        @(negedge clk); {reset, load, inc, dec} = 4'b0100; din = 8'hFF; //check load and dec
        @(negedge clk); {reset, load, inc, dec} = 4'b0001; din = 8'hX;

        @(negedge clk); {reset, load, inc, dec} = 4'b0100; din = 8'hA;//check load, inc and dec
        @(negedge clk); {reset, load, inc, dec} = 4'b0011; din = 8'hX;

        @(negedge clk)  {reset, load, inc, dec} = 4'b0100; din = 8'hFE;   // check for + sat
        @(negedge clk)  {reset, load, inc, dec} = 4'b0010; din = 'X;	 // should ++
        @(negedge clk)  {reset, load, inc, dec} = 4'b0010; din = 'X;	// should saturate at FF
         
        @(negedge clk)  {reset, load, inc, dec} = 4'b0100; din = 8'h01;   // check for - sat
        @(negedge clk)  {reset, load, inc, dec} = 4'b0001; din = 'X;	 // should --
        @(negedge clk)  {reset, load, inc, dec} = 4'b0001;				// should saturate at 0
        @(negedge clk);  
        @(negedge clk);  
        
        $stop;

    end
    
endmodule