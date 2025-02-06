`define DELAY(n) repeat(n) @(negedge clk)
`define RAND_VAL $urandom_range(0, 2**DATAWIDTH)
`define RAND_ADDR $urandom_range(0, 2**ADDRWIDTH)

module tb;
    parameter DATAWIDTH = 8; 
    parameter  ADDRWIDTH = 3;
    parameter  rst_mode = 0;
    parameter  CLOCK_CYCLE = 20;
	parameter  CLOCK_WIDTH = CLOCK_CYCLE/2;

    input clk, rst_n;
    input en_w1_n, en_w2_n;
    input [ADDRWIDTH-1:0] addr_w1;
    input [ADDRWIDTH-1:0] addr_w2;
    input [DATAWIDTH-1:0] data_w1;
    input [DATAWIDTH-1:0] data_w2;

    input en_r1_n, en_r2_n;
    input [ADDRWIDTH-1:0] addr_r1;
    input [ADDRWIDTH-1:0] addr_r2;
    output logic [DATAWIDTH-1:0] data_r1_sync, data_r1_async;
    output logic [DATAWIDTH-1:0] data_r2_sync, data_r2_async;

    logic [DATAWIDTH-1:0] ref_mem [logic[ADDRWIDTH-1:0]]; //associative array reference memory
    logic [DATAWIDTH-1:0] rd_data_1_sync, rd_data_2_sync;
	logic [DATAWIDTH-1:0] rd_data_1_asyn, rd_data_2_asyn;
	int i; 
	bit error_sync, error_asyn;

    ram #(.rst_mode(0)) ASYNC_WR_INST(.data_r1(data_r1_async), .data_r2(data_r2_async), .*);
    ram #(.rst_mode(1)) SYNC_WR_INST (.data_r1(data_r1_sync), .data_r2(data_r2_sync), .*);

    always begin
        clk = 0;
        forever #CLOCK_WIDTH clk = ~clk;
    end

    task wr_mem_1(input [ADDRWIDTH-1:0] addr, input [DATAWIDTH-1:0] data);
        `DELAY(1);
        en_w1_n = 0;
        en_w2_n = 1;
        addr_w1 = addr;
        data_w1 = data;
        ref_mem[addr_w1] = data_w1;
        `DELAY(1);
        en_w1_n = 1;
        `DELAY(1);        
    endtask 

    task wr_mem_2(input [ADDRWIDTH-1:0] addr, input [DATAWIDTH-1:0] data);
        `DELAY(1);
        en_w1_n = 1;
        en_w2_n = 0;
        addr_w2 = addr;
        data_w2 = data;
        ref_mem[addr_w2] = data_w2;
        `DELAY(1);
        en_w2_n = 1;
        `DELAY(1);        
    endtask 

    task wr_mem_1_2(input [ADDRWIDTH-1:0] addr1, addr2, input [DATAWIDTH-1:0] data1, data2);
        `DELAY(1);
        en_w1_n = 1;
        en_w2_n = 1;
        addr_w1 = addr1;
        data_w1 = data1;
        addr_w2 = addr2;
        data_w2 = data2;

        if(add1 === addr2)
            ref_mem[addr_w1] = data_w1;
        else
            ref_mem[addr_w1] = data_w1;
            ref_mem[addr_w2] = data_w2;

        `DELAY(1);
        en_w1_n = 1;
        en_w2_n = 1;
        `DELAY(1);        
    endtask

    task Selfchecking();
        
        
    endtask 


endmodule