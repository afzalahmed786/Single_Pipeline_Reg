# Single-Stage 8-Bit Pipeline Register with Valid/Ready Handshake

A robust **Verilog** implementation of a single-stage pipeline register featuring a standard **Valid/Ready handshake** (AXI-Stream style) to handle backpressure and ensure reliable data integrity between producer and consumer.

---

## **Project Overview**

This project implements a single-stage buffer that facilitates communication between two independent interfaces. It is designed to prevent data loss by using combinational backpressure logic, ensuring that the producer only sends data when the register has the capacity to store or pass it.

### **Key Features**

* **8-Bit Data Path:** Optimized for standard byte-wide data transfers.
* **Full Handshake Protocol:** Uses `valid` and `ready` signals to synchronize data movement.
* **Zero-Latency Backpressure:** The `w_ready` signal is calculated combinationally (), allowing for instant stalling.
* **Data Integrity:** Verified to prevent overwrites or dropped packets, even when the consumer stalls the output.

---

## **Design Logic**

The core of the design relies on the **Handshake Rule**: data is only sampled on the `posedge clock` if both `valid` and `ready` are high.

### **Interface Signals**

| Signal | Direction | Description |
| --- | --- | --- |
| `clock` | Input | System clock (100MHz default in TB). |
| `reset` | Input | Synchronous active-high reset. |
| **Write Port** |  | **Upstream Interface (Receiver Role)** |
| `w_data[7:0]` | Input | Incoming data payload. |
| `w_valid` | Input | High when upstream has valid data to send. |
| `w_ready` | **Output** | High when this module can accept new data. |
| **Read Port** |  | **Downstream Interface (Sender Role)** |
| `r_data[7:0]` | **Output** | Outgoing data payload. |
| `r_valid` | **Output** | High when this module has valid data to read. |
| `r_ready` | Input | High when downstream is ready to accept data. |

---

## **Verification**

The provided testbench (`pipereg_tb.v`) simulates a real-world environment where the producer is slightly slower than the consumer to ensure stability.

![alt text](https://github.com/afzalahmed786/Single_Pipeline_Reg/blob/main/output_waveform)

### **Simulation Scenarios**

1. **Ideal Stream:** Data is updated every **2 clock cycles**, providing stable timing and proving the module correctly samples sequential patterns ().
2. **Backpressure Stall:** The `r_ready` signal is pulled low while data is in flight to verify that the internal register holds the value and correctly de-asserts `w_ready` to stop the producer.

---

## **How to Run**

### **Prerequisites**

* **Icarus Verilog** (Compiler)
* **GTKWave** (Waveform Viewer)

### **Execution**

In your terminal, run the following:

    make: Compiles the source files and runs the simulation to generate the dump.vcd file.

    make waves: Opens the generated timing diagrams in GTKWave.

    make clean: Removes simulation artifacts and temporary files.

    Note: Ensure your editor uses Tab characters (not spaces) in the Makefile to avoid "missing separator" errors.
