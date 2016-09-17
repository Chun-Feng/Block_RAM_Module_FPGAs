#!/bin/tcsh

source /fpga/xilinx.cshrc
source /usr/cad/env.cshrc

ncverilog \
              -y $XILINX/verilog/src/unisims \
              -y $XILINX/verilog/src/XilinxCoreLib \
              +incdir+$XILINX/verilog/src \
              +libext+.v \
              $XILINX/verilog/src/glbl.v \
              ./blk_mem_gen_v7_2.v \
              ./TESTBENCH.v +define+RTL +access+rw +notimingchecks

rm -r INCA_libs

