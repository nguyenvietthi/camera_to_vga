module vga(
  input  wire        clk25      ,
  output reg  [3:0]  vga_red    ,
  output reg  [3:0]  vga_green  ,
  output reg  [3:0]  vga_blue   ,
  output reg         vga_hsync  ,
  output reg         vga_vsync  ,
  output wire [18:0] frame_addr ,
  input  wire [11:0] frame_pixel
);

  // Timing constants
  parameter hRez = 640;
  parameter hStartSync = 640 + 16;
  parameter hEndSync = 640 + 16 + 96;
  parameter hMaxCount = 800;
  parameter vRez = 480;
  parameter vStartSync = 480 + 10;
  parameter vEndSync = 480 + 10 + 2;
  parameter vMaxCount = 480 + 10 + 2 + 33;
  parameter hsync_active = 1'b0;
  parameter vsync_active = 1'b0;

  reg [9:0]  hCounter = 'b0;
  reg [9:0]  vCounter = 'b0;
  reg [18:0] address  = 'b0;
  reg        blank    = 'b1;

  assign frame_addr = address;
  always @(posedge clk25) begin
    // Count the lines and rows      
    if(hCounter == (hMaxCount - 1)) begin
      hCounter <= {10{1'b0}};
      if(vCounter == (vMaxCount - 1)) begin
        vCounter <= {10{1'b0}};
      end
      else begin
        vCounter <= vCounter + 1;
      end
    end
    else begin
      hCounter <= hCounter + 1;
    end
    if(blank == 1'b0) begin
      vga_red <= frame_pixel[11:8];
      vga_green <= frame_pixel[7:4];
      vga_blue <= frame_pixel[3:0];
    end
    else begin
      vga_red <= {4{1'b0}};
      vga_green <= {4{1'b0}};
      vga_blue <= {4{1'b0}};
    end
    if(vCounter >= vRez) begin
      address <= {19{1'b0}};
      blank <= 1'b1;
    end
    else begin
      if(hCounter < 640) begin
        blank <= 1'b0;
        address <= address + 1;
      end
      else begin
        blank <= 1'b1;
      end
    end
    // Are we in the hSync pulse? (one has been added to include frame_buffer_latency)
    if(hCounter > hStartSync && hCounter <= hEndSync) begin
      vga_hsync <= hsync_active;
    end
    else begin
      vga_hsync <=  ~hsync_active;
    end
    // Are we in the vSync pulse?
    if(vCounter >= vStartSync && vCounter < vEndSync) begin
      vga_vsync <= vsync_active;
    end
    else begin
      vga_vsync <=  ~vsync_active;
    end
  end

endmodule
