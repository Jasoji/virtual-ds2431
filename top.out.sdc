## Generated SDC file "top.out.sdc"

## Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, the Altera Quartus II License Agreement,
## the Altera MegaCore Function License Agreement, or other 
## applicable license agreement, including, without limitation, 
## that your use is for the sole purpose of programming logic 
## devices manufactured by Altera and sold by Altera or its 
## authorized distributors.  Please refer to the applicable 
## agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 15.0.0 Build 145 04/22/2015 SJ Full Version"

## DATE    "Sun Sep 20 15:19:41 2020"

##
## DEVICE  "EP4CE10F17C8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|usClk} -period 1000.000 -waveform { 0.000 500.000 } [get_registers { VirtualDS2431:vds1|VirtualDS2431_IO:dsio|usClk }]
create_clock -name {clk} -period 20.000 -waveform { 0.000 10.000 } [get_ports { clk }]
create_clock -name {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|posPulse:io1|q} -period 20.000 -waveform { 0.000 10.000 } [get_registers { VirtualDS2431:vds1|VirtualDS2431_IO:dsio|posPulse:io1|q }]
create_clock -name {VirtualDS2431:vds1|VirtualDS2431_main:main|writeToMemory} -period 20.000 -waveform { 0.000 10.000 } [get_registers { VirtualDS2431:vds1|VirtualDS2431_main:main|writeToMemory }]
create_clock -name {VirtualDS2431:vds2|VirtualDS2431_IO:dsio|posPulse:io1|q} -period 20.000 -waveform { 0.000 10.000 } [get_registers {VirtualDS2431:vds2|VirtualDS2431_IO:dsio|posPulse:io1|q}]
create_clock -name {VirtualDS2431:vds2|VirtualDS2431_IO:dsio|posPulse:trig1|q} -period 10.000 -waveform { 0.000 5.000 } [get_registers {VirtualDS2431:vds2|VirtualDS2431_IO:dsio|posPulse:trig1|q}]
create_clock -name {VirtualDS2431:vds2|VirtualDS2431_IO:dsio|usClk} -period 1000.000 -waveform { 0.000 500.000 } [get_registers {VirtualDS2431:vds2|VirtualDS2431_IO:dsio|usClk}]
create_clock -name {VirtualDS2431:vds2|VirtualDS2431_main:main|writeToMemory} -period 20.000 -waveform { 0.000 10.000 } [get_registers {VirtualDS2431:vds2|VirtualDS2431_main:main|writeToMemory}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {VirtualDS2431:vds1|VirtualDS2431_main:main|writeToMemory}] -rise_to [get_clocks {VirtualDS2431:vds1|VirtualDS2431_main:main|writeToMemory}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {VirtualDS2431:vds1|VirtualDS2431_main:main|writeToMemory}] -fall_to [get_clocks {VirtualDS2431:vds1|VirtualDS2431_main:main|writeToMemory}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {VirtualDS2431:vds1|VirtualDS2431_main:main|writeToMemory}] -rise_to [get_clocks {clk}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {VirtualDS2431:vds1|VirtualDS2431_main:main|writeToMemory}] -fall_to [get_clocks {clk}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {VirtualDS2431:vds1|VirtualDS2431_main:main|writeToMemory}] -rise_to [get_clocks {VirtualDS2431:vds1|VirtualDS2431_main:main|writeToMemory}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {VirtualDS2431:vds1|VirtualDS2431_main:main|writeToMemory}] -fall_to [get_clocks {VirtualDS2431:vds1|VirtualDS2431_main:main|writeToMemory}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {VirtualDS2431:vds1|VirtualDS2431_main:main|writeToMemory}] -rise_to [get_clocks {clk}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {VirtualDS2431:vds1|VirtualDS2431_main:main|writeToMemory}] -fall_to [get_clocks {clk}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|posPulse:io1|q}] -rise_to [get_clocks {VirtualDS2431:vds1|VirtualDS2431_main:main|writeToMemory}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|posPulse:io1|q}] -fall_to [get_clocks {VirtualDS2431:vds1|VirtualDS2431_main:main|writeToMemory}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|posPulse:io1|q}] -rise_to [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|usClk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|posPulse:io1|q}] -fall_to [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|usClk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|posPulse:io1|q}] -rise_to [get_clocks {clk}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|posPulse:io1|q}] -fall_to [get_clocks {clk}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|posPulse:io1|q}] -rise_to [get_clocks {VirtualDS2431:vds1|VirtualDS2431_main:main|writeToMemory}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|posPulse:io1|q}] -fall_to [get_clocks {VirtualDS2431:vds1|VirtualDS2431_main:main|writeToMemory}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|posPulse:io1|q}] -rise_to [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|usClk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|posPulse:io1|q}] -fall_to [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|usClk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|posPulse:io1|q}] -rise_to [get_clocks {clk}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|posPulse:io1|q}] -fall_to [get_clocks {clk}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|usClk}] -rise_to [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|posPulse:io1|q}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|usClk}] -fall_to [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|posPulse:io1|q}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|usClk}] -rise_to [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|usClk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|usClk}] -fall_to [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|usClk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|usClk}] -rise_to [get_clocks {clk}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|usClk}] -fall_to [get_clocks {clk}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|usClk}] -rise_to [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|posPulse:io1|q}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|usClk}] -fall_to [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|posPulse:io1|q}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|usClk}] -rise_to [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|usClk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|usClk}] -fall_to [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|usClk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|usClk}] -rise_to [get_clocks {clk}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|usClk}] -fall_to [get_clocks {clk}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {VirtualDS2431:vds1|VirtualDS2431_main:main|writeToMemory}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {VirtualDS2431:vds1|VirtualDS2431_main:main|writeToMemory}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|posPulse:io1|q}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|posPulse:io1|q}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|usClk}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|usClk}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {VirtualDS2431:vds1|VirtualDS2431_main:main|writeToMemory}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {VirtualDS2431:vds1|VirtualDS2431_main:main|writeToMemory}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|posPulse:io1|q}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|posPulse:io1|q}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|usClk}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {VirtualDS2431:vds1|VirtualDS2431_IO:dsio|usClk}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {clk}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

