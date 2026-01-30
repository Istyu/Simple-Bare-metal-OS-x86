# Bare-metal x86 Menu OS

A simple **bare-metal x86 operating system project** written in **C and NASM**, booting directly via BIOS without any underlying OS or standard library.

The system loads a custom kernel, switches to **32-bit protected mode**, and displays a **keyboard-controlled text menu** using VGA text mode.

---

## ✨ Features

- Custom **512-byte bootloader** (BIOS, real mode)
- Loads kernel from floppy image
- Switches to **32-bit protected mode**
- Freestanding **C kernel** (`-ffreestanding`)
- VGA text-mode output (0xB8000)
- PS/2 keyboard input (IRQ polling)
- Interactive menu system:
  - Information screen
  - Test screen
  - System reboot

---

## 📂 Project Structure
```
baremetal
├── boot/
│ └── boot.asm # 16-bit bootloader
├── kernel/
│ ├── kernel_entry.asm # Kernel entry point (_start)
│ ├── main.c # kmain()
│ ├── video.c # VGA text output
│ ├── keyboard.c # PS/2 keyboard driver
│ ├── input.c # High-level input handling
│ ├── menu.c # Menu system
│ └── *.h # Headers
├── linker.ld # Kernel linker script
├── Makefile
└── README.md
```

---

## 🧠 How It Works (High Level)

1. **BIOS loads `boot.bin` at `0x7C00`**
2. Bootloader:
   - Initializes segments
   - Loads kernel (10 sectors) to `0x10000`
   - Sets up GDT
   - Switches to protected mode
3. Jumps to kernel entry point (`_start`)
4. Kernel:
   - Sets up stack
   - Calls `kmain()`
   - Initializes keyboard
   - Runs menu loop

---

## 🛠️ Build Requirements

- `nasm`
- `i686-elf-gcc`
- `i686-elf-ld`
- `i686-elf-objcopy`
- Windows PowerShell (for kernel padding)
- Emulator:
  - **VirtualBox** (tested)
  - QEMU should also work

> The project uses a **cross-compiler** (`i686-elf-*`).  
> Host system GCC will NOT work.

---

## ⚙️ Building

```bash
make
```

---

## This produces

- `boot.bin` – boot sector (512 bytes)
- `kernel.bin` – padded kernel (5120 bytes)
- `os.bin` – final floppy image (5632 bytes)

---

## Running (VirtualBox)

1. Running (VirtualBox)
  - Type: Other
  - Version: Other/Unknown
2. No hard disk needed
3. Attach `os.bin` as a floppy disk
4. Boot the VM

You should see a menu like:
```
> Information
  Test screen
  Restart
```

Use:
- `W` / `S` to navigate
- `Enter` to select

## Restart Implementation
The reboot option uses the classic PS/2 controller reset:
```c
outb(0xFE, 0x64);
```
