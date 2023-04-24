module ov7670_controller(
  input  wire clk            ,
  input  wire resend         ,
  output wire config_finished,
  output wire sioc           ,
  inout  wire siod           ,
  output wire reset          ,
  output wire pwdn           ,
  output wire xclk           
);
  parameter camera_address = 8'h42;  // 42"; -- Device write ID - see top of page 11 of data sheet

  reg sys_clk = 'b0;
  wire [15:0] command;
  wire finished;
  wire taken;
  wire send;

  assign config_finished = finished;
  assign send =  ~finished;

  i2c_sender i2c_sender_inst(
    .clk     (clk           ),
    .taken   (taken         ),
    .siod    (siod          ),
    .sioc    (sioc          ),
    .send    (send          ),
    .id      (camera_address),
    .register(command[15:8] ),
    .value   (command[7:0]  )
  );

  assign reset = 1'b1;
  // Normal mode
  assign pwdn = 1'b0;
  // Power device up
  assign xclk = sys_clk;
  
  ov7670_registers ov7670_registers_inst(
    .clk     (clk     ),
    .advance (taken   ),
    .command (command ),
    .finished(finished),
    .resend  (resend  )
  );

  always @(posedge clk) begin
    sys_clk <=  ~sys_clk;
  end

endmodule
