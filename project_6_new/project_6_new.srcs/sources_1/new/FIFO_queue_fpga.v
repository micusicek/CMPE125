`timescale 1ns / 1ps

module FIFO_queue_fpga( 
    input  wire       push_button_clk,
                      push_button_rst,
                      switch_en,
                      switch_RNW,
                      clk100MHz,
    input  wire [3:0] switch_in,
    output wire       LED_en,
                      LED_RNW,
    output wire [1:0] LED_flags,
    output wire [3:0] LED_in,
                      LEDSEL,
    output wire [7:0] LEDOUT
    );
    
    supply1 [7:0] vcc;
    wire          clk_4sec,
                  clk_5KHz,
                  manual_clk;
//                  pb_rst;
    wire [3:0]    q_out,
                  bcd0,
                  bcd1;
    wire [7:0]    out0,
                  out1;
                  
    assign LED_in[0] = switch_in[0];
    assign LED_in[1] = switch_in[1];
    assign LED_in[2] = switch_in[2];
    assign LED_in[3] = switch_in[3];
    assign LED_en    = switch_en;
    assign LED_RNW   = switch_RNW;
    
    //------- FIFO ----------//
    FIFO_queue q1 (
        .RNW(switch_RNW),
        .en(switch_en),
        .clk(manual_clk),
        .rst(push_button_rst),
        .in(switch_in),
                .full(LED_flags[0]),
        .empty(LED_flags[1]),
        .out(q_out)
    );
    //-----------------------//
    
    clk_gen CLK (
        .clk100MHz(clk100MHz),
        .rst(push_button_rst),
        .clk_4sec(clk_4sec),
        .clk_5KHz(clk_5KHz)
    );
    
    button_debouncer db_clk (
        .clk(clk_5KHz),
        .button(push_button_clk),
        .debounced_button(manual_clk)
    ); 
    
//    button_debouncer db_rst (
//        .clk(clk_5KHz),
//        .button(push_button_rst),
//        .debounced_button(manual_clk)
//    ); 
    
    bin_to_bcd (
        .value(q_out),
        .dig0(bcd0),
        .dig1(bcd1)
    );
    
    hex_to_7seg (
        .HEX(bcd0),
        .s(out0)
    );
    
    hex_to_7seg (
        .HEX(bcd1),
        .s(out1)
    );
    
    led_mux LED (
        .clk            (clk_5KHz),
        .rst            (push_button_rst),
        .LED3           (vcc),
        .LED2           (vcc),
        .LED1           (out1),
        .LED0           (out0),
        .LEDSEL         (LEDSEL),
        .LEDOUT         (LEDOUT)
    );
    
endmodule


