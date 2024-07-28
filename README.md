# 复现 `ysyx` 运行环境，并且运行一些测试



1. 首先需要安装 `verilator` 和 `mill`

   ```bash
   git clone git@github.com:verilator/verilator.git # 从Github安装verilator
   cd verilator
   git checkout v5.008 # 控制版本为5.008
   autoconf            # Create ./configure script
   ./configure         # Configure and create Makefile
   make -j `nproc`     # Build Verilator itself (if error, try just 'make')
   sudo make install
   ```

   ```bash
   sh -c "curl -L https://github.com/com-lihaoyi/mill/releases/download/0.11.10/0.11.10 > /usr/local/bin/mill" # 从 Github 下载 mill
   sudo chmod +x /usr/local/bin/mill
   mill -v             # 检查是否安装成功
   ```

2. 下载 `ysyx-env.sh` 脚本

   ```bash
   git clone git@github.com:xjn-La-La-land/ysyx-setup.git
   ```

3. 运行脚本来下载实验代码

    ```bash
    bash ysyx-env.sh init # 下载 nemu, npc, ysyxSoC, abstarct-machine, am-kernels 和 RT-thread
    
    # 具体运行的命令如下：
    git clone -b ysyx-final git@github.com:xjn-La-La-land/ysyx-workbench.git # 下载 ysyx-workbench 中的内容
    git clone -b ysyx-rtt git@github.com:xjn-La-La-land/rt-thread-am.git     # 下载 rt-thread 中的内容
    ```

4. `npc` 运行 RT-thread 操作系统，可以在 `nvboard` 终端中输入命令并运行。

   ```bash
   bash ysyx-env.sh rtt
   
   # 具体运行的命令如下：
   cd $RT_HOME
   make ARCH=riscv32-npcsoc run
   ```

5. `npc` 运行 snake(贪吃蛇小游戏)，在 `nvboard` 的 vga 面板上显示，可以通过键盘上下左右键控制蛇的移动。

   ```bash
   bash ysyx-env.sh snake
   
   # 具体运行的命令如下:
   cd $NPC_HOME/../am-kernels/tests/cpu-tests
   make ARCH=riscv32-npcsoc run
   ```

6. `npc` 运行 microbench 的 train 测试集，大概需要 10 min 左右跑完。

   ```bash
   bash ysyx-env.sh microbench
   
   # 具体运行的命令如下:
   cd $NPC_HOME/../am-kernels/benchmarks/microbench
   make ARCH=riscv32-npcsoc run mainargs=train
   ```

7. `npc` 运行 cpu-test 小程序

   ```bash
   bash ysyx-env.sh cpu-test
   
   # 具体运行的命令如下:
   cd $NPC_HOME/../am-kernels/tests/cpu-tests
   make ARCH=riscv32-npcsoc run
   ```

8. `nemu` 运行 RT-thread 操作系统，不过 nemu 在 SoC 版本下没有支持 `nvboard`，uart 也没有实现接收输入功能，所以不能在终端输入命令。

   ```bash
   # 首先需要将 ysyx-workbench/abstract-machine/am/src/riscv/npcsoc/trm.c 中的 welcome_home() 函数修改一下：
   # 将 “在 NVBoard 的数码管上显示学号” 的这一段注释掉，因为 nemu 在 SoC 版本下没有支持 nvboard
   
   # 然后运行
   cd $RT_HOME
   make ARCH=riscv32-nemusoc run
   ```

   
