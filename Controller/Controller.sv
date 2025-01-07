module Controller(
    input clock,
    input reset,
    input zero,
    input cnt_eq,
    output set_busy,
    output clr_busy,
    output ld_cnt,
    output cnt_en,
    output addr_sel,
    output zero_we);

    typedef enum logic[1:0] {INIT, NORMAL, ZERO} state, nxt_state;

    always_ff @(posedge clock) begin 
        
        
    end

endmodule