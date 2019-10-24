
`timescale 1ns / 1ps

module regfile2(
    input         we1,  // write enable 1
                  we2,  // write enable 2
                  clk,
    input  [4:0]  ra1,  // address for read port 1
                  ra2,  // address for read port 2
                  wa1,  // address to write wd1
                  wa2,  // address to write wd2
    input  [31:0] wd1,  // data
                  wd2,  // data
    output [31:0] rd1,  // read port
                  rd2   // read port
    );
    
    reg [31:0] rf [31:0];
    
    always@(posedge clk)
    begin
        if(wa1 == wa2) 
        begin
            if(we1) rf[wa1] <= wd1;
            if(we2 && !we1) rf[wa2] <= wd2;
        end
        else
        begin
            if(we1) rf[wa1] <= wd1;
            if(we2) rf[wa2] <= wd2;
        end // else block
    end // always block
    
    assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
    assign rd2 = (ra2 != 0) ? rf[ra2] : 0;
    
endmodule

