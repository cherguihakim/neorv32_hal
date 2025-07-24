# FlexRisc — Custom RISC-V SoC Platform

**FlexRisc** is a flexible RISC-V System-on-Chip (SoC) prototyping platform built on a custom PCB with a Xilinx Artix-7 FPGA. It features a NEORV32 core, a custom Ada-based BIOS, and drivers for various onboard peripherals.

The goal is to provide a modular, low-level embedded system that supports real-time applications and direct hardware interfacing — from the hardware design up to a custom-developed firmware, including games and demos.

---

## 📁 Repository Structure
```text
├── demos/                  # Sample applications and BIOS
│   ├── src/
│   │   ├── bios.adb
│   │   ├── hooks.adb/.ads
│   │   ├── shooter_game.adb/.ads
│   ├── alire.toml          # Alire configuration file
│   └── demos.gpr           # GNAT project file
│
├── schematics/            # PNG images of board schematic and routing
│
├── src/
│   ├── periph/            # Ada drivers for SoC peripherals
│   ├── rv32/              # CSR-level RISC-V procedures
│   └── svd/               # Auto-generated specs from SVD
│
├── crt0.S                 # Assembly startup file
├── interrupt.adb/.ads     # Interrupt controller logic
├── link.ld                # Linker script
├── riscv-csr.ads          # Central CSR abstraction
└── trap_entry.S           # Trap and exception entry point
```

---

## 🧱 Features

- RISC-V core: [NEORV32](https://github.com/stnolting/neorv32)
- Custom Ada BIOS using [Alire](https://alire.ada.dev/)
- Peripheral drivers:
  - GPIO
  - I2C (TWI)
  - TIMER (interrupt-capable)
  - TRNG (true random number generator)
  - UART0
- Retro ASCII shooter game as test application
- Full integration with `svd2ada` for type-safe peripheral mapping

---

## 🛠️ Build Instructions

### Prerequisites

- [Alire](https://alire.ada.dev/)
- `riscv64-elf-gcc` toolchain
- `image_gen` tool for NEORV32
- `gtkterm` for serial communication

### Step-by-Step Build

1. **Build the project** `alr build`
2. **Convert ELF to binary format**  `riscv64-elf-objcopy -O binary bin/bios bin/bios.bin`
3. **Generate bootable NEORV32 image**  `image_gen -app_bin bin/bios.bin bin/bios.exe`

---

## 🔌 Uploading the Image via GtkTerm

1. Open `gtkterm` and set:
- Baud rate: `19200`
- Config: **CR LF**, **Auto**
2. Bootloader steps:
- Press `u`  
- Press `Ctrl + Shift + R` and select `bios.exe`
- Press `e` to execute the uploaded image

---

## 👤 Contributors

- **Olivier Henley** — Project supervisor and mentor (AdaCore), provided guidance, technical reviews, and support throughout the development
- **Hakim Chergui** — Embedded firmware, driver development, system integration, retro game implementation  
- **Maro Abdine**
- **Adam Taktek** - PCB schematic designer, Main PCB Layout designer
- **Christopher Krayem**
- **Onel Valery Mezil**
- **Simon Marchildon** 

---

## 🙏 Acknowledgments

Special thanks to **our mentor**, the **AdaCore** team for their support, and to the entire FlexRisc team for their dedication and technical insight throughout the project.

---
