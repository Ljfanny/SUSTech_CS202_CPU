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
create_project -in_memory -part xc7a100tfgg484-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir D:/LearningMaterial/sophomore_second/计组/SUSTech_CS202_CPU/CPU/CPU.cache/wt [current_project]
set_property parent.project_path D:/LearningMaterial/sophomore_second/计组/SUSTech_CS202_CPU/CPU/CPU.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_repo_paths d:/LearningMaterial/sophomore_second/计组/SUSTech_CS202_CPU/SEU_CSE_507_user_uart_bmpg_1.3 [current_project]
set_property ip_output_repo d:/LearningMaterial/sophomore_second/计组/SUSTech_CS202_CPU/CPU/CPU.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files D:/LearningMaterial/sophomore_second/计组/SUSTech_CS202_CPU/CPU/CPU.srcs/sources_1/ip/RAM/dmem32.coe
add_files D:/LearningMaterial/sophomore_second/计组/SUSTech_CS202_CPU/CPU/CPU.srcs/sources_1/ip/prgrom/prgmip32.coe
read_verilog -library xil_defaultlib {
  D:/LearningMaterial/sophomore_second/计组/SUSTech_CS202_CPU/CPU/CPU.srcs/sources_1/new/ButtonMistaken.v
  D:/LearningMaterial/sophomore_second/计组/SUSTech_CS202_CPU/CPU/CPU.srcs/sources_1/new/Buttons.v
  D:/LearningMaterial/sophomore_second/计组/SUSTech_CS202_CPU/CPU/CPU.srcs/sources_1/new/Control32.v
  D:/LearningMaterial/sophomore_second/计组/SUSTech_CS202_CPU/CPU/CPU.srcs/sources_1/new/Counter.v
  D:/LearningMaterial/sophomore_second/计组/SUSTech_CS202_CPU/CPU/CPU.srcs/sources_1/new/Decode32.v
  D:/LearningMaterial/sophomore_second/计组/SUSTech_CS202_CPU/CPU/CPU.srcs/sources_1/new/Executs32.v
  D:/LearningMaterial/sophomore_second/计组/SUSTech_CS202_CPU/CPU/CPU.srcs/sources_1/new/IOread.v
  D:/LearningMaterial/sophomore_second/计组/SUSTech_CS202_CPU/CPU/CPU.srcs/sources_1/new/Ifetch32.v
  D:/LearningMaterial/sophomore_second/计组/SUSTech_CS202_CPU/CPU/CPU.srcs/sources_1/new/Leds.v
  D:/LearningMaterial/sophomore_second/计组/SUSTech_CS202_CPU/CPU/CPU.srcs/sources_1/new/MemOrIO.v
  D:/LearningMaterial/sophomore_second/计组/SUSTech_CS202_CPU/CPU/CPU.srcs/sources_1/new/dmemory32.v
  D:/LearningMaterial/sophomore_second/计组/SUSTech_CS202_CPU/CPU/CPU.srcs/sources_1/new/Top.v
}
read_ip -quiet D:/LearningMaterial/sophomore_second/计组/SUSTech_CS202_CPU/CPU/CPU.srcs/sources_1/ip/cpu_clk/cpu_clk.xci
set_property used_in_implementation false [get_files -all d:/LearningMaterial/sophomore_second/计组/SUSTech_CS202_CPU/CPU/CPU.srcs/sources_1/ip/cpu_clk/cpu_clk_board.xdc]
set_property used_in_implementation false [get_files -all d:/LearningMaterial/sophomore_second/计组/SUSTech_CS202_CPU/CPU/CPU.srcs/sources_1/ip/cpu_clk/cpu_clk.xdc]
set_property used_in_implementation false [get_files -all d:/LearningMaterial/sophomore_second/计组/SUSTech_CS202_CPU/CPU/CPU.srcs/sources_1/ip/cpu_clk/cpu_clk_ooc.xdc]

read_ip -quiet D:/LearningMaterial/sophomore_second/计组/SUSTech_CS202_CPU/CPU/CPU.srcs/sources_1/ip/RAM/RAM.xci
set_property used_in_implementation false [get_files -all d:/LearningMaterial/sophomore_second/计组/SUSTech_CS202_CPU/CPU/CPU.srcs/sources_1/ip/RAM/RAM_ooc.xdc]

read_ip -quiet D:/LearningMaterial/sophomore_second/计组/SUSTech_CS202_CPU/CPU/CPU.srcs/sources_1/ip/prgrom/prgrom.xci
set_property used_in_implementation false [get_files -all d:/LearningMaterial/sophomore_second/计组/SUSTech_CS202_CPU/CPU/CPU.srcs/sources_1/ip/prgrom/prgrom_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc D:/LearningMaterial/sophomore_second/计组/SUSTech_CS202_CPU/CPU/CPU.srcs/constrs_1/new/cpu.xdc
set_property used_in_implementation false [get_files D:/LearningMaterial/sophomore_second/计组/SUSTech_CS202_CPU/CPU/CPU.srcs/constrs_1/new/cpu.xdc]


synth_design -top Top -part xc7a100tfgg484-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef Top.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file Top_utilization_synth.rpt -pb Top_utilization_synth.pb"
