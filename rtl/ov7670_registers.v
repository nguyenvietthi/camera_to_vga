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
      0:  sreg <= 16'h12_80;  // COM7:        Reset SCCB registers
      1:  sreg <= 16'hFF_F0;  // Delay
      2:  sreg <= 16'h12_04;  // COM7,        Set RGB color output
      3:  sreg <= 16'h11_00;  // CLKRC        Internal PLL matches input clock (24 MHz). 
      4:  sreg <= 16'h0C_00;  // COM3,        *Leave as default.
      5:  sreg <= 16'h3E_00;  // COM14,       *Leave as default. No scaling, normal pclock
      6:  sreg <= 16'h04_00;  // COM1,        *Leave as default. Disable CCIR656
      7:  sreg <= 16'h8C_02;  // RGB444       Enable RGB444 mode with xR GB.
      8:  sreg <= 16'h40_D0;  // COM15,       Output full range for RGB 444. 
      9:  sreg <= 16'h3a_04;  // TSLB         set correct output data sequence (magic)
      10: sreg <= 16'h14_18;  // COM9         MAX AGC value x4
      11: sreg <= 16'h4F_B3;  // MTX1         all of these are magical matrix coefficients
      12: sreg <= 16'h50_B3;  // MTX2
      13: sreg <= 16'h51_00;  // MTX3
      14: sreg <= 16'h52_3d;  // MTX4
      15: sreg <= 16'h53_A7;  // MTX5
      16: sreg <= 16'h54_E4;  // MTX6
      17: sreg <= 16'h58_9E;  // MTXS
      18: sreg <= 16'h3D_C0;  // COM13        sets gamma enable, does not preserve reserved bits, may be wrong?
      19: sreg <= 16'h17_14;  // HSTART       start high 8 bits
      20: sreg <= 16'h18_02;  // HSTOP        stop high 8 bits //these kill the odd colored line
      21: sreg <= 16'h32_80;  // HREF         edge offset
      22: sreg <= 16'h19_03;  // VSTART       start high 8 bits
      23: sreg <= 16'h1A_7B;  // VSTOP        stop high 8 bits
      24: sreg <= 16'h03_0A;  // VREF         vsync edge offset
      25: sreg <= 16'h0F_41;  // COM6         reset timings
      26: sreg <= 16'h1E_00;  // MVFP         disable mirror / flip //might have magic value of 03
      27: sreg <= 16'h33_0B;  // CHLF         magic value from the internet
      28: sreg <= 16'h3C_78;  // COM12        no HREF when VSYNC low
      29: sreg <= 16'h69_00;  // GFIX         fix gain control
      30: sreg <= 16'h74_00;  // REG74        Digital gain control
      31: sreg <= 16'hB0_84;  // RSVD         magic value from the internet *required* for good color
      32: sreg <= 16'hB1_0c;  // ABLC1
      33: sreg <= 16'hB2_0e;  // RSVD         more magic internet values
      34: sreg <= 16'hB3_80;  // THL_ST
      //begin mystery scaling numbers
      35: sreg <= 16'h70_3a;  // SCALING_XSC          *Leave as default. No test pattern output. 
      36: sreg <= 16'h71_35;  // SCALING_YSC          *Leave as default. No test pattern output.
      37: sreg <= 16'h72_11;  // SCALING DCWCTR       *Leave as default. Vertical down sample by 2. Horizontal down sample by 2.
      38: sreg <= 16'h73_f0;  // SCALING PCLK_DIV 
      39: sreg <= 16'ha2_02;  // SCALING PCLK DELAY   *Leave as deafult. 
      //gamma curve values
      40: sreg <= 16'h7a_20;  // SLOP
      41: sreg <= 16'h7b_10;  // GAM1
      42: sreg <= 16'h7c_1e;  // GAM2
      43: sreg <= 16'h7d_35;  // GAM3
      44: sreg <= 16'h7e_5a;  // GAM4
      45: sreg <= 16'h7f_69;  // GAM5
      46: sreg <= 16'h80_76;  // GAM6
      47: sreg <= 16'h81_80;  // GAM7
      48: sreg <= 16'h82_88;  // GAM8
      49: sreg <= 16'h83_8f;  // GAM9
      50: sreg <= 16'h84_96;  // GAM10
      51: sreg <= 16'h85_a3;  // GAM11
      52: sreg <= 16'h86_af;  // GAM12
      53: sreg <= 16'h87_c4;  // GAM13
      54: sreg <= 16'h88_d7;  // GAM14
      55: sreg <= 16'h89_e8;  // GAM15
      //AGC and AEC
      56: sreg <= 16'h13_e0;  // COM8     disable AGC / AEC
      57: sreg <= 16'h00_00;  // set gain reg to 0 for AGC
      58: sreg <= 16'h10_00;  // set ARCJ reg to 0
      59: sreg <= 16'h0d_40;  // magic reserved bit for COM4
      60: sreg <= 16'h14_18;  // COM9, 4x gain + magic bit
      61: sreg <= 16'ha5_05;  // BD50MAX
      62: sreg <= 16'hab_07;  // DB60MAX
      63: sreg <= 16'h24_95;  // AGC upper limit
      64: sreg <= 16'h25_33;  // AGC lower limit
      65: sreg <= 16'h26_e3;  // AGC/AEC fast mode op region
      66: sreg <= 16'h9f_78;  // HAECC1
      67: sreg <= 16'ha0_68;  // HAECC2
      68: sreg <= 16'ha1_03;  // magic
      69: sreg <= 16'ha6_d8;  // HAECC3
      70: sreg <= 16'ha7_d8;  // HAECC4
      71: sreg <= 16'ha8_f0;  // HAECC5
      72: sreg <= 16'ha9_90;  // HAECC6
      73: sreg <= 16'haa_94;  // HAECC7
      74: sreg <= 16'h13_a7;  // COM8, enable AGC / AEC
      75: sreg <= 16'h69_06; 
    default : begin
      sreg <= 16'hffff;
    end
    endcase
  end

endmodule
