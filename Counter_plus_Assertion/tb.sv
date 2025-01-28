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
        $display("reset \t load \t inc \t dec \t din \t count \t",reset, load, inc, dec, din, count);
        $monitor("%0d \t %0d \t %0d \t %0d \t %0d \t %0d",reset, load, inc, dec, din, count);

                        {reset, load, inc, dec} = 4'b1000; 
        @(negedge clk); {reset, load, inc, dec} = 4'b0100; din = 8'hFF;
        @(negedge clk); {reset, load, inc, dec} = 4'b0100; din = 'X;
        
        $stop;

    end
    
endmodule