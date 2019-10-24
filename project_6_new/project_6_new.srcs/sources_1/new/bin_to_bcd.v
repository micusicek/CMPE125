`timescale 1ns / 1ps

module bin_to_bcd(
    input  wire [3:0] value,
    output wire [3:0] dig0,
                      dig1
//                      dig2
    );
    
    assign dig0 = value % 10;
    assign dig1 = (value / 10) % 10;
//    assign dig2 = (value / 100) % 10;
    
endmodule  
