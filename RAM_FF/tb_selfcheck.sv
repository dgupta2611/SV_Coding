`define DELAY(n) repeat(n) @(negedge clk)
`define RAND_VAL $urandom_range(0, 2**DATAWIDTH)
`define RAND_ADDR $urandom_range(0, 2**ADDRWIDTH)

module tb;
    parameter DATAWIDTH = 8; 
    parameter  ADDRWIDTH = 3;
    parameter  rst_mode = 0;
    parameter  CLOCK_CYCLE = 20;
	parameter  CLOCK_WIDTH = CLOCK_CYCLE/2;

    logic clk, rst_n;
    logic en_w1_n, en_w2_n;
    logic [ADDRWIDTH-1:0] addr_w1;
    logic [ADDRWIDTH-1:0] addr_w2;
    logic [DATAWIDTH-1:0] data_w1;
    logic [DATAWIDTH-1:0] data_w2;

    logic en_r1_n, en_r2_n;
    logic [ADDRWIDTH-1:0] addr_r1;
    logic [ADDRWIDTH-1:0] addr_r2;
    logic [DATAWIDTH-1:0] data_r1_sync, data_r1_async;
    logic [DATAWIDTH-1:0] data_r2_sync, data_r2_async;

    logic [DATAWIDTH-1:0] ref_mem [logic[ADDRWIDTH-1:0]]; //associative array reference memory

	bit error_sync = 0;
    bit error_async = 0;

    logic [ADDRWIDTH-1:0] addr_temp;
    logic [DATAWIDTH-1:0] data_temp;


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
        en_w1_n = 0;
        en_w2_n = 0;
        addr_w1 = addr1;
        data_w1 = data1;
        addr_w2 = addr2;
        data_w2 = data2;

        if(addr1 === addr2)
            ref_mem[addr1] = data1;
        else begin
            ref_mem[addr1] = data1;
            ref_mem[addr2] = data2;
        end
        `DELAY(1);
        en_w1_n = 1;
        en_w2_n = 1;
        `DELAY(1);        
    endtask

    task Selfchecking(input [ADDRWIDTH-1:0] addr, 
                      input [DATAWIDTH-1:0] data_async, 
                      input [DATAWIDTH-1:0] data_sync);

        if(ref_mem.exists(addr)) begin
            if(ref_mem[addr] !== data_async) begin
                error_async = 1;
                $display("Mismatch in read-out for ADDR = %0d of Async mem with ref_mem_data = %0h and data_async = %0h", 
                addr, ref_mem[addr], data_async);
            end
            if(ref_mem[addr] !== data_sync) begin
                error_sync = 1;
                $display("Mismatch in read-out for ADDR = %0d of Sync mem with ref_mem_data = %0h and data_sync = %0h",
                addr, ref_mem[addr], data_sync);
            end
        end
        else begin
            if(data_async !== 'd0) begin
                error_async = 1;
                $display("ADDR = %0d of Async mem is not 0", addr);
            end
            if(data_sync !== 'd0) begin
                error_sync = 1;
                $display("ADDR = %0d of Sync mem is not 0", addr);
            end
        end        
    endtask 

    ram #(.rst_mode(0)) ASYNC_WR_INST(.data_r1(data_r1_async), .data_r2(data_r2_async), .*);
    ram #(.rst_mode(1)) SYNC_WR_INST (.data_r1(data_r1_sync), .data_r2(data_r2_sync), .*);

    task print();
        for(int i = 0; i < 2**ADDRWIDTH; i++) begin
            en_r1_n = 0;
            en_r2_n = 0;

            addr_r1 = ADDRWIDTH'(i); addr_r2 = ADDRWIDTH'(i);
            #1;

            if(data_r1_async != 'd0)
                $display("addr_r1 = %d \t data_r1 = %h", addr_r1, data_r1_async);
            if(data_r2_async != 'd0)
                $display("addr_r2 = %d \t data_r2 = %h", addr_r2, data_r2_async);
            if(data_r1_sync != 'd0)
                $display("addr_r1 = %d \t data_r1 = %h", addr_r1, data_r1_sync);
            if(data_r2_sync != 'd0)
                $display("addr_r2 = %d \t data_r2 = %h", addr_r2, data_r2_sync);
             
            en_r1_n = 1;
            en_r2_n = 1;
            #1;
        end

    endtask


    initial begin
        $display("**********Testbench Start***********");

        rst_n = 0; `DELAY(1);
        rst_n = 1; `DELAY(2);
        rst_n = 0; `DELAY(3);

        //writing mem with random addr and values
        wr_mem_1(`RAND_ADDR, `RAND_VAL);
       
        wr_mem_2(`RAND_ADDR, `RAND_VAL);
       

        addr_temp = `RAND_ADDR;

        //writing mem through both ports with different addresses
        wr_mem_1_2(addr_temp, addr_temp+1, `RAND_VAL, `RAND_VAL);
        

        addr_temp = `RAND_ADDR;
        //writing mem through both ports with same addresses
        wr_mem_1_2(addr_temp, addr_temp, `RAND_VAL, `RAND_VAL);
        
        print();

