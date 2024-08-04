#!/bin/bash

# usage: addenv env_name path
function addenv() {
	sed -i -e "/^export $1=.*/d" ~/.bashrc
	echo "export $1=`readlink -f $2`" >> ~/.bashrc
	echo "By default this script will add environment variables into ~/.bashrc."
	echo "After that, please run 'source ~/.bashrc' to let these variables take effect."
	echo "If you use shell other than bash, please add these environment variables manually."
}


# 解析输入的参数
# bash ysyx-env.sh [options]
case $1 in
	init)
		if [ -d ysyx-workbench ]; then
			echo "ysyx-workbench is already initialized, skipping..."
		fi
		while [ ! -d ysyx-workbench ]; do
			git clone -b npc-O3 git@github.com:xjn-La-La-land/ysyx-workbench.git
		done
		addenv NEMU_HOME ysyx-workbench/nemu
		addenv NPC_HOME  ysyx-workbench/npc
		addenv SOC_HOME  ysyx-workbench/ysyxSoC
		addenv AM_HOME   ysyx-workbench/abstract-machine
		addenv NVBOARD_HOME ysyx-workbench/nvboard

		if [ -d rt-thread-am ]; then
			echo "rt-thread-am is already initialized, skipping..."
		fi
		while [ ! -d rt-thread-am ]; do
			git clone -b ysyx-rtt git@github.com:xjn-La-La-land/rt-thread-am.git
		done
		addenv RT_HOME rt-thread-am/bsp/abstract-machine
		;;
	snake)
		cd $NPC_HOME/../am-kernels/kernels/snake
		make ARCH=riscv32-npcsoc run
		;;
	rtt)
		cd $RT_HOME
		make init
		make ARCH=riscv32-npcsoc run
		;;
	cpu-test)
		cd $NPC_HOME/../am-kernels/tests/cpu-tests
		make ARCH=riscv32-npcsoc run
		;;
	microbench)
		cd $NPC_HOME/../am-kernels/benchmarks/microbench
		make ARCH=riscv32-npcsoc run mainargs=train
		;;
	*)
		echo "Invalid input..."
		exit
		;;
esac

