# AMBA-APB3-VerilogHDL

This project implements the **AMBA APB3 (Advanced Peripheral Bus)** protocol using **Verilog HDL**.  
It includes a complete APB3 system design with one master and two slave modules, along with a comprehensive Verilog testbench for functional verification and code coverage.

---

## Overview

The **AMBA APB3** protocol is a simple, low-power bus designed for connecting peripherals in System-on-Chip (SoC) architectures.  
This implementation demonstrates the APB3 control logic, address decoding, and data transfer mechanism between a single master and multiple slave devices.

---

## Features

- Complete implementation of **APB3 Master and Slave interfaces**  
- Two slave modules for multi-device simulation  
- Synchronous design using Verilog HDL  
- Testbench for **verification and code coverage**  
- Verified on **Xilinx Vivado**, **Intel Quartus**, **Aldec Active-HDL**, and **Siemens QuestaSim**  
- Modular design suitable for integration with larger SoC architectures  

---

---

## RTL Schematic

![RTL Diagram](docs/rtl.png)

---

## FSM Diagram

![FSM Diagram](docs/fsm.png)

---

## Simulation and Verification

The design was simulated and verified across multiple tools to ensure portability and reliability.

**Tools Used**
- Xilinx Vivado Simulator  
- Intel Quartus Prime  
- Aldec Active-HDL  
- Siemens QuestaSim  

**Testbench Coverage**
- APB3 signal handshaking: `PSEL`, `PENABLE`, `PWRITE`, `PREADY`  
- Data read and write cycles  
- Address decoding for multiple slaves  
- Timing and synchronization verification  

---

## Future Enhancements

- Implementation of APB-to-AHB or APB-to-AXI bridge  
- Addition of programmable slave registers  
- Error signaling for invalid address access  

---

## Author

Developed by **Ishaan Bhimajiyani**  
Minor Project — Electronics and Communication Engineering

## Repository Structure

