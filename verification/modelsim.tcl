if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}

# -----------------------------------------------------------------
# Design paths
# -----------------------------------------------------------------

echo " * Setup paths"
set verification [pwd]
set design $verification/../fpga
set src  $design/src
set tb   $design/tb

# -----------------------------------------------------------------
# Setup the Modelsim work folder
# -----------------------------------------------------------------

echo " * Setup Modelsim work"
vlib rtl_work
vmap work rtl_work

# -----------------------------------------------------------------
# Build the code
# -----------------------------------------------------------------

echo " * Build the source"
vcom -93 -work work $src/BCD_7_segment.vhd
vcom -93 -work work $tb/tb_BCD_7_segment.vhd

# -----------------------------------------------------------------
# Testbench procedures
# -----------------------------------------------------------------

proc tb_BCD_7_segment {} {
	global verification
    vsim tb_BCD_7_segment
	do $verification/tb_BCD_7_segment.do
	run -a
}
