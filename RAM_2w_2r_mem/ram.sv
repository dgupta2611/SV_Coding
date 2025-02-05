module ram #(
    parameter DATAWIDTH = 8, 
    parameter  ADDRWIDTH = 3,
    parameter  rst_mode = 0
    ) 
    (
    input clk, rst_n, 
    input en_w1_n, en_w2_n,
    input [ADDRWIDTH-1:0] addr_w1,
    input [ADDRWIDTH-1:0] addr_w2,
    input [DATAWIDTH-1:0] data_w1,
    input [DATAWIDTH-1:0] data_w2,

    input en_r1_n, en_r2_n,
    input [ADDRWIDTH-1:0] addr_r1,
    input [ADDRWIDTH-1:0] addr_r2,
    output logic [DATAWIDTH-1:0] data_r1,
    output logic [DATAWIDTH-1:0] data_r2
    );

    localparam depth = 2**ADDRWIDTH;

    logic [depth-1:0][DATAWIDTH-1:0] mem;
    logic err = 0;

//     initial begin
//         if((rst_mode !== 0) || (rst_mode !== 1))
//             err = 1;
//             $error("ERROR: rst_mode value is IIlegal, %d for %m", rst_mode);
//         if((DATAWIDTH < 1) || (DATAWIDTH > 8192))
//             err = 1;
//             $error("ERROR: datawidth parameter is outside of the bound (value = %d) for %m", DATAWIDTH);
//         if((ADDRWIDTH < 1) || (ADDRWIDTH > 12))
//             err = 1;
//             $error("ERROR: addrwidth parameter is outside of the bound (value = %d) for %m", ADDRWIDTH);
//     end

//     always @(clk) begin
//         if($isunknown(clk))
//             err = 1;
//             $warning("WARNING: %m: at time = %t, Detected unknown value, %b, on clk input.", $time(), clk);            
//     end

    if(rst_mode === 0) begin
        always_ff @(posedge clk or negedge rst_n) begin : asynchronous_wr
            if(!rst_n)
                 mem <= '0;
            else if(!en_w1_n)
                 mem[addr_w1] <= data_w1;
            else if(!en_w2_n && (addr_w1 !== addr_w2))
                 mem[addr_w2] <= data_w2;
            else if((!en_w1_n && !en_w2_n) && (addr_w1 === addr_w2))
                 mem[addr_w1] <= data_w1;
            else mem[addr_w1] <= mem[addr_w1];
                 mem[addr_w2] <= mem[addr_w2];      
        end
    end
    else begin
        always_ff @(posedge clk) begin : synchronous_wr
            if(!rst_n)
                 mem <= '0;
            else if(!en_w1_n)
                 mem[addr_w1] <= data_w1;
            else if(!en_w2_n && (addr_w1 !== addr_w2))
                 mem[addr_w2] <= data_w2;
            else if((!en_w1_n && !en_w2_n) && (addr_w1 === addr_w2))
                 mem[addr_w1] <= data_w1;
            else mem[addr_w1] <= mem[addr_w1];
                 mem[addr_w2] <= mem[addr_w2];      
        end
    end

    assign data_r1 = en_r1_n ? '0 : mem[addr_r1];
    assign data_r2 = en_r2_n ? '0 : mem[addr_r2];
   
endmodule