//*********************************** Self Checking **************************************
        //write through port 1
        for(int i = 0; i < 2**ADDRWIDTH; i++) begin
            wr_mem_1(ADDRWIDTH'(i), `RAND_VAL);
        end

        error_async = 0;
        error_sync  = 0;
        for(int i = 0; i < 2**ADDRWIDTH; i++) begin
            en_r1_n = 0;
            addr_r1 = ADDRWIDTH'(i);
            #1;
            Selfchecking(addr_r1, data_r1_async, data_r1_sync);
            en_r1_n = 1;
            #1;
        end

        if (!error_async && !error_sync) 
			$display("Both memory verified against ref_mem through Port 1 read-out");

        //write through port 2
        for(int i = 0; i < 2**ADDRWIDTH; i++) begin
            wr_mem_2(ADDRWIDTH'(i), `RAND_VAL);
        end

        error_async = 0;
        error_sync  = 0;
        for(int i = 0; i < 2**ADDRWIDTH; i++) begin
            en_r2_n = 0;
            addr_r2 = ADDRWIDTH'(i);
            #1;
            Selfchecking(addr_r2, data_r2_async, data_r2_sync);
            en_r2_n = 1;
            #1;
        end

        if (!error_async && !error_sync) 
			$display("Both memory verified against ref_mem through Port 2 read-out");


        //write through port 1 and port 2 with same address
        for(int i = 0; i < 2**ADDRWIDTH; i++) begin
            wr_mem_1_2(ADDRWIDTH'(i), ADDRWIDTH'(i), `RAND_VAL, `RAND_VAL);
        end

        error_async = 0;
        error_sync  = 0;
        for(int i = 0; i < 2**ADDRWIDTH; i++) begin
            en_r1_n = 0;
            en_r2_n = 0;
            addr_r1 = ADDRWIDTH'(i);
            addr_r2 = ADDRWIDTH'(i);
            #1;
            Selfchecking(addr_r1, data_r1_async, data_r1_sync);
            Selfchecking(addr_r2, data_r2_async, data_r2_sync);
            en_r1_n = 1;
            en_r2_n = 1;
            #1;
        end

        if (!error_async && !error_sync) 
			$display("Both memory verified against ref_mem through Port 1 and 2 read-out after wrting to through both ports at same addr");

        //write through port 1 and port 2 with different address
        for(int i = 0; i < 2**ADDRWIDTH; i++) begin
            wr_mem_1_2(ADDRWIDTH'(i), ADDRWIDTH'((2**ADDRWIDTH)-1-i), `RAND_VAL, `RAND_VAL);
        end

        error_async = 0;
        error_sync  = 0;
        for(int i = 0; i < 2**ADDRWIDTH; i++) begin
            en_r1_n = 0;
            en_r2_n = 0;
            addr_r1 = ADDRWIDTH'(i);
            addr_r2 = ADDRWIDTH'(i);
            #1;
            Selfchecking(addr_r1, data_r1_async, data_r1_sync);
            Selfchecking(addr_r2, data_r2_async, data_r2_sync);
            en_r1_n = 1;
            en_r2_n = 1;
            #1;
        end

        if (!error_async && !error_sync) 
			$display("Both memory verified against ref_mem through Port 1 and 2 read-out after wrting to through both ports at different addr");

        //`DELAY(5)
        $stop();

    end


endmodule