module ov7670_registers(
  input  wire        clk     ,
  input  wire        resend  ,
  input  wire        advance ,
  output wire [15:0] command ,
  output reg         finished
);

  reg [15:0] sreg;
  reg [7:0]  address = 'b0;

  assign command = sreg;

  always @(*) begin
    case(sreg)
      16'hFFFF : finished = 1'b1;
      default : finished = 1'b0;
    endcase
  end

  always @(posedge clk) begin
    if(resend == 1'b1) begin
      address <= {8{1'b0}};
    end
    else if(advance == 1'b1) begin
      address <= (address) + 1;
    end
    case(address)
    8'h00 : begin
      sreg <= 16'h1280;
      // COM7   Reset
    end
    8'h01 : begin
      sreg <= 16'h1280;
      // COM7   Reset
    end
    8'h02 : begin
      sreg <= 16'h1204;
      // COM7   Size & RGB output
    end
    8'h03 : begin
      sreg <= 16'h1100;
      // CLKRC  Prescaler - Fin/(1+1)
    end
    8'h04 : begin
      sreg <= 16'h0C00;
      // COM3   Lots of stuff, enable scaling, all others off
    end
    8'h05 : begin
      sreg <= 16'h3E00;
      // COM14  PCLK scaling off
    end
    8'h06 : begin
      sreg <= 16'h8C00;
      // RGB444 Set RGB format
    end
    8'h07 : begin
      sreg <= 16'h0400;
      // COM1   no CCIR601
    end
    8'h08 : begin
      sreg <= 16'h4010;
      // COM15  Full 0-255 output, RGB 565
    end
    8'h09 : begin
      sreg <= 16'h3a04;
      // TSLB   Set UV ordering,  do not auto-reset window
    end
    8'h0A : begin
      sreg <= 16'h1438;
      // COM9  - AGC Celling
    end
    8'h0B : begin
      sreg <= 16'h4fb3;
      // MTX1  - colour conversion matrix
    end
    8'h0C : begin
      sreg <= 16'h50b3;
      // MTX2  - colour conversion matrix
    end
    8'h0D : begin
      sreg <= 16'h5100;
      // MTX3  - colour conversion matrix
    end
    8'h0E : begin
      sreg <= 16'h523d;
      // MTX4  - colour conversion matrix
    end
    8'h0F : begin
      sreg <= 16'h53a7;
      // MTX5  - colour conversion matrix
    end
    8'h10 : begin
      sreg <= 16'h54e4;
      // MTX6  - colour conversion matrix
    end
    8'h11 : begin
      sreg <= 16'h589e;
      // MTXS  - Matrix sign and auto contrast
    end
    8'h12 : begin
      sreg <= 16'h3dc0;
      // COM13 - Turn on GAMMA and UV Auto adjust
    end
    8'h13 : begin
      sreg <= 16'h1100;
      // CLKRC  Prescaler - Fin/(1+1)
    end
    8'h14 : begin
      sreg <= 16'h1711;
      // HSTART HREF start (high 8 bits)
    end
    8'h15 : begin
      sreg <= 16'h1861;
      // HSTOP  HREF stop (high 8 bits)
    end
    8'h16 : begin
      sreg <= 16'h32A4;
      // HREF   Edge offset and low 3 bits of HSTART and HSTOP
    end
    8'h17 : begin
      sreg <= 16'h1903;
      // VSTART VSYNC start (high 8 bits)
    end
    8'h18 : begin
      sreg <= 16'h1A7b;
      // VSTOP  VSYNC stop (high 8 bits) 
    end
    8'h19 : begin
      sreg <= 16'h030a;
      // VREF   VSYNC low two bits
      //				when x"10" => sreg <= x"703a"; -- SCALING_XSC
      //				when x"11" => sreg <= x"7135"; -- SCALING_YSC
      //				when x"12" => sreg <= x"7200"; -- SCALING_DCWCTR  -- zzz was 11 
      //				when x"13" => sreg <= x"7300"; -- SCALING_PCLK_DIV
      //				when x"14" => sreg <= x"a200"; -- SCALING_PCLK_DELAY  must match COM14
      //          when x"15" => sreg <= x"1500"; -- COM10 Use HREF not hSYNC
      //				
      //				when x"1D" => sreg <= x"B104"; -- ABLC1 - Turn on auto black level
      //				when x"1F" => sreg <= x"138F"; -- COM8  - AGC, White balance
      //				when x"21" => sreg <= x"FFFF"; -- spare
      //				when x"22" => sreg <= x"FFFF"; -- spare
      //				when x"23" => sreg <= x"0000"; -- spare
      //				when x"24" => sreg <= x"0000"; -- spare
      //				when x"25" => sreg <= x"138F"; -- COM8 - AGC, White balance
      //				when x"26" => sreg <= x"0000"; -- spare
      //				when x"27" => sreg <= x"1000"; -- AECH Exposure
      //				when x"28" => sreg <= x"0D40"; -- COMM4 - Window Size
      //				when x"29" => sreg <= x"0000"; -- spare
      //				when x"2a" => sreg <= x"a505"; -- AECGMAX banding filter step
      //				when x"2b" => sreg <= x"2495"; -- AEW AGC Stable upper limite
      //				when x"2c" => sreg <= x"2533"; -- AEB AGC Stable lower limi
      //				when x"2d" => sreg <= x"26e3"; -- VPT AGC fast mode limits
      //				when x"2e" => sreg <= x"9f78"; -- HRL High reference level
      //				when x"2f" => sreg <= x"A068"; -- LRL low reference level
      //				when x"30" => sreg <= x"a103"; -- DSPC3 DSP control
      //				when x"31" => sreg <= x"A6d8"; -- LPH Lower Prob High
      //				when x"32" => sreg <= x"A7d8"; -- UPL Upper Prob Low
      //				when x"33" => sreg <= x"A8f0"; -- TPL Total Prob Low
      //				when x"34" => sreg <= x"A990"; -- TPH Total Prob High
      //				when x"35" => sreg <= x"AA94"; -- NALG AEC Algo select
      //				when x"36" => sreg <= x"13E5"; -- COM8 AGC Settings
    end
    default : begin
      sreg <= 16'hffff;
    end
    endcase
  end

endmodule
