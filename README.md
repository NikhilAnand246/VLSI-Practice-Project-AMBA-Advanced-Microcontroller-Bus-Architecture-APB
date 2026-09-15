# APB Protocol Design & Verification using SystemVerilog

## 📌 Overview

This project implements a **simple AMBA APB (Advanced Peripheral Bus) protocol** using **SystemVerilog**.

The APB design includes an APB Master and APB Slave, with communication between them based on the APB protocol. The design is then **verified using a SystemVerilog-based verification environment**.

The main goal of this project is to understand APB protocol operation, master-slave communication, and the fundamentals of SystemVerilog-based verification.

---

## 🎯 Objectives

* Understand the working of the **AMBA APB protocol**.
* Design a basic **APB Master and APB Slave** using SystemVerilog.
* Implement APB read and write transactions.
* Develop a **SystemVerilog testbench** for verification.
* Verify correct data transfer between APB Master and Slave.
* Check APB protocol signals and transaction behavior.

---



## 🔌 APB Signals

The following APB signals are used in the design:

| Signal    | Description        |
| --------- | ------------------ |
| `PCLK`    | APB Clock          |
| `PRESETn` | Active-low reset   |
| `PADDR`   | Address bus        |
| `PSEL`    | Slave select       |
| `PENABLE` | Enable signal      |
| `PWRITE`  | Read/Write control |
| `PWDATA`  | Write data         |
| `PRDATA`  | Read data          |
| `PREADY`  | Slave ready signal |

---

## 🔄 APB Transfer

An APB transfer generally consists of two main phases:

### 1. Setup Phase

During the setup phase:

```text
PSEL    = 1
PENABLE = 0
```

The master provides:

* Address
* Write/Read control
* Write data for a write transaction

### 2. Access Phase

During the access phase:

```text
PSEL    = 1
PENABLE = 1
```

The transfer is completed when the slave asserts:

```text
PREADY = 1
```

---

## ✍️ Write Transaction

For an APB write operation:

```text
PWRITE = 1
PADDR  = Address
PWDATA  = Write Data
PSEL   = 1
PENABLE = 0 → 1
```

The master sends the address and data to the slave, and the slave stores the data at the specified address.

---

## 📖 Read Transaction

For an APB read operation:

```text
PWRITE = 0
PADDR  = Address
PSEL   = 1
PENABLE = 0 → 1
```

The slave returns the requested data through:

```text
PRDATA
```

---

## 🧪 Verification Environment

The APB design is verified using **SystemVerilog**.

The verification environment contains components such as:

```text
Test
 |
 +-- Generator
 |
 +-- Driver
 |
 +-- APB DUT
 |
 +-- Monitor
 |
 +-- Scoreboard
```

### Generator

Creates APB transactions and sends them to the driver.

### Driver

Converts transactions into APB signal-level activity and drives the DUT.

### Monitor

Observes APB signals and collects the transactions.

### Scoreboard

Compares the expected result with the actual result from the DUT.

---

## 📂 Project Structure

```text
APB/
│
├── design/
│   ├── apb_master.sv
│   └── apb_slave.sv
│
├── verification/
│   ├── apb_interface.sv
│   ├── apb_transaction.sv
│   ├── apb_generator.sv
│   ├── apb_driver.sv
│   ├── apb_monitor.sv
│   ├── apb_scoreboard.sv
│   └── apb_environment.sv
│
├── tb/
│   └── tb_apb.sv
│
└── README.md
```

> Modify the filenames above according to the actual files in your GitHub repository.

---

## 🛠️ Tools & Technologies

* **SystemVerilog**
* **AMBA APB Protocol**
* **ModelSim / QuestaSim**
* **Digital Design**
* **Simulation-based Verification**

---

## ✅ Verification

The testbench verifies:

* APB reset operation
* APB write transactions
* APB read transactions
* Address transfer
* Data transfer
* `PSEL` and `PENABLE` sequencing
* Read/write control
* Expected vs actual data

The simulation waveform can be used to observe the APB setup and access phases.

---


## 💡 Key Learning

Through this project, I gained practical understanding of:

* AMBA APB protocol
* Master-Slave communication
* APB state machine
* SystemVerilog RTL design
* SystemVerilog testbench development
* Transaction-based verification
* Generator and Driver concepts
* Monitor and Scoreboard concepts
* Simulation and waveform debugging

---


## 👨‍💻 Author

**Nikhil Anand**

PG Diploma in VLSI Design
CDAC Noida


