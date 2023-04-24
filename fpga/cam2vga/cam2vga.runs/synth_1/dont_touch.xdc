# This file is automatically generated.
# It contains project source information necessary for synthesis and implementation.

# XDC: /media/nguyenvietthi/DATA/camera_to_vga/fpga/cam2vga.xdc

# IP: ip/clk_wiz/clk_wiz.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==clk_wiz || ORIG_REF_NAME==clk_wiz} -quiet] -quiet

# IP: ip/blk_mem_gen/blk_mem_gen.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==blk_mem_gen || ORIG_REF_NAME==blk_mem_gen} -quiet] -quiet

# XDC: ip/clk_wiz/clk_wiz_board.xdc
set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==clk_wiz || ORIG_REF_NAME==clk_wiz} -quiet] {/inst } ]/inst ] -quiet] -quiet

# XDC: ip/clk_wiz/clk_wiz.xdc
#dup# set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==clk_wiz || ORIG_REF_NAME==clk_wiz} -quiet] {/inst } ]/inst ] -quiet] -quiet

# XDC: ip/clk_wiz/clk_wiz_ooc.xdc

# XDC: ip/blk_mem_gen/blk_mem_gen_ooc.xdc