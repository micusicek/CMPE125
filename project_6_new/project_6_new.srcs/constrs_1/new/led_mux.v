`timescale 1ns / 1ps

module led_mux (
        input  wire       clk,
        input  wire       rst,
        input  wire [7:0] LED3,
        input  wire [7:0] LED2, 
        input  wire [7:0] LED1,
        input  wire [7:0] LED0,
        output wire [3:0] LEDSEL,
        output wire [7:0] LEDOUT
    );
    
    reg [1:0]  index; //2-bit variable 
    reg [11:0] led_ctrl; //12-bit variable
    assign {LEDSEL, LEDOUT} = led_ctrl; 
    
    always @ (posedge clk) index <= (rst) ? 2'b0 : (index + 2'd1);
    // If rst (reset) is true, then index = 0, else index++
    always @ (index, LED0, LED1, LED2, LED3) 
    begin
        case (index) 
            4'd0: led_ctrl <= {4'b1110, LED0};
            4'd1: led_ctrl <= {4'b1101, LED1}; //executes when index = 1
            4'd2: led_ctrl <= {4'b1011, LED2};
            4'd3: led_ctrl <= {4'b0111, LED3};
           default: led_ctrl <={8'b1111, 8'hFF};
        endcase
    end
endmodule

