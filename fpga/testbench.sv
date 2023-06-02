`timescale 1ns/1ps
module cam2vga_tb;

	logic       clk100 = 0      ;
	logic       OV7670_SIOC     ;
	// logic       OV7670_SIOD     ;
	logic       OV7670_RESET    ;
	logic       OV7670_PWDN     ;
	logic       OV7670_VSYNC = 0;
	logic       OV7670_HREF  = 0;
	logic       OV7670_PCLK  = 0;
	logic       OV7670_XCLK     ;
	logic [7:0] OV7670_D        ;
	logic [7:0] LED             ;
	logic [3:0] vga_red         ;
	logic [3:0] vga_green       ;
	logic [3:0] vga_blue        ;
	logic       vga_hsync       ;
	logic       vga_vsync       ;
	logic       btn         =0  ;

  // Period (ns) and frequency (Hz) of FPGA clock
  localparam T_SYS_CLK = 10;
  localparam F_SYS_CLK = 100_000_000;

  // Period (ns) and frequency (Hz) of PCLK
  localparam T_P_CLK = 41.667;
  localparam F_P_CLK = 24_000_000;

  // Number of clocks for btn debounce
  localparam DELAY = 10; 
  
  // VGA Frame Timing 
  localparam nFrames = 2,
              nRows   = 640,
              nPixelsPerRow = 480;  


  ov7670_top ov7670_top_inst (
		.clk100      (clk100      ),
		.OV7670_SIOC (OV7670_SIOC ),
		// .OV7670_SIOD (OV7670_SIOD ),
		.OV7670_RESET(OV7670_RESET),
		.OV7670_PWDN (OV7670_PWDN ),
		.OV7670_VSYNC(OV7670_VSYNC),
		.OV7670_HREF (OV7670_HREF ),
		.OV7670_PCLK (OV7670_PCLK ),
		.OV7670_XCLK (OV7670_XCLK ),
		.OV7670_D    (OV7670_D    ),
		.LED         (LED         ),
		.vga_red     (vga_red     ),
		.vga_green   (vga_green   ),
		.vga_blue    (vga_blue    ),
		.vga_hsync   (vga_hsync   ),
		.vga_vsync   (vga_vsync   ),
		.btn         (btn         )
  );

  logic [11:0] pixel_data_queue [$];
  logic [11:0] BRAM_data [$];
  logic [11:0] first_pixel_byte;
  logic  [11:0] remove_last_byte; 

  // Create Clocks
  always #(T_SYS_CLK/2) clk100 = ~clk100; 
  always #(T_P_CLK/2)   OV7670_PCLK= ~OV7670_PCLK; 

  initial begin 
    for(int frame = 0; frame < nFrames; frame=frame+1) begin
     // Start frame to start sending pixel data to BRAM
    OV7670_VSYNC = 1'b1; 
    repeat(3*784*2) @(posedge OV7670_PCLK);
    OV7670_VSYNC = 0; 
    repeat(17*784*2) @(posedge OV7670_PCLK); 
     
     for(int row = 1; row < nRows+1; row=row+1)
     begin
     for(int pix_byte = 0; pix_byte < (2*nPixelsPerRow); pix_byte=pix_byte+1)
         begin
             @(negedge OV7670_PCLK)
             begin
                 if(pix_byte == 0)                         
                     OV7670_HREF = 1'b1;
                 
                 // First byte
                 if(pix_byte % 2 == 0)                       
                 begin
                     first_pixel_byte = { $urandom() % 4096 }; //row*(pix_byte/2); 
                     OV7670_D   = { 4'hF , first_pixel_byte[11:8] };
                 end
                 // Second byte, add to queue for testing 
                 else
                 begin
                     OV7670_D = first_pixel_byte[7:0];         //{ $urandom() % 256 };              
                     pixel_data_queue.push_front(first_pixel_byte);  // { first_pixel_byte[3:0] , OV7670_D });
                     BRAM_data.push_front(first_pixel_byte);         //{first_pixel_byte[3:0] , OV7670_D } ); 
                 end
             end       
               
         end 
         // Invalid Data region (before next row)
         @(negedge OV7670_PCLK) OV7670_HREF = 0;
         repeat(144*2) @(posedge OV7670_PCLK); 
     end 
     
     // Remove last data (at address 307200 -> invalid)
     remove_last_byte = BRAM_data.pop_front(); 
                 
     // Last row -> end of frame
     OV7670_VSYNC = 0; 
     repeat(10*784*2) @(negedge OV7670_PCLK); 
     
     // Pad for next frame 
     BRAM_data.push_front( {12'h000} );
     BRAM_data.push_front( {12'h000} );
     
     // Finish sim
     if(frame == nFrames - 1)
     begin                
         $display("SUCCESS!\n");
         $finish();    
     end    
  end 
  end
endmodule
