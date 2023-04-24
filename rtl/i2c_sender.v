module i2c_sender(
  input  wire       clk     ,
  inout             siod    ,
  output reg        sioc    ,
  output reg        taken   ,
  input  wire       send    ,
  input  wire [7:0] id      ,
  input  wire [7:0] register,
  input  wire [7:0] value   
);

  reg [7:0]  divider = 8'b00000001;  // this value gives a 254 cycle pause before the initial frame is sent
  reg [31:0] busy_sr = 'b0;
  reg [31:0] data_sr = 'b1;

  // always @(busy_sr, data_sr[31]) begin
  //   if(busy_sr[11:10] == 2'b10 || busy_sr[20:19] == 2'b10 || busy_sr[29:28] == 2'b10) begin
  //     siod = 1'bZ;
  //   end
  //   else begin
  //     siod = data_sr[31];
  //   end
  // end\
  assign siod = (busy_sr[11:10] == 2'b10 || busy_sr[20:19] == 2'b10 || busy_sr[29:28] == 2'b10) ? 1'bz : data_sr[31];

  always @(posedge clk) begin
    // taken <= 1'b0;
    if(busy_sr[31] == 1'b0) begin
      sioc <= 1'b1;
      if(send == 1'b1) begin
        if(divider == 8'b00000000) begin
          data_sr <= {3'b100, id, 1'b0, register, 1'b0, value, 1'b0, 2'b01};
          busy_sr <= {3'b111, 9'b111111111, 9'b111111111, 9'b111111111, 2'b11};
          taken <= 1'b1;
        end
        else begin
          divider <= divider + 1;
          taken   <= 1'b0;
          // this only happens on powerup
        end
      end
    end
    else begin
      taken   <= 1'b0;
      case({busy_sr[32 - 1:32 - 3], busy_sr[2:0]})
      6'b111_111 : begin
        // start seq #1
        case(divider[7:6])
        2'b00 : begin
          sioc <= 1'b1;
        end
        2'b01 : begin
          sioc <= 1'b1;
        end
        2'b10 : begin
          sioc <= 1'b1;
        end
        default : begin
          sioc <= 1'b1;
        end
        endcase
      end
      6'b111_110: begin
        // start seq #2
        case(divider[7:6])
        2'b00 : begin
          sioc <= 1'b1;
        end
        2'b01 : begin
          sioc <= 1'b1;
        end
        2'b10 : begin
          sioc <= 1'b1;
        end
        default : begin
          sioc <= 1'b1;
        end
        endcase
      end
      6'b111_100: begin
        // start seq #3
        case(divider[7:6])
        2'b00 : begin
          sioc <= 1'b0;
        end
        2'b01 : begin
          sioc <= 1'b0;
        end
        2'b10 : begin
          sioc <= 1'b0;
        end
        default : begin
          sioc <= 1'b0;
        end
        endcase
      end
      6'b110_000: begin
        // end seq #1
        case(divider[7:6])
        2'b00 : begin
          sioc <= 1'b0;
        end
        2'b01 : begin
          sioc <= 1'b1;
        end
        2'b10 : begin
          sioc <= 1'b1;
        end
        default : begin
          sioc <= 1'b1;
        end
        endcase
      end
      6'b100_000: begin
        // end seq #2
        case(divider[7:6])
        2'b00 : begin
          sioc <= 1'b1;
        end
        2'b01 : begin
          sioc <= 1'b1;
        end
        2'b10 : begin
          sioc <= 1'b1;
        end
        default : begin
          sioc <= 1'b1;
        end
        endcase
      end
      6'b000_000: begin
        // Idle
        case(divider[7:6])
        2'b00 : begin
          sioc <= 1'b1;
        end
        2'b01 : begin
          sioc <= 1'b1;
        end
        2'b10 : begin
          sioc <= 1'b1;
        end
        default : begin
          sioc <= 1'b1;
        end
        endcase
      end
      default : begin
        case(divider[7:6])
        2'b00 : begin
          sioc <= 1'b0;
        end
        2'b01 : begin
          sioc <= 1'b1;
        end
        2'b10 : begin
          sioc <= 1'b1;
        end
        default : begin
          sioc <= 1'b0;
        end
        endcase
      end
      endcase
      if(divider == 8'b11111111) begin
        busy_sr <= {busy_sr[32 - 2:0],1'b0};
        data_sr <= {data_sr[32 - 2:0],1'b1};
        divider <= {8{1'b0}};
      end
      else begin
        divider <= divider + 1;
      end
    end
  end


endmodule
