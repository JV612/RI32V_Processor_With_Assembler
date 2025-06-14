![C++17](https://img.shields.io/badge/lang-C++17-blue)
![Verilog](https://img.shields.io/badge/core-Verilog-blueviolet)

# RI32V

A Processor with Assembler for Simulation of Assembly Programs, featuring performance-tunable pipelining configurations.

---

## 📌 Project Overview

High-level programming languages cannot interact directly with the CPU, as they are abstracted far above the machine's native instruction set. These programs are first translated into assembly language, a low-level representation of operations the hardware can understand.

This project implements a multi-stage pipelined **RI32V processor**—a hardware-accurate simulation of how a real RISC core executes machine instructions. Alongside it is a custom **assembler** that parses assembly code and generates corresponding 32-bit machine instructions. This toolchain enables testing and performance analysis across **2-stage, 3-stage, and 4-stage** pipeline configurations.

---

## 🚀 How to Run (Usage Procedure)

### 1. Clone the Repository

Clone the repository to your local machine:

```bash
git clone https://github.com/JV612/RI32V-Pipeline-Processor.git
cd RI32V-Pipeline-Processor
```

### 2. Select Pipeline Configuration

Choose an appropriate configuration (2-stage, 3-stage, or 4-stage) depending on your program's structure and performance requirements.
Refer to [Pipeline Configuration Guidelines](#pipeline-configuration-guidelines) for advice.

### 3. Write Your Assembly Program

Write your space-separated assembly code in a file named `program.asm`. Ensure it follows the RI32V ISA format.
Refer to [ISA.md](ISA.md) for the full instruction set and encoding details.

Example:

```asm
MOV R1 5
MOV R2 1
MUL R2 R1 R2
SUB R1 R1 1
CMP R1 1
BGT -3
```

### 4. Compile and Run the Assembler

Use a C++17-compatible compiler to build and run the assembler:

```bash
g++ -std=c++17 -o encode Assembler.cpp
./encode program.asm output.bin
```

### 5. Simulate the Processor

Use Icarus Verilog to compile and simulate the processor core and testbench:

```bash
iverilog -o out.vvp ProcessorCore_TB.v ProcessorCore.v
vvp out.vvp
```

> 💡 If waveform dumping is enabled, use GTKWave to view signals:

```bash
gtkwave dump.vcd
```

---

## 🧩 Pipeline Configuration Guidelines

Choose the processor configuration based on your program’s nature:

* **2-stage**: Best for short programs, frequent branches, or loops.
* **3-stage**: Suitable for general-purpose code with moderate complexity.
* **4-stage**: Ideal for long arithmetic-intensive programs with fewer hazards.

> ✅ Tip: Deeper pipelines increase performance only if the program avoids frequent hazards.

---

**Created by Jay Vaghasiya**
*Under MDG (Mobile Development Group), IIT Roorkee*
