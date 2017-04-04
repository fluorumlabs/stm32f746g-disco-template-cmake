# STM32F746G-DISCO template
CMake (and CLion) compatible

Based on STM32CUBE FW F7 v1.6.0

## Features
None. Sets up LCD and logging, displays welcome message and blinks LED.

## Prerequisites
The *arm-none-eabi* toolchain must be installed in `Toolchain`.

This directory should contain:
- arm-none-eabi
- bin
- lib
- share

The toolchain can be downloaded from https://launchpad.net/gcc-arm-embedded/+download

## Building from command line

`CMake . && make`

## Directory structure
- `Application` - user sources go here; called from `main.c`
- `Build` - output binaries and hex
- `Drivers` - CMSIS (+DSP), HAL Driver for STM32F7xx and BSP files for STM32F746G-DISCO board as in STM32CUBE examples.
- `Inc` - include files as in STM32CUBE examples.
- `Src` - source files as in STM32CUBE examples.
- `startup` - General startup code and `syscalls.c`
- `Toolchain` - arm-none-eabi toolchain
- `Utilities` - Fonts and Log as in STM32CUBE examples.
