`define DELAY(n) repeat(n) @(negedge clk)


module tb;
    parameters DATAWIDTH = 8; 
    parameter  ADDRWIDTH = 3;
    parameter  rst_mode = 0;

    logic clk, rst_n;
    logic en_w1_n, en_w2_n;
    logic [ADDRWIDTH-1:0] addr_w1;
    logic [ADDRWIDTH-1:0] addr_w2;
    logic [DATAWIDTH-1:0] data_w1;
    logic [DATAWIDTH-1:0] data_w2;

    logic en_r1_n, en_r2_n;
    logic [ADDRWIDTH-1:0] addr_r1;
    logic [ADDRWIDTH-1:0] addr_r2;
    logic [DATAWIDTH-1:0] data_r1;
    logic [DATAWIDTH-1:0] data_r2;

    ram RAM_MEM(.*);

    always begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial begin
            
    end


    
    endmodule