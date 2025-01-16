module mz(clock, reset, ld_high, ld_low, addr, din, write, zero,
    dout, busy);
    parameter ADDRWIDTH = 6;
    parameter DATAWIDTH = 8;
    input clock;
    input reset;
    input ld_high, ld_low;
    input [ADDRWIDTH-1:0] addr;
    input [DATAWIDTH-1:0] din;
    input write;
    input zero;
    output logic [DATAWIDTH-1:0] dout;
    output logic busy;

    logic set_busy, clr_busy, ld_cnt, cnt_en, addr_sel, zero_we, cnt_eq; 

    datapath  #(ADDRWIDTH, DATAWIDTH) dp_Inst
    (.clock(clock), 
    .ld_high(ld_high), 
    .ld_low(ld_low), 
    .addr(addr), 
    .din(din), 
    .write(write), 
    .set_busy(set_busy),
    .clr_busy(clr_busy), 
    .ld_cnt(ld_cnt), 
    .cnt_en(cnt_en), 
    .addr_sel(addr_sel), 
    .zero_we(zero_we), 
    .cnt_eq(cnt_eq), 
    .dout(dout), 
    .busy(busy));

    Controller C_Inst
    (.clock(clock),
    .reset(reset),
    .zero(zero),
    .cnt_eq(cnt_eq),
    .set_busy(set_busy),
    .clr_busy(clr_busy),
    .ld_cnt(ld_cnt),
    .cnt_en(cnt_en),
    .addr_sel(addr_sel),
    .zero_we(zero_we));
    
    
endmodule