-makelib xcelium_lib/xil_defaultlib -sv \
  "/media/nguyenvietthi/DATA/linux_tools/Xilinx/Vivado/2018.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "/media/nguyenvietthi/DATA/linux_tools/Xilinx/Vivado/2018.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "/media/nguyenvietthi/DATA/linux_tools/Xilinx/Vivado/2018.1/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../cam2vga.srcs/sources_1/ip/clk_wiz/clk_wiz_clk_wiz.v" \
  "../../../../cam2vga.srcs/sources_1/ip/clk_wiz/clk_wiz.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

