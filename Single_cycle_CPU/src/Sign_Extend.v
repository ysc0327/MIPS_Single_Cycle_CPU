//Subject:     CA - Sign extend
//--------------------------------------------------------------------------------

module Sign_Extend #(
	parameter width = 16
	)
	(
    data_i,
    data_o
    );
               
//I/O ports
input   [width-1:0] data_i;
output  [2*width-1:0] data_o;


assign data_o = { {16{data_i[15]}}, data_i};

endmodule      
     