transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {top_8_1200mv_85c_slow.vo}

vlog -vlog01compat -work work +incdir+C:/Users/K/OneDrive\ -\ stu.jluzh.edu.cn/by-health/program/raspi_ds2413/altera/virtualDs2431/testbench {C:/Users/K/OneDrive - stu.jluzh.edu.cn/by-health/program/raspi_ds2413/altera/virtualDs2431/testbench/VirtualDS2431_IO_tb.v}

vsim -t 1ps +transport_int_delays +transport_path_delays -L altera_ver -L cycloneive_ver -L gate_work -L work -voptargs="+acc"  VirtualDS2431_IO_tb

add wave *
view structure
view signals
run -all
