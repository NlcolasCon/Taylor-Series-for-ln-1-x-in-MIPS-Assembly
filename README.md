# Taylor Series for ln(1+x) in MIPS Assembly

An implementation of the **Taylor Series expansion for ln(1+x)** written in **MIPS Assembly**.  
Includes both **iterative** and **recursive** versions, with support for **floating-point arithmetic** using the Coprocessor 1 (FPU).

---

## Project Explanation
The Taylor expansion of `ln(1+x)` is:
n(1+x) = Σ [ (-1)^(i+1) * (x^i) / i ], for i = 1..n

This project demonstrates:
- Implementing power and Taylor series functions in **MIPS assembly**.
- Using the **stack** to preserve registers across recursive calls.
- Floating-point operations via **Coprocessor 1 (FPU)** instructions (`add.s`, `mul.s`, `div.s`, `lwc1`, `swc1`, `c.le.s`, etc).
- Comparing results with equivalent **C implementations** to validate correctness.

---

## Repository Structure
MIPS-Taylor-Series-ln/
┣ src/
┃ ┣ exec.s # Main version with iterative + recursive Taylor series
┃ ┣ hw1.s # Integer-based implementation
┃ ┗ hw1float.s # Floating-point implementation using FPU
┣ docs/
┃ ┗ QtSpim vs C consoles.png # Example run comparison
┣ LICENSE
┣ README.md


---

## Features
- Iterative and recursive computation of Taylor series
- Floating-point support via Coprocessor 1
- Proper stack management for recursive calls
- Prints values of `ln(1+x)` for `x ∈ [0, 2]` in steps of `0.1`
- Matches C implementation outputs

---

## Usage

### Assemble & Run in QtSPIM
1. Open `exec.s` (or `hw1.s`, `hw1float.s`) in **QtSPIM**.
2. Load program into memory.
3. Run the simulation.
4. Output will print terms and computed values for comparison.

---

## Technologies
- **Language:** MIPS Assembly  
- **Simulator:** QtSPIM  
- **Math:** Taylor Series expansion for natural logarithm  

---

## Author
Developed by **Nicolas Constantinou**  
2024

---

## License
Released under the **MIT License** (see `LICENSE`).

