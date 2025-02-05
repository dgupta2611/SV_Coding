`define DELAY(n) repeat(n) @(negedge clk)
`define BYTE_SZ 8
`define MAX_STRING_SZ 8
typedef logic [`BYTE_SZ*`MAX_STRING_SZ-1:0] CHAR;

module tb;
    
    parameter  width_mem0 = `MAX_STRING_SZ * `BYTE_SZ;
    parameter  width_mem1 = `BYTE_SZ;
    parameter  ADDRWIDTH = 3;
    parameter  rst_mode = 0;
    parameter  CLOCK_CYCLE = 20;
	parameter  CLOCK_WIDTH = CLOCK_CYCLE/2;

    logic clk, rst_n;
    logic en_w1_mem0, en_w2_mem0;
 	logic en_w1_mem1, en_w2_mem1;

    logic [ADDRWIDTH-1:0] addr_w1_mem0, addr_w1_mem1;
    logic [ADDRWIDTH-1:0] addr_w2_mem0, addr_w2_mem1;
    logic [width_mem0-1:0] data_w1_mem0, data_w2_mem0;
 	logic [width_mem1-1:0] data_w1_mem1, data_w2_mem1;

    logic en_r1_mem0,en_r1_mem1; 
    logic en_r2_mem0,en_r2_mem1;
    logic [ADDRWIDTH-1:0] addr_r1_mem0, addr_r1_mem1;
    logic [ADDRWIDTH-1:0] addr_r2_mem0, addr_r2_mem1;
    logic [width_mem0-1:0] data_r1_mem0, data_r2_mem0;
	logic [width_mem1-1:0] data_r1_mem1, data_r2_mem1 ;

    string mem0_dyn[];
    byte mem1_dyn[];

    byte asso[string]; 

    ram #(.DATAWIDTH(width_mem0), .ADDRWIDTH(ADDRWIDTH), .rst_mode(0)) mem0
									(.clk(clk), .rst_n(rst_n),  .en_w1_n(en_w1_mem0),    .en_w2_n(en_w2_mem0),   .addr_w1(addr_w1_mem0),
                                    .addr_w2(addr_w2_mem0),     .data_w1(data_w1_mem0),  .data_w2(data_w2_mem0),
				   					.en_r1_n(en_r1_mem0),       .en_r2_n(en_r2_mem0),    .addr_r1(addr_r1_mem0), .addr_r2(addr_r2_mem0),
                                    .data_r1(data_r1_mem0),     .data_r2(data_r2_mem0));

    ram #(.DATAWIDTH(width_mem1), .ADDRWIDTH(ADDRWIDTH), .rst_mode(0)) mem1
									(.clk(clk), .rst_n(rst_n), .en_w1_n(en_w1_mem1), .en_w2_n(en_w2_mem1), .addr_w1(addr_w1_mem1),
                                    .addr_w2(addr_w2_mem1), .data_w1(data_w1_mem1), .data_w2(data_w2_mem1),
				   					.en_r1_n(en_r1_mem1), .en_r2_n(en_r2_mem1), .addr_r1(addr_r1_mem1), .addr_r2(addr_r2_mem1),
                                    .data_r1(data_r1_mem1), .data_r2(data_r2_mem1));

    

    always begin
        clk = 0;
        forever #CLOCK_WIDTH clk = ~clk;
    end

    task write_mem0(input [ADDRWIDTH-1:0] addr, input [width_mem0-1:0] data);
        `DELAY(1);
        en_w1_mem0 = 0;
        en_w2_mem0 = 1;
        addr_w1_mem0 = addr;
        data_w1_mem0 = data;
        `DELAY(1);
        en_w1_mem0 = 1;
        `DELAY(1);        
    endtask

    task write_mem1(input [ADDRWIDTH-1:0] addr, input [width_mem1-1:0] data);
        `DELAY(1);
        en_w1_mem1 = 0;
        en_w2_mem1 = 1;
        addr_w1_mem1 = addr;
        data_w1_mem1 = data;
        `DELAY(1);
        en_w1_mem1 = 1;
        `DELAY(1);        
    endtask


    


    task automatic printmem();
        $display("**********Display Memory*********");
        for (int i = 0 ;i < 2**ADDRWIDTH ; i=i+2) begin
            en_r1_mem0 = 0;  en_r1_mem1 = 0;
            en_r2_mem0 = 0;  en_r2_mem1 = 0;
            //`DELAY(1);

            // addr_r1_mem0 = ADDRWIDTH'(i); addr_r1_mem1 = ADDRWIDTH'(i+1);
            // addr_r2_mem0 = ADDRWIDTH'(i); addr_r2_mem1 = ADDRWIDTH'(i+1);

            addr_r1_mem0 = ADDRWIDTH'(i); addr_r2_mem0 = ADDRWIDTH'(i+1);
			addr_r1_mem1 = ADDRWIDTH'(i); addr_r2_mem1 = ADDRWIDTH'(i+1);
            //`DELAY(1);
            #1;

            if(data_r1_mem0 !== 'd0)
                $display("%S \t %0h", data_r1_mem0, data_r1_mem1);
            if(data_r2_mem0 !== 'd0)
                $display("%S \t  %0h", data_r2_mem0, data_r2_mem1);
            
            en_r1_mem0 = 1;  en_r1_mem1 = 1;
            en_r2_mem0 = 1;  en_r2_mem1 = 1;
            //`DELAY(1);
            #1;
        end
              
    endtask


    // task automatic printDynArr();
	// 	$display("\n----- Displaying data from two dyn arrays ----");
	// 	for (int i = 0; i < 2**ADDRWIDTH; i++) begin
	// 		if(mem1_dyn[i] != 0)
	// 			$display("%10s %h", mem0_dyn[i], mem1_dyn[i]);
	// 	end
    // endtask

    initial begin

        mem0_dyn = new[2**ADDRWIDTH];
        mem1_dyn = new[2**ADDRWIDTH];

        //Reset at first negedge of clock
        //rst_mode = 0;
		rst_n = 1; `DELAY(1);
		rst_n = 0; `DELAY(2);
		rst_n = 1;

		`DELAY(3);

        write_mem0(ADDRWIDTH'(0), CHAR'("Nesrine"));            write_mem1(ADDRWIDTH'(0), `BYTE_SZ'hFF);
        write_mem0(ADDRWIDTH'(1), CHAR'("Sridhar"));            write_mem1(ADDRWIDTH'(1), `BYTE_SZ'hAA);
        write_mem0(ADDRWIDTH'(2), CHAR'("Yong"));               write_mem1(ADDRWIDTH'(2), `BYTE_SZ'hBB);
        write_mem0(ADDRWIDTH'(3), CHAR'("Rupkatha"));           write_mem1(ADDRWIDTH'(3), `BYTE_SZ'hEE);
        write_mem0(ADDRWIDTH'(4), CHAR'("Aart"));               write_mem1(ADDRWIDTH'(4), `BYTE_SZ'hCC);

        printmem();

        `DELAY(5);
        $stop;
    end     



    


    
    endmodule