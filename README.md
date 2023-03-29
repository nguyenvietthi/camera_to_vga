# camera_to_vga
This project implements a real-time streaming of OV7670 camera via VGA. The OV7670 is a 0.3 Megapixel camera(640x480) with 30 fps. Data pixels are stored to and retrieved from SDRAM with burst mode set to "full page"(512 words).


về cơ bản:
- CAMERA: Mỗi frame xác định bằng 2 VSYNC. data 1 row (HREF) mỗi HREF HIGHT có 640x2 cycle trong dó mỗi pixel RGB biểu diễn 2 byte
          Config bằng I2C (1 FSM)
          Lấy dữ liệu từng pixel đưa vào RAM - 2 byte (1 FSM)
          Tằng giảm độ sáng (brightness), độ tương phản (contrast) bằng 4 phím bấm

          Chạy tần số 24 MHz
          Cần Async_fifo để sync data

          OK
