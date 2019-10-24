`timescale 1ns / 1ps

module tb_regfile2;
    reg         tb_we1,
                tb_we2;
    reg         tb_clk = 1;
    reg  [4:0]  tb_ra1,
                tb_ra2,
                tb_wa1,
                tb_wa2;
    reg  [31:0] tb_wd1,
                tb_wd2;
    wire [31:0] tb_rd1,
                tb_rd2;
                
    integer     i;
    integer     error_count = 0;

    regfile2 DUT (
        .we1(tb_we1),
        .we2(tb_we2),
        .clk(tb_clk),
        .ra1(tb_ra1),
        .ra2(tb_ra2),
        .wa1(tb_wa1),
        .wa2(tb_wa2),
        .wd1(tb_wd1),
        .wd2(tb_wd2),
        .rd1(tb_rd1),
        .rd2(tb_rd2)
    );

    initial
    begin
    
      tb_we1 = 1;
      tb_we2 = 1;
      tb_wd1 = 32'h2E9C003A;
      tb_wd2 = 32'h100FF2B7;
      //--- Fill Registers 1-14 ------//
      //--------- with wd1 -----------//
      for(i = 1; i < 15; i = i + 1)
      begin
        tb_wa1 = i;
        #4;
      end
      //--- Fill Registers 15-31 ------//
      //--------- with wd2 -----------//
      tb_we2 = 1;
      for(i = 15; i < 32; i = i + 1)
      begin
        tb_wa2 = i;
        #4;
      end
      
      tb_we1 = 0;
      tb_we2 = 0;
      tb_wd1 = 32'hAAAABBBB;
      tb_wd2 = 32'hCCCCDDDD;
      //--- Fill Registers 1-14 ------//
      //--------- with wd1 -----------//
      //------ (Write Disabled) ------//
      for(i = 1; i < 15; i = i + 1)
      begin
        tb_wa1 = i;
        #4;
      end
      //--- Fill Registers 15-31 -----//
      //--------- with wd2 -----------//
      //------ (Write Disabled) ------//
      for(i = 15; i < 32; i = i + 1)
      begin
        tb_wa2 = i;
        #4;
      end
      
      //---- Read Registers 1-14 -----//
      //------- from port 1 ----------//
      for(i = 1; i < 15; i = i + 1)
      begin
        tb_ra1 = i;
        #4;
        if(tb_rd1 != 32'h2E9C003A)
        begin
            $display("Regfile error");
            error_count = error_count + 1;
        end
      end
      //---- Read Registers 15-31 -----//
      //-------- from port 2 ----------//
      for(i = 16; i < 32; i = i + 1)
      begin
        tb_ra2 = i;
        #4;
        if(tb_rd2 != 32'h100FF2B7)
        begin
            $display("Regfile error");
            error_count = error_count + 1;
        end
      end
      
      //------ Corner Case 1 -----//
      tb_wd1 = 32'hFFFFFFFF;
      tb_we1 = 1;
      tb_wa1 <= 5'b00010;
      tb_ra1 <= 5'b00010;
      tb_ra2 <= 5'b00010;
      #4;
      tb_we1 = 0;
      
      //------ Corner Case 2 -----//
      tb_wd2 = 32'h44444444;
      tb_we2 = 1;
      tb_wa2 <= 5'b00010;
      tb_ra2 <= 5'b00010;
      tb_ra1 <= 5'b00010;
      #4;
      
      //--- Simultaneous write ---//
      tb_wd2 <= 32'hDDDDDDDD;
      tb_wd1 <= 32'hCCCCCCCC;
      tb_we2 <= 1;
      tb_we1 <= 1;
      tb_wa1 <= 5'b11111;
      tb_wa2 <= 5'b11111;
      tb_ra1 <= 5'b11111;
      tb_ra2 <= 5'b11111;
      #4;
      if((tb_rd1 != tb_wd1) && (tb_rd2 != tb_wd1))
      begin
        $display("Simultaneous Write Error");
        $finish;
      end
      
      //--- Write to address 0 --//
      tb_wd1 = 32'h77777777;
      tb_wd2 = 32'h66666666;
      tb_wa1 = 5'b0;
      tb_ra1 = 5'b0;
      #4;
      if(tb_rd1 != 0)
      begin
        $display("Address 0 Write Error");
        error_count = error_count + 1;
      end
      tb_wa2 = 5'b0;
      tb_ra2 = 5'b0;
      #4;
      if(tb_rd2 != 0)
      begin
        $display("Address 0 Write Error");
        error_count = error_count + 1;
      end
      
      $display("Simulation Finished");
      $finish;   
    end // initial block

    always #2 tb_clk <= ~tb_clk;

endmodule
