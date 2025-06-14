# RI32V ISA Usage Guide

This document explains how to write assembly programs for the Simple 20‑bit RISC ISA used in the RI32V Pipeline project. It covers the available registers and the syntax for each supported instruction.

---

## 📋 Registers

The architecture provides 16 registers, referred to as `R0` through `R15`. Use these names directly in your instructions:

* `R0`: Constant zero (always reads as 0; writes are ignored)
* `R1`–`R14`: General-purpose registers for data operations
* `R15`: Used to store return address for function calls

---

## 🧠 Instruction Syntax

Write one instruction per line. Separate labels as well as operands by whitespace characters (spaces or tabs). Immediate values are integers (positive or negative). Labels (for branches) end with a colon.
Write your programs in **UPPERCASE**, as the assembler is case-sensitive and expects instructions in uppercase.

### Three-Address Instructions

| Instruction | Syntax Forms         | Description          |
| ----------- | -------------------- | -------------------- |
| `ADD`       | `ADD RD RS1 RS2/IMM` | RD = RS1 + RS2/IMM   |
| `SUB`       | `SUB RD RS1 RS2/IMM` | RD = RS1 - RS2/IMM   |
| `MUL`       | `MUL RD RS1 RS2/IMM` | RD = RS1 \* RS2/IMM  |
| `DIV`       | `DIV RD RS1 RS2/IMM` | RD = RS1 / RS2/IMM   |
| `MOD`       | `MOD RD RS1 RS2/IMM` | RD = RS1 % RS2/IMM   |
| `AND`       | `AND RD RS1 RS2/IMM` | RD = RS1 & RS2/IMM   |
| `OR`        | `OR RD RS1 RS2/IMM`  | RD = RS1 \| RS2/IMM  |
| `LSL`       | `LSL RD RS1 RS2/IMM` | RD = RS1 << RS2/IMM  |
| `LSR`       | `LSR RD RS1 RS2/IMM` | RD = RS1 >> RS2/IMM  |
| `ASR`       | `ASR RD RS1 RS2/IMM` | RD = RS1 >>> RS2/IMM |

### Two-Address Instructions

| Instruction | Syntax Forms      | Description                               |
| ----------- | ----------------- | ----------------------------------------- |
| `MOV`       | `MOV RD RS/IMM`   | RD = RS/IMM                               |
| `NOT`       | `NOT RD RS/IMM`   | RD = \~RS/IMM                             |
| `CMP`       | `CMP RS1 RS2/IMM` | Compare RS1 with RS2/IMM and update flags |

### One-Address Instructions

| Instruction | Syntax Forms  | Description                                            |
| ----------- | ------------- | ------------------------------------------------------ |
| `B`         | `B Offset`    | Unconditional branch to Offset                         |
| `BEQ`       | `BEQ Offset`  | Branch if previous comparison was equal                |
| `BGT`       | `BGT Offset`  | Branch if previous comparison was greater than         |
| `CALL`      | `CALL Offset` | Call subroutine at Offset saving return address in R15 |

### Zero-Address Instructions

| Instruction | Syntax Forms | Description                               |
| ----------- | ------------ | ----------------------------------------- |
| `NOP`       | `NOP`        | No operation (do nothing)                 |
| `RET`       | `RET`        | Return from function using address in R15 |

### Memory Instructions

| Instruction | Syntax Forms     | Description                                         |
| ----------- | ---------------- | --------------------------------------------------- |
| `LD`        | `LD RD IMM[RS1]` | Load value from memory address (RS1 + IMM) into RD  |
| `ST`        | `ST RD IMM[RS1]` | Store value from RD into memory address (RS1 + IMM) |

**Notes:**

* Immediate values can be interpreted as either **signed** or **unsigned** depending on the instruction variant:

  * Instructions ending with `U` (such as `MOVU`) treat the immediate as **unsigned**.
    For example: `MOVU RD 65535` stores the value `65535` in RD (upper bits are zeroed).
  * Instructions ending with `H` (such as `MOVH`) place the immediate in the **upper 16 bits** of the register.
    For example: `MOVH RD 65535` stores the value `4294901760` in RD (the immediate is shifted left by 16 bits).
  * Standard instructions (e.g., `MOV RD 65535` or `ADD RD RS1 -1`) treat immediates as **signed** values and store or use them as-is.
* This distinction applies to all instructions that accept immediate values and is important when constructing full 32-bit addresses or values from 16-bit parts.
* Offset values for branches are the position of the target instruction relative to the current instruction, specified as a signed integer. For example, `BEQ -10` branches to the instruction 10 positions before the current one.
* Keep in mind that the ISA does not support floating-point operations, so all arithmetic must be done using integer values.

---

## 🔗 Example Program

```assembly
MOV R1 5
MOV R2 1
MUL R2 R1 R2
SUB R1 R1 1
CMP R1 1
BGT -3
```
