# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7z020clg484-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir /media/nguyenvietthi/DATA/camera_to_vga/fpga/cam2vga/cam2vga.cache/wt [current_project]
set_property parent.project_path /media/nguyenvietthi/DATA/camera_to_vga/fpga/cam2vga/cam2vga.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part em.avnet.com:zed:part0:1.4 [current_project]
set_property ip_output_repo /media/nguyenvietthi/DATA/camera_to_vga/fpga/cam2vga/cam2vga.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  /media/nguyenvietthi/DATA/camera_to_vga/rtl/debounce.v
  /media/nguyenvietthi/DATA/camera_to_vga/rtl/i2c_sender.v
  /media/nguyenvietthi/DATA/camera_to_vga/rtl/ov7670_capture.v
  /media/nguyenvietthi/DATA/camera_to_vga/rtl/ov7670_controller.v
  /media/nguyenvietthi/DATA/camera_to_vga/rtl/ov7670_registers.v
  /media/nguyenvietthi/DATA/camera_to_vga/rtl/vga.v
  /media/nguyenvietthi/DATA/camera_to_vga/rtl/ov7670_top.v
}
read_ip -quiet /media/nguyenvietthi/DATA/camera_to_vga/fpga/cam2vga/cam2vga.srcs/sources_1/ip/clk_wiz/clk_wiz.xci
set_property used_in_implementation false [get_files -all /media/nguyenvietthi/DATA/camera_to_vga/fpga/cam2vga/cam2vga.srcs/sources_1/ip/clk_wiz/clk_wiz_board.xdc]
set_property used_in_implementation false [get_files -all /media/nguyenvietthi/DATA/camera_to_vga/fpga/cam2vga/cam2vga.srcs/sources_1/ip/clk_wiz/clk_wiz.xdc]
set_property used_in_implementation false [get_files -all /media/nguyenvietthi/DATA/camera_to_vga/fpga/cam2vga/cam2vga.srcs/sources_1/ip/clk_wiz/clk_wiz_ooc.xdc]

read_ip -quiet /media/nguyenvietthi/DATA/camera_to_vga/fpga/cam2vga/cam2vga.srcs/sources_1/ip/blk_mem_gen/blk_mem_gen.xci
set_property used_in_implementation false [get_files -all /media/nguyenvietthi/DATA/camera_to_vga/fpga/cam2vga/cam2vga.srcs/sources_1/ip/blk_mem_gen/blk_mem_gen_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc /media/nguyenvietthi/DATA/camera_to_vga/fpga/cam2vga.xdc
set_property used_in_implementation false [get_files /media/nguyenvietthi/DATA/camera_to_vga/fpga/cam2vga.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
set_param ips.enableIPCacheLiteLoad 0
close [open __synthesis_is_running__ w]

synth_design -top ov7670_top -part xc7z020clg484-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef ov7670_top.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file ov7670_top_utilization_synth.rpt -pb ov7670_top_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
