module test;

bit [32] bitPatternP = 'b11110111011111011011010101111011; //33-bit signal
bit bitPatternU [32]; //32-element array of single-bit values

// Perform operations then display the result of the operation
 initial begin
 bit [32] b;
 bit [32] bitPatternP_rev;
 int i, j, k;

 // 1. Fill the bits of bitPatternU with bitPatternP.  Do not use a stream operator.
        begin
            for (i=0; i<32; i++)
            bitPatternU[i] = bitPatternP[i];
            $display("1. 0x%p", bitPatternU);
        end

 // Clear out bitPatternU before next operation
        begin 
            bitPatternU = '{ default:'b0 };
            $display("1. 0x%p", bitPatternU);
        end



 // 2. Fill the bits of bitPatternU with bitPatternP.  Use a stream operator.
        begin
            bitPatternU = {>> {'b11110111011111011011010101111011}};
            $display("2. 0x%p", bitPatternU);
        end



 // 3. Reverse the bits of bitPatternP with assignment to b.  Do not use a stream operator.
 //      I.e. 1110101 would become 1010111

        begin
            for (j=0; j< 32; j++)
            b[j] = bitPatternP[31-j];
            $display("3. 0x%h", b);
        end
 // Clear out b
        begin 
            b = '0;
            $display("3. 0x%h", b);
        end


 // 4. Reverse the bits of bitPatternP with assignment to bitPatternP_rev.  Use a stream operator.

        begin
            bitPatternP_rev = {<< {'b11110111011111011011010101111011}};
            $display("4. 0x%h", bitPatternP_rev);
        end
        

// The rest of the code will use the bitPatternP_rev.  It is the bit reverse of bitPatternP above.


 // 5. Reverse the nibbles of bitPatternP_rev with assignment to b.  Do not use a stream operator.
 //    I.e. ABCD would become DCBA

        begin
            for (k=0; k<8 ; k++) begin
                // b[4*k:4*k+3] = bitPatternP_rev[28-4*k:31-4*k];
                b[4*k]   = bitPatternP_rev[28-4*k]; 
                b[4*k+1] = bitPatternP_rev[29-4*k]; 
                b[4*k+2] = bitPatternP_rev[30-4*k]; 
                b[4*k+3] = bitPatternP_rev[31-4*k];
            end
            $display("5. 0x%h", b);
        end 

 // Clear out b
        begin 
        b = '0;
        $display("5. 0x%h", b);
        end
    

 // 6. Reverse the nibbles of bitPatternP_rev with assignment to b.  Use a stream operator.

        begin
            b = {<< 4 {bitPatternP_rev}};
            $display("6. 0x%h", b);
        end
 

 // 7. Reverse the bytes of bitPatternP_rev with assignment to b.  Do not use a stream operator.
 //    I.e. ABCD would become CDAB

        begin
            for (k=0; k<4 ; k++) begin
                b[8*k]   = bitPatternP_rev[24-8*k];
                b[8*k+1] = bitPatternP_rev[25-8*k];
                b[8*k+2] = bitPatternP_rev[26-8*k];
                b[8*k+3] = bitPatternP_rev[27-8*k];
                b[8*k+4] = bitPatternP_rev[28-8*k];
                b[8*k+5] = bitPatternP_rev[29-8*k];
                b[8*k+6] = bitPatternP_rev[30-8*k];
                b[8*k+7] = bitPatternP_rev[31-8*k];
            end
            $display("7. 0x%h", b);
        end 

 // Clear out b

        begin 
        b = '0;
        $display("7. 0x%h", b);
        end

 // 8. Reverse the bytes of bitPatternP_rev with assignment to b.  Use a stream operator.

        begin
            b = {<< byte {bitPatternP_rev}};
            $display("8. 0x%h", b);
        end
 


 // 9. Reverse the 16-bit portions of bitPatternP_rev with assignment to b.  Do not use a stream operator.
 //    I.e. 89ABCDEF would become CDEF89AB

        begin
            for (k=0; k<2 ; k++) begin
                //b[16*k:16*k+15] = bitPatternP_rev[16-16*k:31-16*k];
                
                b[16*k]   = bitPatternP_rev[16-16*k];
                b[16*k+1] = bitPatternP_rev[17-16*k];
                b[16*k+2] = bitPatternP_rev[18-16*k];
                b[16*k+3] = bitPatternP_rev[19-16*k];
                b[16*k+4] = bitPatternP_rev[20-16*k];
                b[16*k+5] = bitPatternP_rev[21-16*k];
                b[16*k+6] = bitPatternP_rev[22-16*k];
                b[16*k+7] = bitPatternP_rev[23-16*k];

                b[16*k+8]  = bitPatternP_rev[24-16*k];
                b[16*k+9]  = bitPatternP_rev[25-16*k];
                b[16*k+10] = bitPatternP_rev[26-16*k];
                b[16*k+11] = bitPatternP_rev[27-16*k];
                b[16*k+12] = bitPatternP_rev[28-16*k];
                b[16*k+13] = bitPatternP_rev[29-16*k];
                b[16*k+14] = bitPatternP_rev[30-16*k];
                b[16*k+15] = bitPatternP_rev[31-16*k];
                b[16*k+16] = bitPatternP_rev[32-16*k];
            end
            $display("9. 0x%h", b);
        end 

 // Clear out b

        begin 
        b = '0;
        $display("9. 0x%h", b);
        end

 // 10. Reverse the 16-bit portions of bitPatternP_rev with assignment to b.  Use a stream operator.

        begin
            b = {<< 16 {bitPatternP_rev}};
            $display("10. 0x%h", b);
        end


end
endmodule
