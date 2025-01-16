module register #(parameter ADDRWIDTH = 6)(
    input load, 
    input [ADDRWIDTH-1:0] din,
    output logic [ADDRWIDTH-1:0] dout
    );

    logic [ADDRWIDTH-1:0] m;

    assign dout = m;

    always_latch begin
       if(load) m = din;
    end
    
endmodule

module Upcounter #(parameter ADDRWIDTH = 6)(
    input clock,
    input load, en,
    input [ADDRWIDTH-1:0] din,
    output logic [ADDRWIDTH-1:0] dout
    );

    logic [ADDRWIDTH-1:0] count;

    assign dout = count;

    always_ff @(posedge clock) begin 
        if(load)
            count <= din;
        else if(en)
            count <= count + 1'b 1;  
        else count <= count;     
    end
    
endmodule

//module comparator #(parameter ADDRWIDTH = 6) (
//    input [ADDRWIDTH-1:0] din_b, din_a,
//    output logic aEQb
//    );
//
//    assign aEQb = (din_b === din_a) ? 1 : 0;
//endmodule

module Memory #(parameter ADDRWIDTH = 6, DATAWIDTH = 8) (
    input [ADDRWIDTH-1:0] addr,
    input [DATAWIDTH-1:0] din,
    input we,
    input clock,
    output logic [DATAWIDTH-1:0] dout
    );

    logic [DATAWIDTH-1:0] mem [2**ADDRWIDTH-1:0];

    assign dout = mem[addr];

    always_ff @(posedge clock) begin
        if(we)
            mem[addr] <= din;
        else mem <= mem;
    end
    
endmodule

module MUX #(parameter WIDTH = 6, N = 2)(
    input [N-1:0][WIDTH-1:0] V,
    input [$clog2(N)-1:0] S,
    output logic [WIDTH-1:0] Y
    );

    assign Y = V[S];
    
endmodule

module JK_FF(
    input J, K, clock, 
    output logic Q
    );

    always_ff @(posedge clock) begin
        if({J,K} == 2'b11) 
            Q <= ~Q;
        else if({J,K} == 2'b10)
            Q <= 1'b1;
        else if({J,K} == 2'b01)
            Q <= 1'b0;
        else if({J,K} == 2'b00)
            Q <= Q;
    end
           
endmodule


module datapath(clock, ld_high, ld_low, addr, din, write, set_busy,
    clr_busy, ld_cnt, cnt_en, addr_sel, zero_we, cnt_eq, dout, busy);
    parameter ADDRWIDTH = 6;
    parameter DATAWIDTH = 8;
    input clock;
    input ld_high, ld_low;
    input [ADDRWIDTH-1:0] addr;
    input [DATAWIDTH-1:0] din;
    input write;
    input set_busy;
    input clr_busy;
    input ld_cnt;
    input cnt_en;
    input addr_sel;
    input zero_we;
    output logic cnt_eq;
    output logic [DATAWIDTH-1:0] dout;
    output logic busy;
 
    logic [ADDRWIDTH-1:0] dout1, dout2, dout_up;

    register #(ADDRWIDTH) R1_Inst(ld_high, addr, dout1);

    register #(ADDRWIDTH) R2_Inst(ld_low, addr, dout2);

    Upcounter #(ADDRWIDTH) UP_Inst(clock, ld_cnt, cnt_en, dout2, dout_up);   

   // comparator #(ADDRWIDTH) comp_Inst(dout1, dout_up, cnt_eq);

    assign cnt_eq = (dout1 === dout_up);

    logic [DATAWIDTH-1:0] memDatIn;
    logic [ADDRWIDTH-1:0] memAdrIn;

    MUX #(.N(2), .WIDTH(ADDRWIDTH)) mux1_Inst(.V({dout_up, addr}), .S(addr_sel), .Y(memAdrIn));

    MUX #(.N(2), .WIDTH(DATAWIDTH)) mux2_Inst(.V({{DATAWIDTH{1'b0}}, din}), .S(addr_sel), .Y(memDatIn));

    JK_FF JK_Inst(set_busy, clr_busy, clock, busy);

    logic OR;

    assign OR = write | zero_we;

    Memory #(ADDRWIDTH, DATAWIDTH) mem_Inst(memAdrIn, memDatIn, OR, clock, dout);


endmodule