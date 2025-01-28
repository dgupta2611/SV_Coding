module counterassertions #(parameter N = 8)
(	
	input clk, reset, load, inc, dec,
	input [7:0] din,
	input [7:0] count,

	input saturated,
	input zeroed
);


    property p_cnt_reset;
        @(posedge clk) reset |=> (count == '0);
    endproperty

    p_cnt_reset_a: assert property (p_cnt_reset)
                      else $error("%t: Counter not reset to 0", $time);
                      
    
    
    property p_cnt_value_known;
        @(posedge clk) disable iff(reset)
        (!$isunknown(count));
    endproperty

    p_cnt_value_known_a: assert property (p_cnt_value_known)
                            else $error("%t: counter value is not known", $time);



    property p_cnt_load_priorreset;
        @(posedge clk) 
        (~reset && load) |=> (count === $past(din));
    endproperty

    p_cnt_load_priorreset_a: assert property (p_cnt_load_priorreset)
                                else $error("%t: counter loaded incorrectly", $time);
    

    property p_din_value_known;
        @(posedge clk) disable iff(reset)
        load |=> (!$isunknown(din));
    endproperty

    p_din_value_known_a: assert property (p_din_value_known)
                            else $error("%t: din value is not known", $time);

    
    property p_cnt_never_overflow;
        @(posedge clk) disable iff(reset)
        (inc && ~dec && saturated && ~load) |=> (count == '1);
    endproperty

    p_cnt_never_overflow_a: assert property (p_cnt_never_overflow)
                               else $error("%t: counter never overflows", $time);

    
    property p_cnt_never_underflow;
        @(posedge clk) disable iff(reset)
        (~inc && dec && zeroed && ~load) |=> (count == '0);
    endproperty

    p_cnt_never_underflow_a: assert property (p_cnt_never_underflow)
                               else $error("%t: counter never underflows", $time);


    property p_cnt_dec;
        @(posedge clk) disable iff(reset)
        (~inc && dec && ~zeroed && ~load) |=> (count == $past(count) - 1);
    endproperty

    p_cnt_dec_a: assert property (p_cnt_dec)
                    else $error("%t: counter incorrect decrement", $time);


    property p_cnt_inc;
        @(posedge clk) disable iff(reset)
        (inc && ~dec && ~saturated && ~load) |=> (count == $past(count) + 1);
    endproperty

    p_cnt_inc_a: assert property (p_cnt_inc)
                    else $error("%t: counter incorrect increment", $time);

    property p_cnt_stable;
        @(posedge clk) disable iff(reset)
        (((~inc && ~dec) || (inc && dec)) && ~load) |=> $stable(count);
    endproperty

    p_cnt_stable_a: assert property (p_cnt_stable)
                       else $error("%t: counter incorrect value", $time);



    
    

endmodule