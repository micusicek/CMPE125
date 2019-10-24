`timescale 1ns / 1ps

module tb_FIFO_queue;
    reg        tb_RNW,
               tb_en,
               tb_rst;
    reg        tb_clk = 1;
    reg [3:0]  tb_in;
    wire       tb_full,
               tb_empty;
    wire [3:0] tb_out;
    
    FIFO_queue q1 (
        .RNW(tb_RNW),
        .en(tb_en),
        .clk(tb_clk),
        .rst(tb_rst),
        .in(tb_in),
        .full(tb_full),
        .empty(tb_empty),
        .out(tb_out)
    );
    
    integer i;
    integer error_count = 0;
    
    always #2 tb_clk = ~tb_clk;
    
    initial 
    begin
        tb_rst = 1;
        #4
        tb_rst = 0;
        
        //---------- Filling Queue ---------//
        tb_en = 1;
        tb_RNW = 0;
        for(i = 0; i < 8; i = i + 1)
        begin
            tb_in = i;
            #4;
            if(i==5 && (tb_full || tb_empty)) // Checks flags for partially filled
            begin
               $display("Partial Fill Error"); 
               error_count = error_count + 1; 
            end
        end // forloop write
        //-------- Checking Full ----------//
        if(!tb_full)
        begin
            $display("Full Flag Error");
            error_count = error_count + 1;
        end
        
        //------- Emptying Queue ---------//
        tb_RNW = 1;
        for(i = 0; i < 8; i = i + 1)
        begin
            #4;
            if(i==5 && (tb_full || tb_empty)) // Check flags partially empty
            begin
               $display("Partial Empty Error");
               error_count = error_count + 1; 
            end
        end // forloop read
        //------- Checking Empty ---------//
        if(!tb_empty)
        begin
            $display("Empty Flag Error");
            error_count = error_count + 1;
        end
        
        //------- Disable write ---------//
        //------ and Fill Queue ---------//
        tb_RNW = 0;
        tb_en = 0;
        for(i = 0; i < 8; i = i + 1)
        begin
          tb_in = i;
          #4;
        end // forloop read
        //----- Check Still Empty ------//
        if(!tb_empty)
        begin
            $display("Empty Flag Error");
            error_count = error_count + 1;
        end
        
        $display("Simulation Finished");
        $finish;
    end // initial block
    
endmodule 

