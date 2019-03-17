![cover-photo](https://i.thenile.io/r1000/9781681746616.jpg)

# About

This repository contains a selection of proejcts from *Applied Digital Logic Exercises Using FPGAs* by Kurt Wick.

# Setup

The toolchain used for this project is Vivado 2018.1 -- you can download the free (Webpack) version here: https://www.xilinx.com/products/design-tools/vivado/vivado-webpack.html


# Installation

Each project folder contains a bitfile (.bit) which you can directly program onto compatible Xilinx FPGAs.

For development, I used a [Digilent Basys3 ](https://store.digilentinc.com/basys-3-artix-7-fpga-trainer-board-recommended-for-introductory-users/) development board, but the examples are generally hardware-agnostic as long as you provide your own constraints file and your board has the required hardware components:

* A seven-segment display
* DIP switches
* A USB interface
* At least one available PMOD connector


