module Counter #(parameter N = 8)(
    input clk, reset, load, inc, dec,
    input [N-1:0] din,
    output logic [N-1:0] count
);

    logic saturated = (count == '1);
    logic zeroed = (count == '0);

    always_ff @(posedge clk or reset) begin
        if(reset)
            count <= '0;
        else if(load)
            count <= din;
        else if(inc && ~dec && ~saturated)
            count <= count + 8b'1;
            IA_overflow_a: assert(~(&count)) else $error("%t: counter overflows", $time);
        else if(~inc && dec && ~zeroed)
            count <= count - 8b'1;
            IA_overflow_a: assert(|count) else $error("%t: counter underflows", $time);
        else count <= count;
        
    end

    //All input control signals are known (not X or Z)
    IA_reset_unknown_a: assert(!$isunknown(reset))  else $info("%t: reset is unknown", $time);
    IA_load_unknown_a: assert(!$isunknown(load))    else $info("%t: load is unknown", $time);
    IA_inc_unknown_a: assert(!$isunknown(inc))      else $info("%t: inc is unknown", $time);
    IA_dec_unknown_a: assert(!$isunknown(dec))      else $info("%t: dec is unknown", $time);

    //During a parallel load operation all din signals are known
    IA_din_unknown_a: assert(!$isunknown(load) || !$isunknown(din)  || !load)    
                        else $info("%t: din is unknown during load", $time);
    
    
endmodule