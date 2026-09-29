# UART Protocol - RTL Design & Verification

## Overview

This project implements a basic **UART (Universal Asynchronous Receiver/Transmitter)** protocol using **Verilog HDL**.

The project contains separate RTL modules for UART transmission and reception, along with testbenches for simulation and verification.

The main objective of this project is to understand UART communication, FSM-based RTL design, baud-rate timing, serial data transmission, and RTL verification using simulation.

---

## Features

- UART Transmitter (TX)
- UART Receiver (RX)
- 8-bit data transmission
- LSB-first data transmission
- Start bit
- Stop bit
- No parity bit
- Approximately 9600 baud rate
- TX Busy signal
- RX Valid signal
- TX-RX loopback testing
- Multiple data transfers
- FSM-based RTL design
---


## UART Frame Format

The UART frame used in this project is:

```text
Idle   Start   Data Bits (8)             Stop
 1       0     D0 D1 D2 D3 D4 D5 D6 D7    1


```
## Project Structure

```
UART-PROTOCOL/
│
├── uart_tx.v
├── uart_rx.v
├── tb_uart_tx.v
├── tb_uart_rx.v
├── tb_uart.v
├── README.md
├── .gitignore
└── uart_waveform.png
```

RTL Files

uart_tx.v

Implements the UART transmitter.
Converts parallel 8-bit data into serial data.
Generates start, data, and stop bits.
Uses an FSM for transmission control.

uart_rx.v

Implements the UART receiver.
Detects the start bit.
Samples incoming serial data.
Reconstructs the 8-bit received data.
Generates rx_valid when a valid byte is received.

Testbench Files

tb_uart_tx.v

Verifies the UART transmitter independently.

tb_uart_rx.v

Verifies the UART receiver independently.

tb_uart.v

Performs TX-RX loopback testing.
The transmitter output is directly connected to the receiver input.
Tests multiple 8-bit data values.


## UART TX-RX Loopback

The complete loopback connection is:
```
        +----------------+
        |  UART TX       |
        |                |
Data -->| tx_data        |
        |                |
        |       TX ------+------> RX
        +----------------+       |
                                 |
                         +-------v--------+
                         |   UART RX      |
                         |                |
                         |     rx_data    |
                         +----------------+
```
In the loopback testbench:
```
.rx(tx)
```
The TX output is directly connected to the RX input.

## Test Data

The loopback testbench uses different 8-bit data values such as:
```
10110101
11000011
01001101
10000000
11111111
```
This helps verify the UART for different data patterns.

## Baud Rate

The design uses a clock period of:
```
20 ns
```
which corresponds to a:
```
50 MHz clock
```
For approximately 9600 baud:
```
Bit period ≈ 1 / 9600
           ≈ 104.16 µs
```
The design therefore uses approximately:
```
5208 clock cycles per UART bit
```
The baud counter terminal count is:
```
13'd5207
```
The receiver also uses approximately half a bit period for start-bit validation:
```
13'd2604
```

## UART Receiver Sampling

The receiver first detects the falling edge of the start bit.
It then waits approximately half a bit period and checks whether the signal is still LOW.
If the start bit is valid, the receiver samples the data bits at approximately one-bit intervals.
```
Start Bit
    |
    v
  Center
    |
    +---- Data Bit 0
             |
             +---- Data Bit 1
                     |
                     +---- Data Bit 2
                            |
                            ...
```

## FSM Design

Transmitter FSM
```
        +------+
        | IDLE |
        +------+
           |
       tx_start
           |
           v
       +-------+
       | START |
       +-------+
           |
           v
       +------+
       | DATA |
       +------+
           |
           v
       +------+
       | STOP |
       +------+
           |
           v
        IDLE
```
Receiver FSM
```
        +------+
        | IDLE |
        +------+
           |
       rx = 0
           |
           v
       +-------+
       | START |
       +-------+
           |
           v
       +------+
       | DATA |
       +------+
           |
           v
       +------+
       | STOP |
       +------+
           |
           v
        IDLE
```

## Simulation

This project was simulated using:

Icarus Verilog
GTKWave
VS Code

Compile
```
iverilog -o uart_sim uart_tx.v uart_rx.v tb_uart.v
```

Run Simulation
```
vvp uart_sim
```

Open Waveform
```
gtkwave uart.vcd
```

## Waveform

The waveform generated during UART TX-RX simulation is included in the repository.

## Verification

The testbench verifies:

UART TX operation
UART RX operation
Start bit generation
Data bit transmission
LSB-first transmission
Stop bit generation
TX-RX loopback
Different 8-bit data patterns
tx_busy operation
rx_valid generation


## What I Learned

Through this project, I learned

UART protocol fundamentals
Serial communication
UART frame structure
Baud-rate calculation
FSM-based RTL design
TX and RX implementation
Serial-to-parallel conversion
Parallel-to-serial conversion
Testbench development
Loopback verification
Waveform debugging using GTKWave
Verilog simulation using Icarus Verilog


## Future Improvements

Possible improvements to this project include:

Parity bit support
Configurable baud rate
Parameterized data width
Oversampling in the receiver
Error detection
Framing error detection
Configurable number of stop bits
More advanced SystemVerilog-based verification


## Tools Used
Tool	                 Purpose
Verilog HDL	          RTL Design
Icarus Verilog	       Compilation & Simulation
GTKWave	Waveform      Analysis
VS Code              	Development
Git & GitHub	         Version Control


Author
Krushna Patil
RTL Design & Verification Learner
