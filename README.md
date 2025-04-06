# 这是一个学习CPU设计的项目

分别实现了MIPS32的五级流水线CPU和LA32R的五级流水线CPU
都利用了BTB和BHT实现的分支预测以及数据前推

## MIPS32
MIPS32设计了24条指令，但是只测试了lab1的七条指令

## LA32R
LA32R设计了35条指令，并且只是测试了lab1的六条指令

---

# CPU Design Learning Project

This project implements two 5-stage pipeline CPUs: MIPS32 and LA32R. Both designs feature branch prediction using BTB and BHT, as well as data forwarding.

## Project Structure

- `MIPS32/CPUProject/` and `LA32R/CPUProject/`: Vivado projects for MIPS32 and LA32R CPUs.
  - `thinpad_top.srcs/sources_1/new/`: Main Verilog HDL source code.
  - `thinpad_top.srcs/sim_1/new/`: Simulation testbenches and models.
  - `thinpad_top.srcs/constrs_1/new/`: XDC constraint files.
  - `thinpad_top.srcs/sources_1/ip/`: Custom IP cores (if any).
  - `thinpad_top.ip_user_files/mem_init_files/`: Memory initialization files.
- `labs/`: Assembly labs and test programs.

## How to Use

1. Open the corresponding Vivado project (`thinpad_top.xpr`) in Vivado.
2. Source code is under `thinpad_top.srcs/sources_1/new/`.
3. Run simulation using testbenches in `thinpad_top.srcs/sim_1/new/`.
4. Synthesize and implement the design as usual in Vivado.

## Notes
- Only a subset of instructions are tested in the provided labs.
- All Vivado-generated intermediate files are ignored by `.gitignore`, only source, simulation, and constraint files are kept in version control.
