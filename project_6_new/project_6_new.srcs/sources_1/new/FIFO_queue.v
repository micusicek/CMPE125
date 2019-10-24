`timescale 1ns / 1ps

module FIFO_queue(
    input            RNW,   // read (1) or write (0)
                     en,    // enable
                     clk,   // clock
                     rst,   // reset
    input      [3:0] in,  
    output reg       full,  // full flag
                     empty, // empty flag
    output reg [3:0] out
    );
    
    reg [3:0] r_ptr,
              w_ptr;
    reg [3:0] mem [7:0];
    
    always @ (posedge clk, posedge rst)
    begin
        if (rst)
        begin
            r_ptr <= 0;
            w_ptr <= 0;
            out <= 0;
        end
        else if (!en) 
            out <= 'bz;
        else if (RNW && !empty)
        begin
          out <= mem[r_ptr[2:0]];
          r_ptr <= r_ptr + 1;   
        end
        else if (!RNW && !full)
        begin
            mem[w_ptr[2:0]] <= in;
            w_ptr <= w_ptr + 1;
        end
        else 
            out <= 'bz;  
    end // always block
    
    always @ (r_ptr, w_ptr)
    begin
        if(r_ptr == w_ptr)
        begin
            empty <= 1;
            full <= 0;
        end
        else if(r_ptr[2:0] == w_ptr[2:0])
        begin
            empty <= 0;
            full <= 1;
        end
        else
        begin
            empty <= 0;
            full <= 0;
        end
    end // always block
    
endmodule
