module tb;

    parameter ADDRWIDTH = 6;
    parameter DATAWIDTH = 8;
    bit clock;
    logic reset;
    logic ld_high, ld_low;
    logic [ADDRWIDTH-1:0] addr;
    logic [DATAWIDTH-1:0] din;
    logic write;
    logic zero;
    logic [DATAWIDTH-1:0] dout;
    logic busy;

    mz #(ADDRWIDTH, DATAWIDTH) T(clock, reset, ld_high, ld_low, addr, din, write, zero,
                                 dout, busy);

    bit ERR = 0;
    logic [DATAWIDTH-1:0] d;

    logic [ADDRWIDTH-1:0] randomaddr1 = 15;
    logic [ADDRWIDTH-1:0] randomaddr2 = (1 << ADDRWIDTH-1) - 1; //31

    initial begin
        clock = '1;
        forever #10 clock = ~clock;
    end

    // write data in normal mode
    task Writedata(input [ADDRWIDTH-1:0] a, input [DATAWIDTH-1:0] d);
        begin
            @(negedge clock);
            wait(!busy);
            ld_high = '0;
            ld_low = '0;
            addr = a;
            din = d;
            zero = '0;
            write = '1;

            repeat(2) @(negedge clock);
            write = '0;
        end
        
    endtask 

    // read data in normal mode
    task Readdata(input [ADDRWIDTH-1:0] a, output [DATAWIDTH-1:0] d);
    begin
        ld_high = '0;
        ld_low = '0;
        din = 'x;
        zero = '0;
        write = '0;
        addr = a;

        @(negedge clock);
        d = dout;
    end
        
    endtask 

    task NOP;
    begin
        @(negedge clock);
        wait(!busy);
    end
    endtask 

    //write zeros in zero mode in memory
    task WriteZero(input [ADDRWIDTH-1:0] low, input [ADDRWIDTH-1:0] high);
    begin
        @(negedge clock);
        wait(!busy);
        zero = '0;
        write = '0;
        addr = low;
        #10;
        ld_low = '1;
        #10;
        ld_low = '0;
        #10;
        addr = high;
        #10;
        ld_high = '1;
        #10;
        ld_high = '0;
        addr = 'x;
        din = 'x;
        #10;
        zero = '1;
       
        @(posedge clock);
        @(negedge clock);
        zero = '0;
        @(posedge clock);
        wait(!busy);       
    end        
    endtask

    /*
    * Use hierarchical instance name of memory array to directly verify memory contents
    * All addresses outside the range should contain data equal to the memory address
    * If zero is 1, then all memory at addresses inside the range should be zero.
    * Otherwise, they should also be the same as the address.  Report any errors and
    * set Errors flag.
    *
    */
    task VerifyMemory(input [ADDRWIDTH-1:0] low, [ADDRWIDTH-1:0] high, input bit zero);    
        for(int i = 0; i<(1<<(ADDRWIDTH)); i++) begin
            if(((low>high) /*wraparound*/ && ((i>=low) || (i<=high)))  || ((low<=high) && ((i>=low) && (i<=high))))
            begin
                if(T.dp_Inst.mem_Inst.mem[i] !== (zero ? '0 : i)) begin
                    $display("VMem[%0h] = %0h is not equal to %0h", i, T.dp_Inst.mem_Inst.mem[i], (zero ? '0 : i));
                    ERR = '1;
                end
            end

            else begin
                if(T.dp_Inst.mem_Inst.mem[i] !== i) begin
                $display("VMem[%0h] = %0h is not equal to %0h", i, T.dp_Inst.mem_Inst.mem[i], (zero ? '0 : i));
                ERR = '1;
                end
            end
        end        
    endtask

    /*
    * Use normal mode reads verify memory contents
    * All addresses outside the range should contain data equal to the memory address
    * If zero is 1, then all memory at addresses inside the range should be zero.
    * Otherwise, they should also be the same as the address.  Report any errors and
    * set Errors flag.
    *
    */
    task VerifyReadMemory(input [ADDRWIDTH-1:0] low, [ADDRWIDTH-1:0] high, input bit zero);
    logic [DATAWIDTH-1:0] d;
    
        for(int i = 0; i<(1<<(ADDRWIDTH)); i++) begin
            Readdata(i,d);
            if(((low>high) /*wraparound*/ && ((i>=low) || (i<=high)))  || ((low<=high) && ((i>=low) && (i<=high))))
            begin
                if(d !== (zero ? '0 : i)) begin
                    $display("RMem[%0h] = %0h is not equal to %0h", i, d, (zero ? '0 : i));
                    ERR = '1;
                end
            end

            else begin
                if(d !== i) begin
                $display("RMem[%0h] = %0h is not equal to %0h", i, d, (zero ? '0 : i));
                ERR = '1;
                end
            end
        end        
    endtask

    task DumpMem;
    for(int i = 0; i<(1<<(ADDRWIDTH)); i++)
        begin
           $display("DMem[%0d] = %0d", i, T.dp_Inst.mem_Inst.mem[i]); 
        end        
    endtask


    initial begin
        $dumpfile("dump.vcd"); $dumpvars;
        $display("********TB Begins********");
        reset = '1;
        repeat(2) @(negedge clock);
        reset = '0;

        //1. Use "normal" interface to write a pattern to each memory location and confirm
        $display("checking for initalization of memory to known values in normal mode");
        for (int i = 0; i < (1 << (ADDRWIDTH)); i++)
        	Writedata(i[ADDRWIDTH-1:0],i[DATAWIDTH-1:0]);
            NOP; 
            VerifyReadMemory('0,(1 << ADDRWIDTH)-1,'0);
            VerifyMemory('0,(1 << ADDRWIDTH)-1,'0);
            //DumpMem;

            
        //2. Use "zero" mode to zero a single arbitrary row R1 = R2, confirm others unchanged
        $display("checking for zero of range (%d,%d)",randomaddr1,randomaddr1);
        WriteZero(randomaddr1,randomaddr1);
        NOP; 
        //DumpMem;
        VerifyMemory(randomaddr1,randomaddr1,'1);
        

        $display("checking for restoration of single value range (normal mode)");
        Writedata(randomaddr1,randomaddr1);
        NOP; 
        //DumpMem;
        VerifyMemory(randomaddr1,randomaddr1,'0);
       

        //3. Use "zero" mode for range with R2 > R1, confirm others unchanged
        $display("checking for zero of  range (%d,%d)",randomaddr2,randomaddr1);
        WriteZero(randomaddr2,randomaddr1);
        NOP;
        //DumpMem; 
        VerifyMemory(randomaddr2,randomaddr1,'1);

        $display("checking for restoration of constraint range (normal mode)");
        for (int i = 0; i <= randomaddr1; i++) begin
        	Writedata(i[ADDRWIDTH-1:0],i);
            NOP;
        end 
        for (int i = randomaddr2; i <= (1 << ADDRWIDTH)-1; i++) begin
        	Writedata(i[ADDRWIDTH-1:0],i);
            NOP;
        end
        //DumpMem; 
        VerifyMemory('0,(1 << ADDRWIDTH)-1,'0);



        //4. Use "zero" mode for range with R2 < R1, confirm others unchanged
        $display("checking for zero of  range (%d,%d)",randomaddr1,randomaddr2);
        WriteZero(randomaddr1,randomaddr2);
        NOP;
        //DumpMem; 
        VerifyMemory(randomaddr1,randomaddr2,'1); 

        $display("checking for restoration of constraint range (normal mode)");
        for (int i = randomaddr1; i <= randomaddr2; i++) begin
        	Writedata(i[ADDRWIDTH-1:0],i);
            NOP;
        end 
        //DumpMem; 
        VerifyMemory('0,(1 << ADDRWIDTH)-1,'0);

        //5. check for all zeros for the entire memory
        for(int i = 0; i <= (1<<ADDRWIDTH)-1; i++) begin
            WriteZero(0, (1<<ADDRWIDTH)-1);
            NOP;
            VerifyMemory('0,(1 << ADDRWIDTH)-1,'1);
        end

        if (ERR)
	    $display("\n\n\n*** FAILED ***\n\n\n");
        else
	    $display("\n\n\n*** PASSED ***\n\n\n");
    
        $stop();

    end
   

endmodule