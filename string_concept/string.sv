module mda;
    bit [1][2][3][4] val [4][5][6][7];

    int count = 0;
    string str, str_rev;

    initial begin
        // Initialize the mda with counter values.
        for(int i = 0; i < 4; i++)
            for(int j = 0; j < 4; j++)
                for(int k = 0; k < 4; k++)
                    for(int l = 0; l < 4; l++)
                        val[i][j][k][l] = count++;

        // Going over all the unpacked entries, if packed decimal number is palindromic number,
        // then display it with the indices.
        // I.e. val[3][4][5][5]=838 is decimal palindromic
        for(int i = 0; i < 4; i++)
            for(int j = 0; j < 4; j++)
                for(int k = 0; k < 4; k++)
                    for(int l = 0; l < 4; l++) begin
                        str.itoa(val[i][j][k][l]);
                        str_rev = {<< 8 {str}};

                        if(str_rev.atoi() === str.atoi())
                            $display("val[%0d][%0d][%0d][%0d] = %3s (integer) is a Palindrome", i, j, k, l, str);
                    end


        // Going over all the unpacked entries, if packed octal number is palindromic number,
        // then display it with the indices.
        // I.e. val[3][4][0][3]=1441 is octal palindromic
        for(int i = 0; i < 4; i++)
            for(int j = 0; j < 4; j++)
                for(int k = 0; k < 4; k++)
                    for(int l = 0; l < 4; l++) begin
                        str.octtoa(val[i][j][k][l]);
                        str_rev = {<< 8 {str}};

                        if(str_rev.atooct() === str.atooct())
                            $display("val[%0d][%0d][%0d][%0d] = %3s (integer) is a Palindrome", i, j, k, l, str);
                    end

        // Going over all the unpacked entries, and the first two packed dimensions, if the last two packed
        // dimensions number is binary palindromic, then display it with indices.
        // I.e. val[3][4][5][0][0][1]=1000001 is binary palindromic
        for(int i = 0; i < 4; i++)
            for(int j = 0; j < 4; j++)
                for(int k = 0; k < 4; k++)
                    for(int l = 0; l < 4; l++)
                        for(int m = 0; m < 4; m++) 
                            for(int n = 0; n < 4; n++) begin
                                str.bintoa(val[i][j][k][l][m][n]);
                                str_rev = {<< 8 {str}};

                                if(str_rev.atobin() === str.atobin())
                                    $display("val[%0d][%0d][%0d][%0d][%0d][%0d] = %3s (integer) is a Palindrome", i, j, k, l, m, n, str);
                                end

        #50;
        $stop;
    end
    
endmodule