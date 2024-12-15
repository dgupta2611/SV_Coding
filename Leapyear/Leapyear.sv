module Leapyear 
    (
    input [3:0] Ym, Yh, Yt, Yo,
    output logic LY,
    );

    logic divby4, divby4_400, divby100, divby400;
    logic zero1, zero2;

    //if last two digit of a year is divided by 4 (its a LY)
    divby4 divby4_inst1(Yt, Yo, divby4);

    //check if year is a century year or year is divided by 100
    iszero zero1_inst(Yo, zero1);
    iszero zero2_inst(Yt, zero2);

    assign divby100 = zero1 & zero2;

    //check if year is divided by 400 (its a LY)
    divby4 divby4_inst2(Ym, Yh, divby4_400);

    divby400 = divby4_400 & divby100;

    assign LY = divby4 & (~divby100 | divby400);
    
endmodule