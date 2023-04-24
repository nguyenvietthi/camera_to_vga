module ov7670_top(
  input  wire       clk100      ,
  output wire       OV7670_SIOC ,
  inout  wire       OV7670_SIOD ,
  output wire       OV7670_RESET,
  output wire       OV7670_PWDN ,
  input  wire       OV7670_VSYNC,
  input  wire       OV7670_HREF ,
  input  wire       OV7670_PCLK ,
  output wire       OV7670_XCLK ,
  input  wire [7:0] OV7670_D    ,
  output reg  [7:0] LED         ,
  output wire [3:0] vga_red     ,
  output wire [3:0] vga_green   ,
  output wire [3:0] vga_blue    ,
  output wire       vga_hsync   ,
  output wire       vga_vsync   ,
  input  wire       btn         
);

  wire [18:0] frame_addr;
  wire [11:0] frame_pixel;
  wire [18:0] capture_addr;
  wire [11:0] capture_data;
  wire        capture_we;
  wire        resend;
  wire        config_finished;
  wire        clk_feedback;
  wire        clk50;
  wire        clk25;
  wire        buffered_pclk;

  debounce debounce_inst(
    .clk(clk50 ),
    .i  (btn   ),
    .o  (resend)
  );

  vga vga_inst(
    .clk25      (clk25      ),
    .vga_red    (vga_red    ),
    .vga_green  (vga_green  ),
    .vga_blue   (vga_blue   ),
    .vga_hsync  (vga_hsync  ),
    .vga_vsync  (vga_vsync  ),
    .frame_addr (frame_addr ),
    .frame_pixel(frame_pixel)
  );

  blk_mem_gen blk_mem_gen_inst(
    .clka (OV7670_PCLK ),
    .wea  (capture_we  ),
    .addra(capture_addr),
    .dina (capture_data),
    .clkb (clk50       ),
    .addrb(frame_addr  ),
    .doutb(frame_pixel )
  );

  always @(config_finished) begin
    if(config_finished) begin
      LED = 8'b00000000;
    end else begin
      LED = 8'b11111111;
    end
  end

  ov7670_capture ov7670_capture_inst(
    .pclk (OV7670_PCLK ),
    .vsync(OV7670_VSYNC),
    .href (OV7670_HREF ),
    .d    (OV7670_D    ),
    .addr (capture_addr),
    .dout (capture_data),
    .we   (capture_we  )
  );

  ov7670_controller ov7670_controller_inst(
    .clk            (clk50          ),
    .sioc           (OV7670_SIOC    ),
    .resend         (resend         ),
    .config_finished(config_finished),
    .siod           (OV7670_SIOD    ),
    .pwdn           (OV7670_PWDN    ),
    .reset          (OV7670_RESET   ),
    .xclk           (OV7670_XCLK    )
  );

  clk_wiz clk_wiz_inst(
    .CLK_100(clk100),
    .CLK_50 (clk50 ),
    .CLK_25 (clk25 )
  );


endmodule
